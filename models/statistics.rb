require 'pill_chart'

def tickets_by_commune_chart #Cantidad de Solicitudes por Comuna
  @tick = @tickets.group_by{|ticket| ticket.commune}.map{|k, v| [k, v.length]}.to_h
  @graphs = {}
  percentages = bar_data(@tick)

  colors = {
    'background' => '#d5dfef',
    'foreground' => '#0760ef',
  }
  
  commune.each do |k,v|
    value = @tick[v]
    value ||= 0
    @graphs[k] = PillChart::SimplePillChart.new(10, 100, percentages[k], 100, :simple, colors)
  end
end

def bar_data(tick)
  commune
  total_tick = tick.values.inject(0) { |sum, x| sum + x }
  percentages = {}
  commune.each do |k|
    value = tick[k]
    value ||= 0
    percentages[k] = value * 100 / total_tick
  end
  percentages
end

def top5_commune #Listar las 5 comunas que más solicitudes abrieron.
  commune_charts = @tickets.group_by{|ticket| ticket.commune}.map{|k, v| [k, v.length]}
  @top5_commune = Hash[commune_charts.sort_by { |k,v| -v }[0..4]]
end

def long5_tickets #Listar las 5 Solicitudes que más tardaron en cerrarse.
  closed_tickets = @tickets.select { |t| t.status == "Cerrado" }
  last_long = closed_tickets.sort_by { |t| [ Date.parse(t.open_date) - Date.parse(t.close_date) ] }
  @long5 = last_long[0,5]
end

def top5_category_used
  category_charts = @tickets.group_by{|ticket| ticket.category}.map{|k, v| [k, v.length]}
  @top5_category = Hash[category_charts.sort_by { |k,v| -v }[0..4]]
end

def tickets_by_day_chart
  od_tickets = @tickets.map(&:open_date)
  @days = od_tickets.group_by{|date| (Date.strptime(date,'%d/%m/%Y').strftime("%A"))}.map{|k, v| [k, v.length]}.to_h
  @graphs2 = {}
  percentages = bar_day(@days)
  colors = {
    'background' => '#d5dfef',
    'foreground' => '#0760ef',
  }
  
  days_of_week.each do |k|
    @graphs2[k] = PillChart::SimplePillChart.new(10, 100, percentages[k], 100, :simple, colors)
  end
end

def bar_day(day)
  days_of_week
  total_day = day.values.inject(0) { |sum, x| sum + x }
  percentages = {}
  days_of_week.each do |k|
    value2 = day[k]
    value2 ||= 0
    percentages[k] = value2 * 100 / total_day
  end
  percentages
end

def category_percentage
  category_charts = @tickets.group_by{|ticket| ticket.category}.map{|k, v| [k, v.length]}
  each_category = Hash[category_charts.sort_by { |k,v| -v }]
  total_categories = each_category.values.inject(0) { |sum, x| sum + x } unless each_category.values == 0
  @category_percentage = {}
  each_category.each do |k,v|
    val = each_category[k]
    val ||= 0
    @category_percentage[k] = (val * 100 / total_categories.to_f).round(2)
  end
  @category_percentage
end

def channel_percentage
  channel_charts = @tickets.group_by{|ticket| ticket.source_channel}.map{|k, v| [k, v.length]}
  each_channel = Hash[channel_charts.sort_by { |k,v| -v }]
  total_categories = each_channel.values.inject(0) { |sum, x| sum + x } unless each_channel.values == 0
  @channel_percentage = {}
  each_channel.each do |k,v|
    val = each_channel[k]
    val ||= 0
    @channel_percentage[k] = val * 100 / total_categories
  end
  @channel_percentage
end

def top5_worst_resolution #TOP5 peor promedio en el que cada comuna cierra sus resoluciones
  prom_commune = []
  closed_tickets = @tickets.select { |t| t.status == "Cerrado" }
  commune.each do |key|
    closed_t_by_commune = closed_tickets.select { |t| t.commune == key }
    qty_t_by_commune = closed_t_by_commune.count
    sum_t_by_commune = closed_t_by_commune.inject(0){|sum,e| sum + ( Date.parse(e.close_date) - Date.parse(e.open_date))}.to_i
    next if qty_t_by_commune == 0
    prom_t_by_commune = sum_t_by_commune / qty_t_by_commune
    prom_commune << [ prom_t_by_commune , key ]
  end
  @top5_worst_resolution = prom_commune.sort.reverse[0..4]
end