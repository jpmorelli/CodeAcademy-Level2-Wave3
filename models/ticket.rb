class Ticket
  attr_accessor :id, :status, :open_date, :close_date, :commune, :category, :type_of_ticket, :street, :number, :neighbordhood, :gender, :source_channel, :status

  def initialize(id,category,type_of_ticket,open_date,commune,neighbordhood,street,number,source_channel,gender,status='Abierto',close_date)
    @id = id
    @category = category.upcase
    @type_of_ticket = type_of_ticket
    @open_date = open_date
    @commune = commune
    @neighbordhood = neighbordhood.upcase
    @street = street.upcase
    @number = number
    @source_channel = source_channel
    @gender = gender
    @status = status
    @close_date = close_date
    end

end
