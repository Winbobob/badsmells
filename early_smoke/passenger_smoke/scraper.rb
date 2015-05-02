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
authors = []

CSV.open("./feature_results/project_#{project_no}_person_commits.csv",'wb') do |csv|
  commits.each do |commit|
    if commit.commit.committer.email=~ /users\.noreply\.github\.com/
      next
    end
    if !authors.include?(commit.commit.committer.email) 
      authors << commit.commit.committer.email
    end
    new_name = authors.index(commit.commit.committer.email)
    csv << [commit.sha, commit.commit.committer.date, "Person_#{new_name}"]
  end
end

puts authors

