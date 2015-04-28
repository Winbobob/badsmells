require 'csv'
require 'awesome_print'

project_no = ARGV[0]

issues = CSV.open("./feature_results/project_#{project_no}_issues.csv",'r').to_a

issues_without_desc = 0
total_issues = issues.count

ap issues

issues.each do |issue|
  if(issue[1].eql? "yes")
      issues_without_desc+=1
  end
end

percentage = (issues_without_desc*100)/total_issues

print "Issues without description: #{issues_without_desc} \n"
print "Total issues: #{total_issues} \n"
print "Percentage: #{percentage}% \n"

