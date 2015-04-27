require 'csv'

project_no = ARGV[0]

issues = CSV.open("./feature_results/project_#{project_no}_issues.csv",'r').to_a

real_issues = issues.count{|x| x[3] == 'issue'}
pull_requests = issues.count{|x| x[3] == 'pull_request'}

total_issues = issues.count

percentage = (pull_requests/real_issues.to_f) * 100
puts "Total No of Issues:#{real_issues}"
puts "Total No of pull_requests:#{pull_requests}"
puts "Percentage:#{percentage}"

if percentage < 50
  puts "RedFlagged project"
end
