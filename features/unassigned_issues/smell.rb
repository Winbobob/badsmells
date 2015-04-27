require 'csv'

project_no = ARGV[0]

issues = CSV.open("./feature_results/project_#{project_no}_unassigned_issues.csv",'r').to_a

total_issues = issues.count
unassigned = issues.count{|x| x[2].empty?}

percentage = (unassigned/total_issues.to_f) * 100
puts "Total No of issues:#{total_issues}"
puts "Total No of unassigned issues:#{unassigned}"
puts "Percentage:#{percentage}"

if percentage > 20
  puts "RedFlagged project"
end
