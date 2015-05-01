# This is the script to gather the commits from any repo in Github
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'

repo_name =  ARGV[0]
project_no = ARGV[1]

Octokit.auto_paginate = true


events = Octokit.repository_issue_events(repo_name)


CSV.open("./feature_results/project_#{project_no}_time_label.csv",'wb') do |csv|
  events.each do |event|
    if event.issue.pull_request 
      next
    end
    issue_id = event.issue.number
    created_at = event.created_at.to_i
    action = event.event
    label_name = event.label.name rescue ""
    csv << [issue_id, created_at, action, label_name]
  end
end

