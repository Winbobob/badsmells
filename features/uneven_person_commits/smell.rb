require 'csv'
require 'awesome_print'
require "gnuplot"

def draw_plot(xs, ys, title)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.style  "data histograms"
      plot.xtics  "nomirror rotate by -45"
      plot.title title.capitalize
      plot.terminal 'png'
      plot.output "smell_results/#{title.gsub(/\s+/, "_").downcase}.png"
      plot.style "fill solid 0.5 border"
      plot.xlabel "Person"
      plot.ylabel "Commits count"
      
      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.using = "2:xtic(1)"
        ds.notitle
      end
    end
  end
end

project_no = ARGV[0]

commits = CSV.open("./feature_results/project_#{project_no}_commits.csv",'r').to_a

count = Hash.new{|h, k| h[k] = 0}

commits.each do |commit|
  count[commit[2]] += 1
end


ap count
draw_plot(count.keys, count.values, "Project #{project_no}: User commits")

total = commits.count

count.each do |k,v|
  percentage = (v/total.to_f)*100
  if percentage > 70
    puts "Dictator person: #{k} with #{v} commits"
  end
  if percentage < 10
    puts "Freeloader person: #{k} with #{v} commits"
  end

end
