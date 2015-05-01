require 'csv'
require 'awesome_print'
require "gnuplot"
require 'descriptive_statistics'
require 'time'

def draw_plot(xs, ys, title)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.style  "data histograms"
      plot.xtics  "nomirror rotate by -45"
      plot.title title.capitalize
      plot.terminal 'png'
      plot.output "smell_results/#{title.gsub(/\s+/, "_").downcase}.png"
      plot.style "fill solid 0.5 border"
      plot.xlabel "Label"
      plot.ylabel "Time"

      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.using = "2:xtic(1)"
        ds.notitle
      end
    end
  end
end

project_no = ARGV[0]

events = CSV.open("./feature_results/project_#{project_no}_time_label.csv",'r').to_a


final_count = {}
final_count['labels'] = {}
events.each do |e|
  issue_number = e[0]
  action = e[2]
  if action == 'unlabeled' || action == 'labeled'
    label = e[3]
    final_count['labels']["#{issue_number}$$_$$#{label}"] ||=  []
    final_count['labels']["#{issue_number}$$_$$#{label}"] << e[1]
  end
  if action == 'closed'
    final_count["closed_date"] ||= {}
    final_count["closed_date"][issue_number] = e[1]
  end
end


final_count['labels'].each do |k,v|
  if v.count.odd?
    final_count['labels'][k] << final_count['closed_date'][k.split('$$_$$')[0]]
  end
end

count = Hash.new { |hash, key| hash[key] = 0 }
final_count['labels'].each do |k,v|
  v.each do |s,e|
    count[k.split('$$_$$').last] +=  (s.to_i - e.to_i).to_f/(60*60)
  end
end
ap count
draw_plot((1..count.keys.count).to_a, count.values, "Project #{project_no} Label Vs Time")

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






