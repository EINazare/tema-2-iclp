processReciever = self()

defmodule NecromancerStrategy do
  def run(processReciever) do
    random = Enum.random(0..1000)
    send processReciever, {:Anti_zombie_bolt,random}
  end
end

defmodule DragonStrategy do
  def run(processReciever) do
    random = Enum.random(50..100)
    send processReciever, {:Whiptail,random}
  end
end

spawn(NecromancerStrategy,:run,[processReciever])
spawn(DragonStrategy,:run,[processReciever])

receive do
  {:Anti_zombie_bolt, msg} -> IO.puts "Necromancer hits with " <> to_string(msg)
end
receive do
  {:Whiptail, msg} -> IO.puts "Dragon hits with " <> to_string(msg)
end
