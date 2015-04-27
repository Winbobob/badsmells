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

ap issues

count = Hash.new{|h, k| h[k] = 0}

issues.each do |issue|
  milestone_number = issue[2].to_i
  if(issue[4].eql? "yes")
      count[milestone_number]+=1
  else
      count[milestone_number] = 0
  end
end

#final_count = Hash.new{|h, k| h[k] = 0}
#
#(count.keys.min..count.keys.max).each do |k|
#  final_count[k - count.keys.min + 1] = count[k]
#end
#
#ap final_count

draw_plot(count.keys, count.values, "Project #{project_no} Issues")

#sd = final_count.values.standard_deviation
#mean = final_count.values.mean
#range = mean + 2*sd
#
#puts "sd: #{sd}"
#puts "mean: #{mean}"
#puts "range: #{range}"
#final_count.each do |k,v|
#  if v > range
#    puts "Redflagged week: #{k} with #{v} commits"
#  end
#end
