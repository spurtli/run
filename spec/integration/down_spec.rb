# frozen_string_literal: true

RSpec.describe "`run down` command", type: :cli do
  it "executes `run help down` command successfully" do
    output = `run help down`
    expected_output = <<~OUT
      Usage:
        run down

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
