defmodule ZombieArcher do
  def start_link(pid) do
    Task.start_link(fn -> send_attack(pid) end)
    Task.start_link(fn -> recieve_attack(100,pid,self()) end)
  end
  defp recieve_attack(life,pid,selfPid) do
    cond do
      life > 0 ->
        receive do
          {:Whiptail, quantity} ->
            # IO.puts "ZombieArcher got hit for " <> to_string(quantity)
            recieve_attack(life - quantity,pid,selfPid)
          {:Dragon_breath, quantity} ->
            # IO.puts "ZombieArcher got hit for " <> to_string(quantity)
            recieve_attack(life - quantity,pid,selfPid)
        end
      life < 0 ->
        send pid, {:ZombieArcher_has_died, selfPid}
      life == 0 ->
        send pid, {:ZombieArcher_has_died, selfPid}
    end
  end
  defp send_attack(pid) do
    :timer.sleep(10)
    random = Enum.random(100..200)
    send pid, {:Shot, random}
    send_attack(pid)
  end
end

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
          {:Dragon_breath, quantity} ->
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
    Task.start_link(fn -> summon_zombie_archer(pid) end)
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
          {:Dragon_breath, quantity} ->
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
  defp summon_zombie_archer(pid) do
    :timer.sleep(20)
    send pid, {:Summon_zombie_archer}
    summon_zombie_archer(pid)
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
    attacType = Enum.random(1..100)
    cond do
      attacType < 21 ->
        random = Enum.random(50..150)
        send pid, {:Dragon_breath, random}
      attacType > 20 ->
        random = Enum.random(0..1000)
        send pid, {:Whiptail, random}
    end
    send_attack(pid)
  end
end

defmodule Server do
  def start_link do
    pid = self()
    {:ok, dragonPid} = Dragon.start_link(pid)
    {:ok, necromancerPid} = Necromancer.start_link(pid)
    loop(dragonPid,[necromancerPid],pid, [])
  end
  defp loop(dragonPid,necromancerAndArcherPids,pid, zombieKnightPids) do
    receive do
      {:Whiptail, quantity} ->
        cond do
          Enum.empty?(zombieKnightPids) ->
            randomPidToAttac = Enum.random(necromancerAndArcherPids)
            send randomPidToAttac, {:Whiptail, quantity}
            loop(dragonPid,necromancerAndArcherPids,pid,zombieKnightPids)
          ! Enum.empty?(zombieKnightPids) ->
            zombieKnightPid = Enum.random(zombieKnightPids)
            send zombieKnightPid, {:Whiptail, quantity}
            loop(dragonPid,necromancerAndArcherPids,pid,zombieKnightPids)
        end
      {:Dragon_breath, quantity} ->
        for i <- necromancerAndArcherPids, do: send i, {:Dragon_breath, quantity}
        for i <- zombieKnightPids, do: send i, {:Dragon_breath, quantity}
        loop(dragonPid,necromancerAndArcherPids,pid,zombieKnightPids)
      {:Anti_zombie_bolt, quantity} ->
        send dragonPid, {:Anti_zombie_bolt, quantity}
        loop(dragonPid,necromancerAndArcherPids,pid,zombieKnightPids)
      {:Summon_zombie_knight} ->
        {:ok, zombieKnightPid} = ZombieKnight.start_link(pid)
        loop(dragonPid,necromancerAndArcherPids,pid, zombieKnightPids ++ [zombieKnightPid])
      {:Sword_slash, quantity} ->
        send dragonPid, {:Sword_slash, quantity}
        loop(dragonPid,necromancerAndArcherPids,pid,zombieKnightPids)
      {:Shot, quantity} ->
        send dragonPid, {:Shot, quantity}
        loop(dragonPid,necromancerAndArcherPids,pid,zombieKnightPids)
      {:Dragon_has_died} ->
        [necromancerPid | _tail] = necromancerAndArcherPids
        send necromancerPid, {:Dragon_has_died}
      {:Necromancer_has_died} ->
        send dragonPid, {:Necromancer_has_died}
      {:ZombieKnight_has_died, pid} ->
        Process.exit(pid, :normal)
        loop(dragonPid,necromancerAndArcherPids,pid, zombieKnightPids -- [pid])
      {:ZombieArcher_has_died, pid} ->
        Process.exit(pid, :normal)
        loop(dragonPid,necromancerAndArcherPids -- [pid],pid, zombieKnightPids)
    end
  end
end


Server.start_link
