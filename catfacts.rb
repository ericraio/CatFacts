require 'rubygems'
require 'google_text'
require 'highline/import'
require 'timeout'

class CatFacts

  def initialize
    puts "What is your Google Email?"
    username = gets.chomp
    password = ask("What is your Google Password?\n") { |q| q.echo = false }
    GoogleText.configure {|config| config.email, config.password = username, password}
  end

  def send_sms
    puts "What is the number you want to send to?"
    number = gets.chomp

    puts 'What is their name?'
    name = gets.chomp

    greeting = GoogleText::Message.new(:text => "Hello #{name}, thanks for signing up to CatFacts! You will receive a free cat fact every 10 secs! Text 'Cat' to stop receiving CatFacts!", :to => number)
    greeting.send

    6.times do
      file = File.read('catfacts').split(/\n/)
      fact = file[Random.rand(file.size)][0..-2]
      message = GoogleText::Message.new(:text => fact, :to => number)
      message.send
      puts "Sent This Cat Fact: #{fact}"
      sleep(10)
    end
  end

end

cf = CatFacts.new
cf.send_sms
