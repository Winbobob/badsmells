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
      plot.ylabel "Issues"
      
      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.using = "2:xtic(1)"
        ds.notitle
      end
    end
  end
end

project_no = ARGV[0]

empty_ms = 0;

milestones = CSV.open("./feature_results/project_#{project_no}_milestones.csv",'r').to_a

total_milestones = milestones.count

count = Hash.new{|h, k| h[k] = 0}

milestones.each do |milestone|
  milestone_number = milestone[0].to_i
  count[milestone_number] = milestone[1].to_i
  if(milestone[1].to_i == 0)
      empty_ms+=1
  end
end

draw_plot(count.keys, count.values, "Project #{project_no} Issues per Milestone")

print "Empty Milestones: #{empty_ms} \n"
