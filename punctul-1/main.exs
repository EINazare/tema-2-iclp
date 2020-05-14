defmodule NecromancerStrategy do
  def run(processReciever) do
    random = Enum.random(0..1000)
    send processReciever, {random}
  end
end

processReciever = self()

NecromancerStrategy.run(processReciever)

receive do
  {msg} -> IO.puts msg
end
