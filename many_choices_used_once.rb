# frozen_string_literal: true

class Empty < StandardError
end

State = Struct.new(:index, :length)

@state = nil

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

def with_nondeterminism
  results = [yield]

  while @state && next_index(@state)
    @state = next_index(@state)
    results << yield
  end

  results
rescue Empty
  []
end

def choose(*choices)
  raise Empty if choices.empty?

  @state = start_index(choices) if @state.nil?
  get(choices, @state)
end

result = with_nondeterminism do
  2 * choose
end

puts result.to_s
# => []

result = with_nondeterminism do
  2 * 2
end

puts result.to_s
# => [4]

result = with_nondeterminism do
  2 * choose(1, 2, 3)
end

puts result.to_s
# => [2, 4, 6]
