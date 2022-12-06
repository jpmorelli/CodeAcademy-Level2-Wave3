
def source_channel
  @source_channel = ['App','Web','147','Comunas'] 
end

def type_of_ticket
  @type_of_ticket = ['DENUNCIA','QUEJA','REPORTE','SERVICIO','SOLICITUD']
end

def commune
  @commune = ['COMUNA 1', 'COMUNA 2', 'COMUNA 3', 'COMUNA 4', 'COMUNA 5', 'COMUNA 6', 'COMUNA 7', 'COMUNA 8', 'COMUNA 9', 'COMUNA 10', 'COMUNA 11', 'COMUNA 12', 'COMUNA 13', 'COMUNA 14', 'COMUNA 15']
end

def categories
  persistence_manager = PersistenceManager.new()
  @categories = persistence_manager.get_categories_from_disk
end

def days_of_week
  days_of_week = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
end
