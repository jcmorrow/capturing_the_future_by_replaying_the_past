# frozen_string_literal: true

# withNondeterminism (fn()⇒2*choose []);
# valit = []:int list
# withNondeterminism (fn()⇒2*choose [1, 2, 3]);
# valit = [2,4,6]:int list

@state = nil

def start_index(choices)
  [0, choices.count]
end

def next_index(state)
  if state[0] + 1 == state[1]
    nil
  else
    [state[0] + 1, state[1]]
  end
end

def get(choices, state)
  choices[state[0]]
end

def with_nondeterminism
  results = []
  yield if @state.nil?

  while @state
    results << yield
    @state = next_index(@state)
  end

  results
end

def choose(*choices)
  return [] if choices.empty?

  @state = start_index(choices) if @state.nil?
  get(choices, @state)
end

result = with_nondeterminism do
  2 * choose(1, 2, 3)
end

puts result.to_s
# => [2, 4, 6]
