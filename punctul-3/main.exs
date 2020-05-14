defmodule ZombieKnight do
  def start_link(pid) do
    Task.start_link(fn -> send_attack(pid) end)
    Task.start_link(fn -> recieve_attack(600,pid,self()) end)
  end
  defp recieve_attack(life,pid,selfPid) do
    cond do
      life > 0 ->
        receive do
          {:Whiptail, quantity} ->
            # IO.puts "ZombieKnight got hit for " <> to_string(quantity)
            recieve_attack(life - quantity,pid,selfPid)
        end
      life < 0 ->
        send pid, {:ZombieKnight_has_died, selfPid}
      life == 0 ->
        send pid, {:ZombieKnight_has_died, selfPid}
    end
  end
  defp send_attack(pid) do
    :timer.sleep(5)
    random = Enum.random(20..50)
    send pid, {:Sword_slash, random}
    send_attack(pid)
  end
end

defmodule Necromancer do
  def start_link(pid) do
    Task.start_link(fn -> summon_zombie_knight(pid) end)
    Task.start_link(fn -> send_attack(pid) end)
    Task.start_link(fn -> recieve_attack(10000,pid) end)
  end
  defp recieve_attack(life,pid) do
    cond do
      life > 0 ->
        receive do
          {:Whiptail, quantity} ->
            # IO.puts "Necromancer got hit for " <> to_string(quantity)
            recieve_attack(life - quantity,pid)
          {:Dragon_has_died} -> IO.puts "A castigat necromancer-ul si a ramas cu " <> to_string(life) <> " cantitate de viata."
        end
      life < 0 ->
        send pid, {:Necromancer_has_died}
      life == 0 ->
        send pid, {:Necromancer_has_died}
    end
  end
  defp send_attack(pid) do
    :timer.sleep(12)
    random = Enum.random(0..1000)
    send pid, {:Anti_zombie_bolt, random}
    send_attack(pid)
  end
  defp summon_zombie_knight(pid) do
    :timer.sleep(20)
    send pid, {:Summon_zombie_knight}
    summon_zombie_knight(pid)
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
          {:Anti_zombie_bolt, quantity} ->
            # IO.puts "Dragon got hit by Necromancer for " <> to_string(quantity)
            recieve_attack(life - quantity,pid)
          {:Sword_slash, quantity} ->
            # IO.puts "Dragon got hit by ZombieKnight for " <> to_string(quantity)
            recieve_attack(life - quantity,pid)
          {:Necromancer_has_died} -> IO.puts "A castigat dragonul si a ramas cu " <> to_string(life) <> " cantitate de viata."
        end
      life < 0 ->
        send pid, {:Dragon_has_died}
      life == 0 ->
        send pid, {:Dragon_has_died}
    end
  end
  defp send_attack(pid) do
    :timer.sleep(5)
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
    loop(dragonPid,necromancerPid,pid, [])
  end
  defp loop(dragonPid,necromancerPid,pid, zombieKnightPids) do
    receive do
      {:Whiptail, quantity} ->
        cond do
          Enum.empty?(zombieKnightPids) ->
            send necromancerPid, {:Whiptail, quantity}
            loop(dragonPid,necromancerPid,pid,zombieKnightPids)
          ! Enum.empty?(zombieKnightPids) ->
            zombieKnightPid = Enum.random(zombieKnightPids)
            send zombieKnightPid, {:Whiptail, quantity}
            loop(dragonPid,necromancerPid,pid,zombieKnightPids)
        end
      {:Anti_zombie_bolt, quantity} ->
        send dragonPid, {:Anti_zombie_bolt, quantity}
        loop(dragonPid,necromancerPid,pid,zombieKnightPids)
      {:Summon_zombie_knight} ->
        {:ok, zombieKnightPid} = ZombieKnight.start_link(pid)
        loop(dragonPid,necromancerPid,pid, zombieKnightPids ++ [zombieKnightPid])
      {:Sword_slash, quantity} ->
        send dragonPid, {:Sword_slash, quantity}
        loop(dragonPid,necromancerPid,pid,zombieKnightPids)
      {:Dragon_has_died} ->
        send necromancerPid, {:Dragon_has_died}
      {:Necromancer_has_died} ->
        send dragonPid, {:Necromancer_has_died}
      {:ZombieKnight_has_died, pid} ->
        Process.exit(pid, :normal)
        loop(dragonPid,necromancerPid,pid, zombieKnightPids -- [pid])
    end
  end
end


Server.start_link
