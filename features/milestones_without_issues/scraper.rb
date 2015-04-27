# This is the script to gather the commits from any repo in Github
# Usage: ruby ./scraper.rb repo_name
#
require 'octokit'
require 'csv'
require 'awesome_print'

repo_name =  ARGV[0]
project_no = ARGV[1]

Octokit.auto_paginate = false

milestones_open = Octokit.list_milestones(repo_name)
milestones_closed = Octokit.list_milestones(repo_name, state:'closed')

milestones = milestones_open + milestones_closed

total_milestones = milestones.count

CSV.open("./feature_results/project_#{project_no}_milestones.csv",'wb') do |csv|
  milestones.each do |milestone|
      milestone_number = milestone.number
      total_issues = milestone.open_issues + milestone.closed_issues
      csv << [milestone_number,total_issues]
  end
end