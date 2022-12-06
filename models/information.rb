require 'date'
require 'byebug'

def ticket_by_commune
  info_commune = @tickets.group_by{|ticket| ticket.commune}.map{|k, v| [k, v.length]}
  top_commune = info_commune.sort_by { |k,v| -v }[0]
  @commune = top_commune[0]
  @cant_tickets = top_commune[1]
end

def top_open_date
  info_date = @tickets.group_by{|ticket| ticket.open_date}.map{|k, v| [k, v.length]}
  top_date = info_date.sort_by { |k,v| -v }[0]
  @date = top_date[0]
end

def month_top_close
  arr = @tickets.select{|ticket| ticket.status == 'Cerrado'}.map(&:close_date)
  info_month = arr.group_by{|date| (Date.strptime(date,'%d/%m/%y').strftime("%B"))}.map{|k, v| [k, v.length]}
  top_month = info_month.sort_by { |k,v| -v }[0]
  @month = top_month[0]
end

def aged_ticket #¿Cuál es la comuna con la solicitud que más tiempo lleva abierta?
  ot = @tickets.select { |t| t.status == "Abierto" }
  if ot.empty?
    @result_aged_ticket = "No hay tickets en estado 'Abierto' para calcular"
  else
    @result_aged_ticket = ot.first {|obj| Date.strptime(obj.open_date,'%d/%m/%Y')}.commune
  end
  
end

def more_than_one_week #Cuántas solicitudes llevan Abiertas más de 1 semana?
  ot = @tickets.select { |t| t.status == "Abierto" }
  now = Date.today.strftime("%d/%m/%Y")
  week_ago = Date.parse(now) - 7
  @mtw = ot.select { |obj| Date.strptime(obj.open_date,'%d/%m/%Y') < week_ago}.count
end

def category_by_other
  arr = @tickets.select{|ticket| ticket.gender == 'otro'}.map(&:category)
  freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  if freq.empty?
    @cat_by_gender_other = "No hay ningún ticket abierto que cumpla esta condici&oacute;n"
  else
    @cat_by_gender_other = arr.max_by { |v| freq[v] }
  end
end

def category_by_female
  arr = @tickets.select{|ticket| ticket.gender == 'femenino'}.map(&:category)
  freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  if freq.empty?
    @cat_by_gender_female = "No hay ningún ticket abierto que cumpla esta condici&oacute;n"
  else
    @cat_by_gender_female = arr.max_by { |v| freq[v] }
  end
end

def category_by_male
  arr = @tickets.select{|ticket| ticket.gender == 'masculino'}.map(&:category)
  freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  if freq.empty?
    @cat_by_gender_male = "No hay ningún ticket abierto que cumpla esta condici&oacute;n"
  else
    @cat_by_gender_male = arr.max_by { |v| freq[v] }
  end
end

def list_tickets_by_month(inputMonth = 0)
  ct = @tickets.select { |t| t.status == "Cerrado" }
  @query = ct.select { |t| Date.parse(t.open_date).month == inputMonth.to_i && Date.parse(t.close_date).month == inputMonth.to_i }
  @no_info = "EL MES INGRESADO NO TIENE RESULTADOS PARA MOSTRAR. Ingrese nuevo mes a buscar" if @query.empty?
  @no_info = "Ingrese el numero de MES para listar tickets Abiertos/Cerrados en el mismo" if inputMonth == 0
end