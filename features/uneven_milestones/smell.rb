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
      plot.xlabel "Milestone No"
      plot.ylabel "No of days"
      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.notitle
        ds.with = "boxes"
      end
    end
  end
end

project_no = ARGV[0]

milestones = CSV.open("./feature_results/project_#{project_no}_milestones.csv",'r').to_a

count = Hash.new{|h, k| h[k] = 0}

milestones.each do |ms|
  count[ms[0].to_i] = ms[4].to_i
end


ap count
draw_plot(count.keys, count.values, "Project #{project_no} milestones")

sd = count.values.standard_deviation
mean = count.values.mean
up_range = mean + 2*sd
lower_range = mean - 2*sd
puts "sd: #{sd}"
puts "mean: #{mean}"

count.each do |k,v|
  if !v.between?(lower_range, up_range) 
    puts "Redflagged milestone: #{k} with #{v} days"
  end
end
