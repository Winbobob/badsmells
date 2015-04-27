require 'csv'
require 'awesome_print'
require "gnuplot"
require 'descriptive_statistics'

def draw_plot(xs, ys, title)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.title title.capitalize
      plot.terminal 'png'
      plot.output "smell_results/#{title.gsub(/\s+/, "_").downcase}.png"
      plot.style "fill solid 0.5 border"
      plot.xlabel "Label No"
      plot.ylabel "Issues"
      
      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.notitle
        ds.with = "boxes"
      end
    end
  end
end

project_no = ARGV[0]

labels = CSV.open("./feature_results/project_#{project_no}_issues_labels.csv",'r').to_a

count = Hash.new{|h, k| h[k] = 0}
label_issues = Hash.new{|h, k| h[k] = []}

labels.each do |ms|
  issue_id = ms[0]
  if ms[2] == 'labeled' && !label_issues[ms[3]].include?(issue_id)
    count[ms[3]] += 1
    label_issues[ms[3]] << issue_id 
  end
end

ap count
draw_plot((1..count.keys.count).to_a, count.values, "Project #{project_no} labels Issues")

sd = count.values.standard_deviation
mean = count.values.mean
up_range = mean + 2*sd
lower_range = mean - 2*sd
puts "sd: #{sd}"
puts "mean: #{mean}"

count.each do |k,v|
  if !v.between?(lower_range, up_range) 
    puts "Redflagged labeled: #{k} with #{v} issues"
  end
end
