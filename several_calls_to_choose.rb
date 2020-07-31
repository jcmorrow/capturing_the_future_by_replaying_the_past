# frozen_string_literal: true

require 'pry'

State = Struct.new(:index, :length)

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

# ----------------------------------------------------------
# Pretty confident in everything above this
# ----------------------------------------------------------

def next_path(past)
  # fun next_path [] = []
  return [] if past.empty?

  # | next_path (i :: is) =
  i, *is = past.reverse

  # case next_idx i of
  if next_index(i)
    # SOME i' => i' :: is
    [*is, next_index(i)]
  else
    # | NONE => next_path is
    next_path(is)
  end
end

def with_nondeterminism(&block)
  v = [block.call]
  # binding.pry
  next_future = next_path(@past)
  # puts("next_future: #{next_future.inspect}")
  @past = []
  @future = next_future
  return v if @future.empty?

  [*v, *with_nondeterminism(&block)]
rescue Empty
  []
end

def choose(*choices)
  raise Empty if choices.empty?

  i = @future.shift || start_index(choices)
  @past.unshift(i)
  get(choices, i)
end

result = with_nondeterminism do
  choose(1, 2) * choose(3, 4)
end

puts(result.inspect)
# => [3, 4, 6, 8]
