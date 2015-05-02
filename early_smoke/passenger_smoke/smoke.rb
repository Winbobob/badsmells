require 'csv'
require 'awesome_print'
require "gnuplot"
require 'descriptive_statistics'
require 'time'
project_no = ARGV[0]
def get_sum(weekno, h)
  i = 0
  h.each do |k,v|
    if weekno>=k
      i+=v
    end
  end
  return i
end

def elbow_plot(xs, ys)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.title "Person's commit % vs Time"
      plot.terminal 'png'
      plot.output "smell_results/project_3_person_2.png"
      plot.xlabel "Weeks"
      plot.ylabel "% of commits till week X"

      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.notitle
        ds.with = "linespoints"
      end
    end
  end
end

commits = CSV.open("./project_#{project_no}_person_commits.csv",'r').to_a

min = commits.map do |commit|
  Time.parse(commit[1]).strftime('%W').to_i
end.min

max = commits.map do |commit|
  Time.parse(commit[1]).strftime('%W').to_i
end.max

commits.map! do |commit|
  commit << Time.parse(commit[1]).strftime('%W').to_i - min + 1
end

count = Hash.new { |hash, key| hash[key] = 0  }
(1..max-min+1).each do |i|
  count[i] = 0
end

commits.each do |c|
  count[c.last] +=1
end

count_person = Hash.new { |hash, key| hash[key] = 0  }

commits.each do |c|
  count_person[c.last] +=1 if c[-2] == 'Person_2'
end

final_count = {}
count.each do |k, v|
  final_count[k] = get_sum(k,count_person)/get_sum(k,count).to_f * 100
end

elbow_plot(final_count.keys, final_count.values)
p final_count[(count.keys.last* 0.25).to_i]
p final_count[(count.keys.last* 0.5).to_i]
p final_count[(count.keys.last* 0.75).to_i]
ap final_count
