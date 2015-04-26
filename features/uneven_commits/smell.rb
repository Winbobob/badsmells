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
      plot.xlabel "Week No"
      plot.ylabel "Commits"
      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.notitle
        ds.with = "boxes"

      end
    end
  end
end

project_no = ARGV[0]

commits = CSV.open("./feature_results/project_#{project_no}_commits.csv",'r').to_a

count = Hash.new{|h, k| h[k] = 0}

commits.each do |commit|
  week_no = commit[2].to_i
  count[week_no]+=1
end

final_count = Hash.new{|h, k| h[k] = 0}

(count.keys.min..count.keys.max).each do |k|
  final_count[k - count.keys.min + 1] = count[k]
end

ap final_count
draw_plot(final_count.keys, final_count.values, "Project #{project_no} commits")

sd = final_count.values.standard_deviation
mean = final_count.values.mean
range = mean + 2*sd

puts "sd: #{sd}"
puts "mean: #{mean}"
puts "range: #{range}"
final_count.each do |k,v|
  if v > range
    puts "Redflagged week: #{k} with #{v} commits"
  end
end
