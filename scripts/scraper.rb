#
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'
require './util.rb'

repo_name =  ARGV[0]

Octokit.auto_paginate = true

commits = Octokit.commits(repo_name)

count = Hash.new{|h, k| h[k] = 0}

CSV.open("#{repo_name.gsub('/','_')}_commits.csv",'wb') do |csv|
  commits.each do |commit|
    week_no = commit.commit.committer.date.strftime('%W').to_i
    csv << [commit.sha, commit.commit.committer.name, commit.commit.committer.date, week_no]
    count[week_no]+=1
  end
end

final_count = Hash.new{|h, k| h[k] = 0}

(count.keys.min..count.keys.max).each do |k|
  final_count[k - count.keys.min + 1] = count[k]
end

ap final_count
draw_plot(final_count.keys, final_count.values, 'commits')
