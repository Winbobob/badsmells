require 'csv'
require 'awesome_print'
require "gnuplot"
require 'descriptive_statistics'

#def draw_plot(xs, ys, title)
#  Gnuplot.open do |gp|
#    Gnuplot::Plot.new(gp) do |plot|
#      plot.style  "data histograms"
#      plot.xtics  "nomirror rotate by -45"
#      plot.title title.capitalize
#      plot.terminal 'png'
#      plot.output "smell_results/#{title.gsub(/\s+/, "_").downcase}.png"
#      plot.style "fill solid 0.5 border"
#      plot.xlabel "Milestone Number"
#      plot.ylabel "Issues exceeding milestone due date"
#      
#      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
#        ds.using = "2:xtic(1)"
#        ds.notitle
#      end
#    end
#  end
#end
project_no = ARGV[0]

issues = CSV.open("./feature_results/project_#{project_no}_issues.csv",'r').to_a

ap issues

m_array = []
issues.each do |issue|
    m_array.push(issue[2])
end

m_count = m_array.uniq.count

m_count.times do |m|
   open_count = 0
   close_count = 0
   issues.each do |issue|
       if(issue[2].to_i == (m+1))
           if(issue[4].eql? ("open"))
               open_count+=1
           else
               close_count+=1
           end
       end
   end
   total_count = open_count + close_count
   percentage = (open_count*100)/total_count
   if percentage > 50
       print "Milestone #{m+1} may not complete before it's due date because it has more than 50% issues (#{percentage}) left open on the last day before its due date. This is an early smoke.\n"
   end
end