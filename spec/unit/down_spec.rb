# frozen_string_literal: true

require "run/commands/down"

RSpec.describe Run::Commands::Down do
  it "executes `down` command successfully" do
    output = StringIO.new
    options = {}
    command = described_class.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
