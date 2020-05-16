defmodule Necromancer do
  def start_link do
    Task.start_link(fn -> recieve_attack(10000,nil,nil) end)
  end
  defp recieve_attack(life,pid,send_attack_pid) do
    cond do
      life > 0 ->
        receive do
          {:Dragon_pid, pid} ->
            {:ok, send_attack_pid} = Task.start_link(fn -> send_attack(pid) end)
            recieve_attack(life,pid,send_attack_pid)
          {:Whiptail, quantity} ->
            recieve_attack(life - quantity,pid,send_attack_pid)
          {:Dragon_has_died} ->
            IO.puts "A castigat necromancer-ul si a ramas cu " <> to_string(life) <> " cantitate de viata."
            Process.exit(send_attack_pid, :kill)
            Process.exit(self(), :normal)
        end
      life < 0 || life == 0 ->
        send pid, {:Necromancer_has_died}
        Process.exit(send_attack_pid, :kill)
        Process.exit(self(), :normal)
    end
  end
  defp send_attack(pid) do
    random = Enum.random(0..1000)
    send pid, {:Anti_zombie_bolt, random}
    send_attack(pid)
  end
end

defmodule Dragon do
  def start_link do
    Task.start_link(fn -> recieve_attack(1000000,nil,nil) end)
  end
  defp recieve_attack(life,pid,send_attack_pid) do
    cond do
      life > 0 ->
        receive do
          {:Necromancer_pid, pid} ->
            {:ok, send_attack_pid} = Task.start_link(fn -> send_attack(pid) end)
            recieve_attack(life,pid,send_attack_pid)
          {:Anti_zombie_bolt, quantity} ->
            recieve_attack(life - quantity,pid,send_attack_pid)
          {:Necromancer_has_died} ->
            IO.puts "A castigat dragonul si a ramas cu " <> to_string(life) <> " cantitate de viata."
            Process.exit(send_attack_pid, :kill)
            Process.exit(self(), :normal)
          end
      life < 0 || life == 0 ->
        send pid, {:Dragon_has_died}
        Process.exit(send_attack_pid, :kill)
        Process.exit(self(), :normal)
    end
  end
  defp send_attack(pid) do
    random = Enum.random(50..100)
    send pid, {:Whiptail, random}
    send_attack(pid)
  end
end

{:ok, dragonPid} = Dragon.start_link
{:ok, necromancerPid} = Necromancer.start_link

send dragonPid, {:Necromancer_pid, necromancerPid}
send necromancerPid, {:Dragon_pid, dragonPid}
