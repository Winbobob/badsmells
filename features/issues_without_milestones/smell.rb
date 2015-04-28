require 'csv'
require 'awesome_print'

project_no = ARGV[0]

issues = CSV.open("./feature_results/project_#{project_no}_issues.csv",'r').to_a

issues_without_ms = 0
total_issues = issues.count

issues.each do |issue|
  if(issue[2].eql? "yes")
      issues_without_ms+=1
  end
end

percentage = (issues_without_ms*100)/total_issues

print "Issues without milestones: #{issues_without_ms} \n"
print "Total issues: #{total_issues} \n"
print "Percentage: #{percentage}% \n"

