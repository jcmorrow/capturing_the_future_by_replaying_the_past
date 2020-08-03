# frozen_string_literal: true

def capture_continuation(&block)
  block
end

puts 'What is your name?'
name = gets
# => Josh

continuation = capture_continuation do
  puts "Hello #{name}"
end

puts(
  'See, I can do whatever I want with this. For example, I could call it twice:'
)

continuation.call
# => Hello Josh
continuation.call
# => Hello Josh

puts 'or I could redefine puts:'

def puts(string)
  print(string.chars.join(' '))
end

continuation.call
# => 72 101 108 108 111 32 74 111 115 104
#    H  e   l   l   o      J  o   s   h
