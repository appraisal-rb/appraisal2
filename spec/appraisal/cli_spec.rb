# frozen_string_literal: true

require "appraisal/cli"
require "appraisal/appraisal_file"

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
      :relativize => true,
    )
  end

  before do
    allow(Appraisal::AppraisalFile).to receive(:new).and_return(appraisal_file)
    allow(appraisal_file).to receive(:appraisals).and_return([appraisal])
  end

  describe "method_missing for named appraisals with install command" do
    context "when appraisal name matches and command is install" do
      it "calls install on the matching appraisal without options" do
        expect(appraisal).to receive(:install).with(hash_including(:gem_manager => "bundler"))
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install")
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
            :path => "vendor/bundle",
          ),
        )
        expect(appraisal).to receive(:relativize)

        cli.send(:method_missing, :"rails-7", "install", "--gem-manager=ore", "--jobs=4", "--path=vendor/bundle")
      end
    end

    context "when appraisal name matches and command is update" do
      it "calls update on the matching appraisal without gems or options" do
        expect(appraisal).to receive(:update).with([], hash_including(:gem_manager => "bundler"))

        cli.send(:method_missing, :"rails-7", "update")
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

        expect(Appraisal::Command).to receive(:new).with(
          ["rake", "test"],
          :gemfile => "gemfiles/rails-7.gemfile",
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
      expect(gems).to eq([])
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
  end
end
