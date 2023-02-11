#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gastly'
require 'phantomjs'
require './utils'

PREFIX = 'results/gastly/'
FileUtils.mkdir_p(PREFIX)

urls = EduList.new('inputs/high-edu.txt').get[0..50]

urls.each do |url|
    print '.'
    screenshot = Gastly.screenshot(url, timeout: 10000)
    image = screenshot.capture
    image.format('png')
    image.save(PREFIX + "#{url.sanitize_filename}.png")
rescue StandardError => error
  File.open(PREFIX + 'fail.log', "a") { |f| f.puts "#{url} #{error.message}" }
end



