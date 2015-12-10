#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "./bundle/bundler/setup"
require 'httparty'
require "alfred"

config_file = 'config.yml'
config = YAML.load_file(config_file)
api_key = config[:api_key]

if api_key.nil?
  raise 'API Key must be defined in config.yml.'
end


Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  title = ARGV[0]
  
  response = HTTParty.get('http://gowatchit.com/api/v3/search', query: { term: title }, headers: { 'X-Api-Key' => api_key })

  response['search']['movies'].each do |movie|
    fb.add_item({
      title: "#{movie['title']} (#{movie['year']})",
      subtitle: "Copy Movie ID #{movie['id']}",
      arg: movie['id'],
      # icon: movie['poster_url'],
      valid: 'yes'
    })
  end

  response['search']['shows'].each do |show|
    fb.add_item({
      title: "#{show['title']} (#{show['year']})",
      subtitle: "Copy Show ID #{show['id']}",
      arg: show['id'],
      # icon: show['poster_url'],
      valid: 'yes'
    })
  end

  puts fb.to_xml
end
