require 'sinatra'
require 'byebug'
require 'shotgun'
require 'date'
require 'pill_chart'
require_relative 'models/persistence_and_csv.rb'
require_relative 'models/fixed_options_types.rb'

get '/' do
	@title = "Atencion Ciudadana"
	@home_selected_in_nav = true

  erb :index
end

get '/all_tickets' do
	@title = "tickets"
	@errors = []
	@tickets_list_selected_in_nav = true
	persistence_manager = PersistenceManager.new()
	tickets_list = persistence_manager.get_tickets_from_disk
	@tickets = tickets_list.sort_by { |obj| Date.strptime(obj.open_date,'%d/%m/%Y')}.reverse
	erb :list_all_tickets
end

get '/ticket/:id' do
  persistence_manager = PersistenceManager.new()
	@ticket = persistence_manager.get_ticket(params[:id])

  erb :ticket_details
end

get '/edit_ticket/:id' do
	@title = "Edit ticket"
	source_channel
	type_of_ticket
	commune
	categories
	persistence_manager = PersistenceManager.new()
	@current_ticket = persistence_manager.get_ticket(params[:id])

  erb :edit_ticket
end

put '/edit_ticket/:id' do
  source_channel
	type_of_ticket
	commune
	categories
  persistence_manager = PersistenceManager.new
	@ticket = persistence_manager.get_ticket(params[:id])

		@ticket.id = (params[:id].to_i)
		@ticket.category = params[:category]
		@ticket.type_of_ticket = params[:type_of_ticket]
		#@ticket.open_date = Date.today.strftime('%d/%m/%Y') --> Si se pide reiniciar la apertura al dia de la modificacion
		@ticket.open_date = params[:open_date]
		@ticket.commune = params[:commune]
		@ticket.neighbordhood = params[:neighbordhood].upcase
		@ticket.street = params[:street].upcase
		@ticket.number = params[:number]
		@ticket.source_channel = params[:source_channel]
		@ticket.gender = params[:gender]
		@ticket.close_date = ''

    persistence_manager.edit_ticket(@ticket)
		@success = true
		
  erb :ticket_details
end

get '/add_ticket' do
	@title = "New ticket"
	@add_ticket_list_selected_in_nav = true
	source_channel
	type_of_ticket
	commune
	categories
	persistence_manager = PersistenceManager.new()
	tickets = persistence_manager.get_tickets_from_disk
	last_ticket = tickets.max_by {|k| k.id }
	@next_id = last_ticket.id + 1

	erb :add_ticket
end

post '/add_ticket' do
	persistence_manager = PersistenceManager.new()
	id = (params[:id]).to_i
	category = params[:category]
	type_of_ticket = params[:type_of_ticket]
	open_date = Date.today.strftime('%d/%m/%Y')
	commune = params[:commune]
	neighbordhood = params[:neighbordhood]
	street = params[:street]
	number = params[:number]
	source_channel = params[:source_channel]
	gender = params[:gender]
	close_date = ''
	@ticket = Ticket.new(id, category, type_of_ticket, open_date, commune, neighbordhood, street, number, source_channel, gender, close_date)
	persistence_manager.add_ticket(@ticket)

	erb :new_ticket
end

get '/close_ticket/:id' do
	source_channel
	type_of_ticket
	commune
	categories
  persistence_manager = PersistenceManager.new
	@ticket_to_close = persistence_manager.get_ticket(params[:id])

	erb :close_ticket
end

get '/close_confirmation/:id' do
	source_channel
	type_of_ticket
	commune
	categories
	persistence_manager = PersistenceManager.new
	@ticket_to_close = persistence_manager.get_ticket(params[:id])
	@ticket_to_close.status = "Cerrado"
	@ticket_to_close.close_date=Date.today.strftime('%d/%m/%Y')
	persistence_manager.edit_ticket(@ticket_to_close)

	erb :close_ticket
end

get '/cancel_ticket/:id' do
	source_channel
	type_of_ticket
	commune
	categories
  persistence_manager = PersistenceManager.new
	@ticket_to_cancel = persistence_manager.get_ticket(params[:id])

	erb :cancel_ticket
end

get '/cancel_confirmation/:id' do
	source_channel
	type_of_ticket
	commune
	categories
	persistence_manager = PersistenceManager.new
	@ticket_to_cancel = persistence_manager.get_ticket(params[:id])
	@ticket_to_cancel.status = "Cancelado"
	@ticket_to_cancel.close_date=Date.today.strftime('%d/%m/%Y')
	persistence_manager.edit_ticket(@ticket_to_cancel)

	erb :cancel_ticket
end

get '/all_categories' do
	@title = "Categories"
	@errors = []
	@categories_list_selected_in_nav = true
	persistence_manager = PersistenceManager.new()
	@categories = persistence_manager.get_categories_from_disk

	erb :list_all_categories
end

get '/add_category' do
	@title = "New Category"
	@add_category_list_selected_in_nav = true

	erb :add_category
end

post '/add_category' do
	@title = "New Category"
	persistence_manager = PersistenceManager.new()
	@new_category = (params[:new_category]).upcase
	persistence_manager.add_category(@new_category)
	@categories = persistence_manager.get_categories_from_disk

	@new_cat = @categories.last
	erb :new_category
end

get '/information' do
	require_relative 'models/information.rb'
	@information_selected_in_nav = true
	persistence_manager = PersistenceManager.new()
	@tickets = persistence_manager.get_tickets_from_disk
	ticket_by_commune
	top_open_date
	month_top_close
	category_by_other
	category_by_female
	category_by_male
	aged_ticket
	more_than_one_week
	list_tickets_by_month

	erb :information
end

post '/information' do
	require_relative 'models/information.rb'
	@information_selected_in_nav = true
	persistence_manager = PersistenceManager.new()
	@tickets = persistence_manager.get_tickets_from_disk
	ticket_by_commune
	top_open_date
	month_top_close
	category_by_other
	category_by_female
	category_by_male
	aged_ticket
	more_than_one_week
	list_tickets_by_month(params[:inputMonth])

	erb :information
end

get '/statistics' do
	@statistics_selected_in_nav = true
	require_relative 'models/statistics.rb'
	persistence_manager = PersistenceManager.new()
	@tickets = persistence_manager.get_tickets_from_disk
	@commune = commune
	tickets_by_commune_chart
	top5_commune
	long5_tickets
	top5_category_used
	tickets_by_day_chart
	category_percentage
	channel_percentage
	top5_worst_resolution

	erb :statistics
end

get '/about' do
	@about_selected_in_nav = true
  erb :about
end

get '/about_me' do
	@about_me_selected_in_nav = true
  erb :about_me
end
