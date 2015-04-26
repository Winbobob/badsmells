# This is the script to gather the commits from any repo in Github
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'

repo_name =  ARGV[0]
project_no = ARGV[1]

Octokit.auto_paginate = true

commits = Octokit.commits(repo_name)

CSV.open("./feature_results/project_#{project_no}_commits.csv",'wb') do |csv|
  commits.each do |commit|
    week_no = commit.commit.committer.date.strftime('%W').to_i
    csv << [commit.sha, commit.commit.committer.date, week_no]
  end
end

