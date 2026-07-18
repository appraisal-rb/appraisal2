# frozen_string_literal: true

require "appraisal/cli"
require "appraisal/appraisal_file"
require "timeout"

RSpec.describe Appraisal::CLI do
  include_context "with bundler gem manager mocked"
  include_context "with ore gem manager mocked"

  let(:cli) { described_class.new }
  let(:appraisal_file) { instance_double(Appraisal::AppraisalFile) }
  let(:appraisal) do
    instance_double(
      Appraisal::Appraisal,
      :name => "rails-7",
      :write_gemfile => true,
      :install => true,
      :update => true,
      :relativize => true
    )
  end

  before do
    allow(Appraisal::AppraisalFile).to receive(:new).and_return(appraisal_file)
    allow(appraisal_file).to receive(:appraisals).and_return([appraisal])
  end

  describe "#generate" do
    let(:first_appraisal) { instance_double(Appraisal::Appraisal, :write_gemfile => true) }
    let(:second_appraisal) { instance_double(Appraisal::Appraisal, :write_gemfile => true) }

    it "generates appraisal gemfiles in parallel when jobs is greater than one" do
      runner = nil

      begin
        entered = Queue.new
        release = Queue.new

        allow(cli).to receive_messages(
          :appraisals => [first_appraisal, second_appraisal],
          :options => {"jobs" => 2}
        )
        [first_appraisal, second_appraisal].each do |current_appraisal|
          allow(current_appraisal).to receive(:write_gemfile) do
            entered << true
            release.pop
          end
        end

        runner = Thread.new { cli.generate } # rubocop:disable ThreadSafety/NewThread

        Timeout.timeout(1) do
          2.times { entered.pop }
        end
        2.times { release << true }
        runner.join

        expect(first_appraisal).to have_received(:write_gemfile)
        expect(second_appraisal).to have_received(:write_gemfile)
      ensure
        runner.kill if runner && runner.alive?
      end
    end

    it "uses APPRAISAL_JOBS when jobs is not passed" do
      stub_env("APPRAISAL_JOBS" => "2")
      allow(cli).to receive_messages(
        :appraisals => [first_appraisal, second_appraisal],
        :options => {}
      )
      expect(cli).to receive(:generate_appraisals).with([first_appraisal, second_appraisal], "2")

      cli.generate
    end
  end

  describe "method_missing for named appraisals with install command" do
    context "when appraisal name matches and command is install" do
      it "calls install on the matching appraisal without options" do
        expect(appraisal).not_to receive(:write_gemfile)
        expect(appraisal).to receive(:install).with(hash_including(:gem_manager => "bundler"))
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install")
      end

      it "generates before installing when command is generate-install" do
        expect(appraisal).to receive(:write_gemfile)
        expect(appraisal).to receive(:install).with(hash_including(:gem_manager => "bundler"))
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "generate-install")
      end

      it "generates only the matching appraisal when command is generate" do
        expect(appraisal).to receive(:write_gemfile)
        expect(appraisal).not_to receive(:install)

        cli.send(:method_missing, :"rails-7", "generate")
      end

      it "calls install with gem_manager option when --gem-manager=ore is provided" do
        expect(appraisal).to receive(:install).with(hash_including(:gem_manager => "ore"))
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install", "--gem-manager=ore")
      end

      it "calls install with gem_manager option when -g ore is provided" do
        expect(appraisal).to receive(:install).with(hash_including(:gem_manager => "ore"))
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install", "-g", "ore")
      end

      it "calls install with jobs option" do
        expect(appraisal).to receive(:install).with(hash_including(:jobs => 4))
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install", "--jobs=4")
      end

      it "calls install with multiple options" do
        expect(appraisal).to receive(:install).with(
          hash_including(
            :gem_manager => "ore",
            :jobs => 4,
            :path => "vendor/bundle"
          )
        )
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install", "--gem-manager=ore", "--jobs=4", "--path=vendor/bundle")
      end
    end

    context "when appraisal name matches and command is update" do
      it "calls update on the matching appraisal without gems or options" do
        expect(appraisal).not_to receive(:write_gemfile)
        expect(appraisal).to receive(:update).with([], hash_including(:gem_manager => "bundler"))

        cli.send(:method_missing, :"rails-7", "update")
      end

      it "generates before updating when command is generate-update" do
        expect(appraisal).to receive(:write_gemfile)
        expect(appraisal).to receive(:update).with([], hash_including(:gem_manager => "bundler"))

        cli.send(:method_missing, :"rails-7", "generate-update")
      end

      it "calls update with gem_manager option" do
        expect(appraisal).to receive(:update).with([], hash_including(:gem_manager => "ore"))

        cli.send(:method_missing, :"rails-7", "update", "--gem-manager=ore")
      end

      it "calls update with gem names" do
        expect(appraisal).to receive(:update).with(["rails", "rack"], hash_including(:gem_manager => "bundler"))

        cli.send(:method_missing, :"rails-7", "update", "rails", "rack")
      end

      it "calls update with gem names and options" do
        expect(appraisal).to receive(:update).with(["rails"], hash_including(:gem_manager => "ore"))

        cli.send(:method_missing, :"rails-7", "update", "rails", "--gem-manager=ore")
      end
    end

    context "when appraisal name matches but command is not install or update" do
      it "runs the command as an external command" do
        command_double = instance_double(Appraisal::Command)
        allow(appraisal).to receive(:gemfile_path).and_return("gemfiles/rails-7.gemfile")

        allow(Appraisal::Command).to receive(:new).with(
          ["rake", "test"],
          :gemfile => "gemfiles/rails-7.gemfile"
        ).and_return(command_double)
        expect(command_double).to receive(:run)

        cli.send(:method_missing, :"rails-7", "rake", "test")
      end
    end
  end

  describe "parse_external_options" do
    it "parses --gem-manager option" do
      result = cli.send(:parse_external_options, ["--gem-manager=ore"])
      expect(result).to eq(:gem_manager => "ore")
    end

    it "parses -g option" do
      result = cli.send(:parse_external_options, ["-g", "ore"])
      expect(result).to eq(:gem_manager => "ore")
    end

    it "parses --jobs option" do
      result = cli.send(:parse_external_options, ["--jobs=4"])
      expect(result).to eq(:jobs => 4)
    end

    it "parses -j option" do
      result = cli.send(:parse_external_options, ["-j4"])
      expect(result).to eq(:jobs => 4)
    end

    it "parses multiple options" do
      result = cli.send(:parse_external_options, ["--gem-manager=ore", "--jobs=4", "--path=vendor/bundle"])
      expect(result).to eq(:gem_manager => "ore", :jobs => 4, :path => "vendor/bundle")
    end
  end

  describe "extract_gems_and_options" do
    it "extracts gem names without options" do
      gems, options = cli.send(:extract_gems_and_options, ["rails", "rack"])
      expect(gems).to eq(["rails", "rack"])
      expect(options).to eq({})
    end

    it "extracts options without gem names" do
      gems, options = cli.send(:extract_gems_and_options, ["--gem-manager=ore"])
      expect(gems).to be_empty
      expect(options).to eq(:gem_manager => "ore")
    end

    it "extracts both gem names and options" do
      gems, options = cli.send(:extract_gems_and_options, ["rails", "rack", "--gem-manager=ore"])
      expect(gems).to eq(["rails", "rack"])
      expect(options).to eq(:gem_manager => "ore")
    end

    it "handles -g shorthand correctly" do
      gems, options = cli.send(:extract_gems_and_options, ["rails", "-g", "ore"])
      expect(gems).to eq(["rails"])
      expect(options).to eq(:gem_manager => "ore")
    end

    it "handles repeated values correctly (reproducibility test)" do
      # appraisal rails-7 update ore -g ore
      gems, options = cli.send(:extract_gems_and_options, ["ore", "-g", "ore"])
      expect(gems).to eq(["ore"])
      expect(options).to eq(:gem_manager => "ore")
    end
  end
end
