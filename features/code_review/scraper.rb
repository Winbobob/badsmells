# This is the script to gather the issues from any repo in Github
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'

repo_name =  ARGV[0]
project_no = ARGV[1]

Octokit.auto_paginate = true

issues = Octokit.list_issues(repo_name, state: 'closed')

real_issues = issues.reject(&:pull_request)
pull_requests = issues.select(&:pull_request)

no_unassigned_issues = 0
CSV.open("./feature_results/project_#{project_no}_issues.csv",'wb') do |csv|
  issues.each do |issue|
    if issue.pull_request
      action = "pull_request"
    else
      action = 'issue'
    end     
    csv << [issue.number, issue.title, issue.user.id, action]     
  end  
end

