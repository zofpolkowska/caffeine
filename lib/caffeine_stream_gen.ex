defmodule Caffeine.Stream.Gen do
  import Caffeine.Element
  import Caffeine.Stream

  def natural() do
    natural(0)
  end

  defp natural(n) do
    rest = fn -> natural(n+1) end
    Caffeine.Stream.construct(n, rest)
  end

  def repeat(number) do
    rest = fn -> repeat(number) end
    Caffeine.Stream.construct(number, rest)
  end

  def integer(start_value) do
    rest = fn -> integer(start_value + 1) end
    Caffeine.Stream.construct(start_value, rest)
  end

  def squares() do
    squares(0, 0)
  end

  def squares(n) do
    squares(:math.pow(n, 2), n)
  end

  defp squares(p, n) do
    rest = fn -> squares(:math.pow(n + 1, 2), n + 1) end
    Caffeine.Stream.construct(p, rest)
  end

  def odds() do
    odds(1)
  end

  def odds(n) when rem(n,2) === 0 do
    # TODO: defmodule MyError
    raise "Argument to start with is not an odd number"
  end

  def odds(n) do
    rest = fn -> odds(n + 2) end
    Caffeine.Stream.construct(n, rest)
  end

  def even() do
    even(0)
  end

  def even(n) when rem(n,2) !== 0 do
    # TODO: defmodule MyError
    raise "Argument to start with is not an even number"
  end

  def even(n) do
    rest = fn -> even(n + 2) end
    Caffeine.Stream.construct(n, rest)
  end

  def range(first, step \\ 1, last)
  
  def range(last, _step, last) do
    rest = fn -> sentinel() end
    Caffeine.Stream.construct(last, rest)
  end
  
  def range(first, step, last) do
    rest = fn -> range(first + step, step, last) end
    Caffeine.Stream.construct(first, rest)
  end

  def list([]) do
    sentinel()
  end

  def list([h|t]) do
    rest = fn -> list(t) end
    Caffeine.Stream.construct(h, rest)
  end

  def fibonacci() do
    fibonacci(0, 1)
  end

  defp fibonacci(m, n) do
    rest = fn -> fibonacci(n, m + n) end
    Caffeine.Stream.construct(m, rest)
  end

  def factorial() do
    factorial(1, 0)
  end

  defp factorial(f, n) do
    rest = fn -> factorial(f*(n + 1), (n + 1)) end
    Caffeine.Stream.construct(f, rest)
  end

  def file(path) do
    {:ok, pid} = File.open(path, [:read])
    file(pid, IO.read(pid, :line))
  end

  # TODO
  def file(pid, :eof) do
    :io.setopts([encoding: :latin1])
    File.close(pid)
    sentinel()
  end
  def file(pid, line) do
    rest = fn -> file(pid, IO.read(pid, :line)) end
    Caffeine.Stream.construct(line, rest)
  end

  # TODO primenumbers
end
