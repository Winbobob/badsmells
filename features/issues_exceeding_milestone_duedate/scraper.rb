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

CSV.open("./feature_results/project_#{project_no}_issues.csv",'wb') do |csv|
  issues.each do |issue|
      if issue.milestone != nil && issue.pull_request == nil
          issue_id = issue.id
          issue_closed_at = issue.closed_at
          milestone_number = issue.milestone.number
          milestone_due_on = issue.milestone.due_on
          smell = ""
          if(issue_closed_at != nil && milestone_due_on !=nil)
            if issue_closed_at > milestone_due_on
                smell = "yes"
            else
                smell = "no"
            end
          end
          csv << [issue_id,issue_closed_at,milestone_number,milestone_due_on,smell]
      end
  end
end