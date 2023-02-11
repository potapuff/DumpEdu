#!/usr/bin/env ruby
# frozen_string_literal: true

require 'watir-screenshot-stitch'
require './utils'

POOL_SIZE = 3
PREFIX = 'results/watir/'
FileUtils.mkdir_p(PREFIX)
options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])

urls = EduList.new('inputs/high-edu.txt').get.reverse
puts "Total: #{urls.size}"
done = EduList.new(PREFIX+'done.log').get rescue []
urls = urls - done
puts "Will be processed: #{urls.size}"
workers = (POOL_SIZE).times.map do
  Thread.new do
    while url = urls.pop()
      begin
        b = Watir::Browser.new :firefox#, options: options
        b.driver.manage.window.maximize
        b.goto url
        path = PREFIX + "#{url.sanitize_filename}.png"
        opts = {}#{ :page_height_limit => 10000 }
        b.screenshot.save_stitch(path, opts)
        File.open(PREFIX + 'done.log', "a") { |f| f.puts "#{url}" }
        puts url
      rescue StandardError => error
        puts "#{url} #{error.message}"
        File.open(PREFIX + 'fail.log', "a") { |f| f.puts "#{url} #{error.message}" }
      ensure
        b.close if b
      end
    end
  rescue ThreadError
  end
end

workers.map(&:join)


