defmodule Necromancer do
  def start_link(pid) do
    Task.start_link(fn -> send_attack(pid) end)
    Task.start_link(fn -> recieve_attack(10000,pid) end)
  end
  defp recieve_attack(life,pid) do
    cond do
      life > 0 ->
        receive do
          {:Whiptail, quantity} -> recieve_attack(life - quantity,pid)
          {:Dragon_has_died} -> IO.puts "A castigat necromancer-ul si a ramas cu " <> to_string(life) <> " cantitate de viata."
        end
      life < 0 ->
        send pid, {:Necromancer_has_died}
      life == 0 ->
        send pid, {:Necromancer_has_died}
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
    Task.start_link(fn -> send_attack(pid) end)
    Task.start_link(fn -> recieve_attack(1000000,pid) end)
  end
  defp recieve_attack(life,pid) do
    cond do
      life > 0 ->
        receive do
          {:Anti_zombie_bolt, quantity} -> recieve_attack(life - quantity,pid)
          {:Necromancer_has_died} -> IO.puts "A castigat dragonul si a ramas cu " <> to_string(life) <> " cantitate de viata."
        end
      life < 0 ->
        send pid, {:Dragon_has_died}
      life == 0 ->
        send pid, {:Dragon_has_died}
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
    pid = self()
    {:ok, dragonPid} = Dragon.start_link(pid)
    {:ok, necromancerPid} = Necromancer.start_link(pid)
    loop(dragonPid,necromancerPid)
  end
  defp loop(dragonPid,necromancerPid) do
    receive do
      {:Whiptail, quantity} ->
        send necromancerPid, {:Whiptail, quantity}
        loop(dragonPid,necromancerPid)
      {:Anti_zombie_bolt, quantity} ->
        send dragonPid, {:Anti_zombie_bolt, quantity}
        loop(dragonPid,necromancerPid)
      {:Dragon_has_died} ->
        send necromancerPid, {:Dragon_has_died}
      {:Necromancer_has_died} ->
        send dragonPid, {:Necromancer_has_died}
    end
  end
end


Server.start_link
