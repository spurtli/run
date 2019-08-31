# frozen_string_literal: true

require "run/commands/up"

RSpec.describe Run::Commands::Up do
  it "executes `up` command successfully" do
    output = StringIO.new
    options = {}
    command = described_class.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
