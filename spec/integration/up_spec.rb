# frozen_string_literal: true

RSpec.describe "`run up` command", type: :cli do
  it "executes `run help up` command successfully" do
    output = `run help up`
    expected_output = <<~OUT
      Usage:
        run up

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
