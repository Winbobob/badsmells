# This is the script to gather the time for every milestones from any repo in Github
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'

repo_name =  ARGV[0]
project_no = ARGV[1]

Octokit.auto_paginate = true

issues = Octokit.list_issues(repo_name, {state: 'closed'})
created_at = nil
CSV.open("./feature_results/project_#{project_no}_milestones.csv",'wb') do |csv|
  milestones.each do |ms|
    if ms.number ==  1 
      created_at = ms.created_at
    end
    days = (ms.closed_at.to_date - created_at.to_date).round
    
    csv << [ms.number, ms.title, created_at, ms.closed_at, days]
    
    created_at = ms.closed_at
  end
end

