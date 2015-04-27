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


CSV.open("./feature_results/project_#{project_no}_issues_labels.csv",'wb') do |csv|
  events.each do |event|
    issue_id = event.issue.number
    next if event.label.nil?
    created_at = event.created_at
    action = event.event
    label_name = event.label.name
    csv << [issue_id, created_at, action, label_name]
  end
end

