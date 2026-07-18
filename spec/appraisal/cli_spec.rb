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

    it "generates appraisal gemfiles in parallel when appraisal jobs is greater than one" do
      runner = nil

      begin
        entered = Queue.new
        release = Queue.new

        allow(cli).to receive_messages(
          :appraisals => [first_appraisal, second_appraisal],
          :options => {"appraisal-jobs" => 2}
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

    it "uses APPRAISAL_JOBS when appraisal jobs is not passed" do
      stub_env("APPRAISAL_JOBS" => "2")
      allow(cli).to receive_messages(
        :appraisals => [first_appraisal, second_appraisal],
        :options => {}
      )
      expect(cli).to receive(:generate_appraisals).with([first_appraisal, second_appraisal], "2")

      cli.generate
    end

    it "defaults to two appraisal workers" do
      allow(cli).to receive_messages(
        :appraisals => [first_appraisal, second_appraisal],
        :options => {}
      )
      expect(cli).to receive(:generate_appraisals).with([first_appraisal, second_appraisal], 2)

      cli.generate
    end

    it "allows explicit serial appraisal processing" do
      allow(cli).to receive_messages(
        :appraisals => [first_appraisal, second_appraisal],
        :options => {"appraisal-jobs" => 1}
      )
      expect(cli).to receive(:generate_appraisals).with([first_appraisal, second_appraisal], 1)

      cli.generate
    end
  end

  describe "#install" do
    let(:first_appraisal) { instance_double(Appraisal::Appraisal, :install => true, :relativize => true) }
    let(:second_appraisal) { instance_double(Appraisal::Appraisal, :install => true, :relativize => true) }

    it "uses separate job counts for appraisal workers and gem manager workers" do
      allow(cli).to receive_messages(
        :appraisals => [first_appraisal, second_appraisal],
        :options => {"appraisal-jobs" => 2, "jobs" => 4}
      )

      expect(cli).to receive(:each_appraisal).with([first_appraisal, second_appraisal], 2).and_call_original

      cli.install

      expect(first_appraisal).to have_received(:install).with(hash_including("jobs" => 4))
      expect(second_appraisal).to have_received(:install).with(hash_including("jobs" => 4))
      expect(first_appraisal).not_to have_received(:install).with(hash_including("appraisal-jobs" => 2))
      expect(second_appraisal).not_to have_received(:install).with(hash_including("appraisal-jobs" => 2))
    end
  end

  describe "#update" do
    let(:first_appraisal) { instance_double(Appraisal::Appraisal, :update => true) }
    let(:second_appraisal) { instance_double(Appraisal::Appraisal, :update => true) }

    it "updates appraisals in parallel when appraisal jobs is greater than one" do
      allow(cli).to receive_messages(
        :appraisals => [first_appraisal, second_appraisal],
        :options => {"appraisal-jobs" => 2}
      )

      expect(cli).to receive(:each_appraisal).with([first_appraisal, second_appraisal], 2).and_call_original

      cli.update("rack")

      expect(first_appraisal).to have_received(:update).with(["rack"], {})
      expect(second_appraisal).to have_received(:update).with(["rack"], {})
    end
  end

  describe "#worker_count" do
    it "uses requested workers when Bundler is modern enough for isolated parallel subprocesses" do
      bundler_spec = instance_double(Gem::Specification, :version => Gem::Version.new("2.1.0"))
      allow(Gem::Specification).to receive(:find_all_by_name).with("bundler").and_return([bundler_spec])

      expect(cli.send(:worker_count, 2, 3)).to eq(2)
    end

    it "falls back to serial processing when Bundler is older than the isolation floor" do
      bundler_spec = instance_double(Gem::Specification, :version => Gem::Version.new("1.17.3"))
      allow(Gem::Specification).to receive(:find_all_by_name).with("bundler").and_return([bundler_spec])

      expect(cli.send(:worker_count, 2, 3)).to eq(1)
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

    context "when no appraisal name matches" do
      let(:first_appraisal) do
        instance_double(Appraisal::Appraisal, :name => "rails-7", :gemfile_path => "gemfiles/rails-7.gemfile")
      end
      let(:second_appraisal) do
        instance_double(Appraisal::Appraisal, :name => "rails-8", :gemfile_path => "gemfiles/rails-8.gemfile")
      end

      it "runs the external command across appraisals with APPRAISAL_JOBS workers" do
        first_command = instance_double(Appraisal::Command, :run => true)
        second_command = instance_double(Appraisal::Command, :run => true)

        stub_env("APPRAISAL_JOBS" => "2")
        stub_const("ARGV", ["rake", "test"])
        allow(appraisal_file).to receive(:appraisals).and_return([first_appraisal, second_appraisal])
        allow(Appraisal::Command).to receive(:new)
          .with(["rake", "test"], :gemfile => "gemfiles/rails-7.gemfile")
          .and_return(first_command)
        allow(Appraisal::Command).to receive(:new)
          .with(["rake", "test"], :gemfile => "gemfiles/rails-8.gemfile")
          .and_return(second_command)

        expect(cli).to receive(:each_appraisal).with([first_appraisal, second_appraisal], "2").and_call_original

        cli.send(:method_missing, :rake, "test")

        expect(first_command).to have_received(:run)
        expect(second_command).to have_received(:run)
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

    it "consumes --appraisal-jobs without forwarding it to dependency commands" do
      result = cli.send(:parse_external_options, ["--appraisal-jobs=2"])
      expect(result).to eq({})
    end

    it "consumes -n without forwarding it to dependency commands" do
      result = cli.send(:parse_external_options, ["-n", "2", "--jobs=4"])
      expect(result).to eq(:jobs => 4)
    end

    it "consumes --appraisal-jobs with a separate value" do
      result = cli.send(:parse_external_options, ["--appraisal-jobs", "2", "--jobs=4"])
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

    it "does not treat appraisal job values as gem names" do
      gems, options = cli.send(:extract_gems_and_options, ["rails", "-n", "2"])
      expect(gems).to eq(["rails"])
      expect(options).to eq({})
    end

    it "handles repeated values correctly (reproducibility test)" do
      # appraisal rails-7 update ore -g ore
      gems, options = cli.send(:extract_gems_and_options, ["ore", "-g", "ore"])
      expect(gems).to eq(["ore"])
      expect(options).to eq(:gem_manager => "ore")
    end
  end
end
