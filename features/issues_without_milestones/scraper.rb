# This is the script to gather the commits from any repo in Github
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'

repo_name =  ARGV[0]
project_no = ARGV[1]

Octokit.auto_paginate = true

issues = Octokit.list_issues(repo_name, state:'closed')

total_issues = issues.count

CSV.open("./feature_results/project_#{project_no}_issues.csv",'wb') do |csv|
  issues.each do |issue|
      if issue.pull_request == nil
          issue_id = issue.id
          smell = ""
          milestone_number = ""
          if issue.milestone == nil
              smell = "yes"
          else
              milestone_number = issue.milestone.number.to_s
              smell = "no"
          end
          csv << [issue_id,milestone_number,smell]
      end
  end
end
