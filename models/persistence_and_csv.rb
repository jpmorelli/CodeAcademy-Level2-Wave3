require 'yaml/store'
require 'csv'
require 'byebug'
require_relative 'ticket.rb'
require_relative 'category.rb'

class PersistenceManager

  def initialize
    @categories_store = YAML::Store.new 'public/data/categories.yml'
    @categories_store.transaction do
      @categories_store['categories_list'] ||= importcategories("public/data/atencion-ciudadana-2019.csv")
      end
    @tickets_store = YAML::Store.new 'public/data/tickets.yml'
    @tickets_store.transaction do
      @tickets_store['tickets_list'] ||= importtickets("public/data/atencion-ciudadana-2019.csv")
      end
  end

  def get_tickets_from_disk
    @tickets_store.transaction { @tickets_store['tickets_list'] }
  end

  def get_categories_from_disk
    @categories_store.transaction { @categories_store['categories_list'] }
  end

  def save_tickets_to_disk(tickets_list)
    @tickets_store = YAML::Store.new 'public/data/tickets.yml'
    @tickets_store.transaction do
      @tickets_store['tickets_list'] = tickets_list
    end
  end

  def get_ticket(ticket_id)
    ticket = @tickets_store.transaction do
      @tickets_store['tickets_list'].select{ |s| s.id == ticket_id.to_i }
    end
    ticket.first
  end

  def add_ticket(ticket)
      @tickets_store.transaction do
        @tickets_store['tickets_list'] << ticket
      end
  end

  def add_category(new_category)
    @categories_store.transaction do
      @categories_store['categories_list'] << new_category
    end
  end

  def edit_ticket(ticket)
    old_ticket = get_ticket(ticket.id)
    @tickets_store.transaction do
      @tickets_store['tickets_list'].delete_if {|ticket| ticket.id == old_ticket.id}
      @tickets_store['tickets_list'] << ticket
    end
  end

  def delete_ticket(ticket_id)
    ticket = get_ticket(ticket_id)
    raise TicketException.new 'Ticket not found by id' if ticket.nil?
    @tickets_store.transaction do
      @tickets_store['tickets_list'].delete_if {|ticket| ticket.id == ticket_id}
    end
  end

end

#### CSV import
def importtickets(csv_file)
  tickets_list = []
  CSV.foreach(csv_file, headers: true) do |row|
    tickets_list.push(Ticket.new(row[0].to_i,row[2]||'',row[3]||'',row[4]||'',row[6]||'',row[7]||'',row[8]||'',row[9]||'',row[10]||'',row[11]||'',row[12]||'',row[13]||''))
    end
  tickets_list
end

def importcategories(csv_file)
  @categories = []
  CSV.foreach(csv_file, headers: true) do |row|
    @categories.push(row[2]) unless @categories.include?(row[2])
    end
  @categories
end
