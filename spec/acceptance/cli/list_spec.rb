# frozen_string_literal: true

RSpec.describe "CLI", ".list" do
  it "prints list of appraisals" do
    build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
      appraise '1.0.0' do
        gem 'dummy', '1.0.0'
      end
      appraise '2.0.0' do
        gem 'dummy', '1.0.0'
      end
      appraise '1.1.0' do
        gem 'dummy', '1.0.0'
      end
    APPRAISAL

    output = run "appraisal list"

    expect(output).to include("1.0.0\n2.0.0\n1.1.0\n")
  end

  it "prints nothing if there are no appraisals in the file" do
    skip_for(:engine => :jruby)
    build_appraisal_file ""
    output = run "appraisal list"

    # Filter out Ruby 2.7-3.0 keyword argument warnings from Thor
    # These warnings appear on Ruby <= 3.0 but not on Ruby >= 3.1
    filtered_output = output.lines.reject { |line| line.include?("warning:") }.join("\n---\n")

    expect(filtered_output).to eq("")
  end
end
