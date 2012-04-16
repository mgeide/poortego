############################
# Link ActiveRecord        #
#                          #
# Description:             #
# Link two entity objects  #
#                          #
# Attributes:              #
#  title:        text      #
#  description:  text      # 
#  entity_a_id:  reference #
#  entity_b_id:  reference #      
#  section_id:   reference #
#  project_id:   reference #
#                          #
############################
class Link < ActiveRecord::Base
  #validates :title, :presence => true
  validates :entity_a_id, :presence => true
  validates :entity_b_id, :presence => true
  validates :section_id, :presence => true
  validates :project_id, :presence => true

  belongs_to :project   # Reference to project
  belongs_to :section   # Reference to section
  belongs_to :entity_a, :class_name => 'Entity', :foreign_key => 'entity_a_id' # Reference to Entity
  belongs_to :entity_b, :class_name => 'Entity', :foreign_key => 'entity_b_id' # Reference to Entity
  has_many :link_fields # Link fields reference Links 
  
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    
    project_id = args[0]
    section_id = args[1]
    link_names = Array.new()
    
    begin
        # Try to find Links by title
        link_rows = self.find(:all, :conditions => "project_id=#{project_id} AND section_id=#{section_id}", :order => "title ASC")
        link_rows.each do |object_row|
          link_names.push(link_row['title'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Links"
            puts self.inspect
            puts e.message
    end
    
    return link_names
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    project_id   = args[0]
    section_id   = args[1]
    entityA_name = args[2]
    entityB_name = args[3]
    link_name = ''
    if (args.length == 5)
      link_name    = args[4]
    end
    
    link_id = -1
    begin
        entityA_id = Entity.select(project_id, section_id, entityA_name)
        entityB_id = Entity.select(project_id, section_id, entityB_name)
        
        link_row = self.find(:first, :conditions => "title='#{link_name}' AND project_id=#{project_id} AND section_id=#{section_id} AND entity_a_id=#{entityA_id} AND entity_b_id=#{entityB_id}")
        unless (link_row.nil?)
            if (link_row.id > -1)
              link_id = link_row.id
              puts "[DEBUG] SELECTED Link Id = #{link_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting Link"
            puts self.inspect
            puts e.message
    end
    
    return link_id
    
  end

  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    project_id   = args[0]
    section_id   = args[1]
    entityA_name = args[2]
    entityB_name = args[3]
    link_name = ''
    if (args.length == 5)
      link_name    = args[4]
    end
    
    link_id = -1
    begin
        entityA_id = Entity.select(project_id, section_id, entityA_name)
        entityB_id = Entity.select(project_id, section_id, entityB_name)
        
        link_obj = self.new("title" => link_name, "project_id" => project_id, "section_id" => section_id, "entity_a_id" => entityA_id, "entity_b_id" => entityB_id)
        link_obj.save()
        link_id = link_obj.id
        puts "[DEBUG] INSERTED link with Id = #{link_id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Link"
            puts self.inspect
            puts e.message
    end
    
    return link_id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    project_id   = args[0]
    section_id   = args[1]
    entityA_name = args[2]
    entityB_name = args[3]
    link_name = ''
    if (args.length == 5)
      link_name    = args[4]
    end
    
    already_retried = false
    link_id = -1
    begin
        # Try to select Section by title first
        link_id = self.select(project_id, section_id, entityA_name, entityB_name, link_name)
        
        # If not exists then insert
        unless (link_id > -1)
            link_id = self.insert(project_id, section_id, entityA_name, entityB_name, link_name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Link entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Link"
            puts self.inspect
            puts e.message
        end
    end
    
    return link_id    
  
  end

  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    project_id   = args[0]
    section_id   = args[1]
    entityA_name = args[2]
    entityB_name = args[3]
    link_name = ''
    if (args.length == 5)
      link_name    = args[4]
    end
    
    link_id = -1
    begin
        # Try to find Section by title first
        link_id = self.select(project_id, section_id, entityA_name, entityB_name, link_name)
        if (link_id > -1)
              self.delete(link_id)
              puts "[DEBUG] DELETED Link Id = #{link_id}"
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Link"
            puts self.inspect
            puts e.message
    end
    
    return link_id
  end  
  
    
end
