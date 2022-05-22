# frozen_string_literal: true


State = Struct.new(:index, :length) do
  def inspect
    "(#{index}, #{length})"
  end
end

@past = []
@future = []

class Empty < StandardError
end

def start_index(choices)
  State.new(0, choices.count)
end

def next_index(state)
  if state.index + 1 == state.length
    nil
  else
    State.new(state.index + 1, state.length)
  end
end

def get(choices, state)
  choices[state.index]
end

def next_path(past)
  # fun next_path [] = []
  return [] if past.empty?

  # | next_path (i :: is) =
  i, *is = past

  # case next_idx i of
  if next_index(i)
    # SOME i' => i' :: is
    [next_index(i), *is]
  else
    # | NONE => next_path is
    next_path(is)
  end
end

def with_nondeterminism(&block)
  v = [block.call]
  next_future = next_path(@past).reverse
  @past = []
  @future = next_future
  return v if @future.empty?

  [*v, *with_nondeterminism(&block)]
rescue Empty
  []
end

def choose(*choices)
  # fun choose [] = raise Empty
  raise Empty if choices.empty?

  # | choose xs = case pop future of
  # NONE => (* no future: start an index; push it into the past *)
  # let val i = start_idx xs in
  # | SOME i => (push past i; get xs i)
  i = @future.shift || start_index(choices)
  puts("Using: #{i.inspect}")
  @past.unshift(i)
  get(choices, i)
end

result = with_nondeterminism do
  a = choose(true, false)
  if a
    [a, choose(5, 6)]
  else
    [a, choose(7, 8, 9)]
  end
end

puts(result.inspect)
