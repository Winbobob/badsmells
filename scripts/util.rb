require "gnuplot"

def draw_plot(xs, ys, title)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.title title.capitalize
      plot.terminal 'png'
      plot.output "#{title}.png"

      plot.data << Gnuplot::DataSet.new([xs,ys]) do |ds|
        ds.notitle
        ds.with = "linespoints"
      end
    end
  end
end