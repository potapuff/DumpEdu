#!/usr/bin/env ruby
# frozen_string_literal: true

require 'selenium-webdriver'
require './utils'

PREFIX = 'results/selenium/'
FileUtils.mkdir_p(PREFIX)

urls = EduList.new('inputs/high-edu.txt').get[0..50]

driver = Selenium::WebDriver.for :firefox
driver.manage.timeouts.implicit_wait = 10 # seconds
driver.manage.window.maximize
urls.each do |url|
  print '.'
  driver.navigate.to url
  driver.save_screenshot(PREFIX + "#{url.sanitize_filename}.png")
rescue StandardError => error
  File.open(PREFIX + 'fail.log', "a") { |f| f.puts "#{url} #{error.message}" }
end
driver.close


