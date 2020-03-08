#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'optparse'

class HNJobScraper
  attr_reader :threads, :jobs

  def initialize
    @jobs = []
    @threads = {}
  end

  def get_by_id(id)
    uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
    Net::HTTP.get_response(uri)
  end

  def get_jobs_thread(id)
    response = get_by_id(id)
    if response.code == '200'
      parsed = JSON.parse(response.body)
      unless /Ask HN: Who is hiring\?/.match?(parsed['title'])
        raise ArgumentError "#{id} is not a Who is hiring? thread"
      end

      @threads[id] = parsed
      get_jobs(@threads[id])
    end
    response.code
  end

  def get_jobs(thread)
    puts 'Downloading job data.'
    thread['kids'].each.with_index do |id, i|
      percentage = ((i.to_f / thread['kids'].size) * 100).to_i
      printf("\r#{percentage}%%", percentage)
      response = get_by_id(id)
      @jobs.push(JSON.parse(response.body)) if response.code == '200'
    end
    printf("\r100%%\n\n")
  end

  def filter(pattern)
    raise TypeError unless pattern.class == Regexp

    matches = []
    @jobs.each do |job|
      unless job['text'].nil?
        matches.push(job) if pattern.match(job['text'])
      end
    end
    matches
  end
end

class OrgPrinter
  def initialize(filename)
    @file = File.open(filename, 'w')
  end

  def write(text)
    @file.puts '* ' + text.gsub('<p>', "\n\n")
                          .gsub('<a href="', '[[')
                          .gsub('" rel="nofollow">', '][')
                          .gsub('</a>', ']]')
                          .gsub('*', '-')
                          .gsub('&#x2F;', '/')
                          .gsub('&#x27;', "'")
                          .gsub('&amp;', '&')
                          .gsub('&lt;', '<')
                          .gsub('&gt;', '>')
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: hn_jobs.rb [options]'

  opts.on('-i', '--id ID', "HackerNews 'Who is hiring?' item id") do |id|
    options[:id] = id
  end

  opts.on('-f', '--filter FILTER', 'Regular expression to filter jobs') do |f|
    options[:filter] = Regexp.new(f, 'i')
  end

  opts.on('-o', '--output FILENAME', 'File to write') do |outfile|
    options[:outfile] = outfile
  end
end.parse!

outfile = options[:outfile].nil? ? 'jobs.org' : options[:outfile]
scraper = HNJobScraper.new
unless options[:id].nil?
  response = scraper.get_jobs_thread(options[:id])
  unless response == '200'
    raise IOError, "Received response #{response} from HN API"
  end

  matches = if options[:filter].nil?
              scraper.jobs
            else
              scraper.filter(options[:filter])
            end
  printer = OrgPrinter.new(outfile)
  matches.each do |job|
    printer.write(job['text'])
  end
  puts "Wrote #{outfile}."
end
