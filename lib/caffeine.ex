defmodule Caffeine do
  @moduledoc """
  ![Coffee Bean Boundary](./coffee.jpeg)

  A stream library with an emphasis on simplicity
  """

  defmodule Stream do
    @moduledoc """
    Find the API under this module
    """

    @typedoc """
    The Caffeine.Stream data structure
    """
    @opaque t :: nonempty_improper_list(term, (() -> t)) | []

    @doc """
    A special value whose presence signals the end of a stream
    """
    @spec sentinel() :: []
    def sentinel do
      []
    end

    @doc """
    A predicate to test for the sentinel value
    """
    @spec sentinel?(t) :: boolean
    def sentinel?([]) do
      true
    end

    def sentinel?([_ | x]) when is_function(x, 0) do
      false
    end

    @spec construct?(t) :: boolean
    def construct?([_ | x]) when is_function(x, 0) do
      true
    end

    def construct?([]) do
      false
    end

    def construct(x, y) when is_function(y, 0) do
      pair(x, y)
    end

    @doc """
    Extracts _n_ consecutive elements from the stream

    A list of less than _n_ elements out if it reaches the sentinel.
    """
    @spec take(t, integer) :: list
    def take([], _) do
      []
    end

    def take(_, 0) do
      []
    end

    def take(x, n) when is_integer(n) and n > 0 do
      [head(x) | take(tail(x), n - 1)]
    end

    @doc """
    A simple map

    The output stream is the input stream w/ the function _f_ applied to each of the elements.
    """
    @spec map(t, (term -> term)) :: t
    def map(s, f) do
      cond do
        Caffeine.Stream.sentinel?(s) ->
          Caffeine.Stream.sentinel()

        Caffeine.Stream.construct?(s) ->
          g = fn ->
            map(tail(s), f)
          end

          construct(f.(head(s)), g)
      end
    end

    @doc """
    The first element, if any, of the stream
    """
    @spec head(t) :: term
    def head(x) do
      hd(x)
    end

    @doc """
    The stream, if any, succeeding the first element
    """
    @spec tail(t) :: t
    def tail(x) do
      release(tl(x))
    end

    @spec release((() -> t)) :: t
    defp release(x) do
      x.()
    end

    defp pair(h, r) do
      [h | r]
    end
  end
end
