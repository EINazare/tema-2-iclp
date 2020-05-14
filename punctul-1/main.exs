defmodule Necromancer do
  def start_link(pid) do
    Task.start_link(fn -> recieve_attack(10000) end)
    Task.start_link(fn -> send_attack(pid) end)
  end
  defp recieve_attack(life) do
    cond do
      life > 0 ->
        receive do
          {:Whiptail, quantity} -> recieve_attack(life - quantity)
        end
      life < 0 ->
        IO.puts "Necromancer has died"
      life == 0 ->
        IO.puts "Necromancer has died"
    end
  end
  defp send_attack(pid) do
    random = Enum.random(0..1000)
    send pid, {:Anti_zombie_bolt, random}
    send_attack(pid)
  end
end

defmodule Dragon do
  def start_link(pid) do
    Task.start_link(fn -> recieve_attack(1000000) end)
    Task.start_link(fn -> send_attack(pid) end)
  end
  defp recieve_attack(life) do
    cond do
      life > 0 ->
        receive do
          {:Anti_zombie_bolt, quantity} -> recieve_attack(life - quantity)
        end
      life < 0 ->
        IO.puts "Dragon has died"
      life == 0 ->
        IO.puts "Dragon has died"
    end
  end
  defp send_attack(pid) do
    random = Enum.random(0..1000)
    send pid, {:Whiptail, random}
    send_attack(pid)
  end
end

defmodule Server do
  def start_link do
    {:ok, dragonPid} = Dragon.start_link(self())
    {:ok, necromancerPid} = Necromancer.start_link(self())
    Task.start_link(fn -> loop(dragonPid,necromancerPid) end)
  end
  defp loop(dragonPid,necromancerPid) do
    receive do
      {:Whiptail, quantity} ->
        send dragonPid, {:Whiptail, quantity}
        loop(dragonPid,necromancerPid)
      {:Anti_zombie_bolt, quantity} ->
        send necromancerPid, {:Anti_zombie_bolt, quantity}
        loop(dragonPid,necromancerPid)
    end
  end
end


Server.start_link
