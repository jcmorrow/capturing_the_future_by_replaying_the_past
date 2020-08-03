# frozen_string_literal: true

def capture_continuation(&block)
  block
end

puts 'What is your name?'
name = gets

continuation = capture_continuation do
  puts "Hello #{name}"
end

puts 'See, I can do whatever I want with this now. For example, I could call it twice:'

continuation.call
continuation.call

puts 'or I could redefine puts:'

def puts(string)
  print("#{string.bytes.join(' ')}\n")
end

continuation.call
