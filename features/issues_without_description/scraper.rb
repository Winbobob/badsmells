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
          if issue.body.eql? ""
              smell = "yes"
          else
              smell = "no"
          end
          csv << [issue_id,smell]
      end
  end
end
