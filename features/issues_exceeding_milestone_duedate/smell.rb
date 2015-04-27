require 'csv'
require 'awesome_print'
require "gnuplot"
require 'descriptive_statistics'

def draw_plot(xs, ys, title)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.style  "data histograms"
      plot.xtics  "nomirror rotate by -45"
      plot.title title.capitalize
      plot.terminal 'png'
      plot.output "smell_results/#{title.gsub(/\s+/, "_").downcase}.png"
      plot.style "fill solid 0.5 border"
      plot.xlabel "Milestone Number"
      plot.ylabel "Issues exceeding milestone due date"
      
      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.using = "2:xtic(1)"
        ds.notitle
      end
    end
  end
end
project_no = ARGV[0]

issues = CSV.open("./feature_results/project_#{project_no}_issues.csv",'r').to_a

issues_exceeding = 0
total_issues = issues.count

count = Hash.new{|h, k| h[k] = 0}

issues.each do |issue|
  milestone_number = issue[2].to_i
  if(issue[4].eql? "yes")
      issues_exceeding+=1
      count[milestone_number]+=1
  else
      count[milestone_number] = 0
  end
end

percentage = (issues_exceeding*100)/total_issues
draw_plot(count.keys, count.values, "Project #{project_no} Issues")

print "Issues exceeding: #{issues_exceeding} \n"
print "Total issues: #{total_issues} \n"
print "Percentage: #{percentage}%"

