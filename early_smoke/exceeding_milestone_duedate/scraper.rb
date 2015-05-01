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

issues_minus_pr = []
issues.each do |issue|
  if issue.pull_request == nil
    issues_minus_pr.push(issue)
  end
end

issues_minus_pr.sort_by! {|obj| obj.closed_at}


CSV.open("./smoke_scrap_data/project_#{project_no}_issues.csv",'wb') do |csv|
  issues_minus_pr.each do |issue|
    status = ""
    if issue.milestone != nil
      issue_id = issue.id
      issue_closed_at = issue.closed_at
      milestone_number = issue.milestone.number
      milestone_due_on = issue.milestone.due_on - (24 * 60 * 60)
      if issue_closed_at > milestone_due_on
        status = "open"
      else
        status = "closed"
      end
      csv << [issue_id,issue_closed_at,milestone_number,milestone_due_on,status]
    end
  end
end
