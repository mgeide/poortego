##################################
# SectionDescriptor ActiveRecord #
#                                #
# Description:                   #
# Store Descriptor About Section #
#                                #
# Attributes:                    #
#  field:   string               #
#  value:   text                 #
#  section_id: reference         #
#                                #
##################################
class SectionDescriptor < ActiveRecord::Base
  validates :field_name, :presence => true
  validates :section_id, :presence => true

  belongs_to :section
  
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    
    section_id = args[0]
    descriptor_names = Array.new()
    
    begin
        # Try to find Objects by title
        descriptor_rows = self.find(:all, :conditions => "section_id=#{section_id}", :order => "field_name ASC")
        descriptor_rows.each do |descriptor_row|
          descriptor_names.push(descriptor_row['field_name'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Descriptors"
            puts self.inspect
            puts e.message
    end
    
    return descriptor_names
    
  end                       

  ################################
  # Method: list_with_values()
  ################################
  def self.list_with_values(*args)
    section_id = args[0]
    
    fields = Hash.new()
    begin
        # Try to find Types by title
        field_rows = self.find(:all, :conditions => "section_id=#{section_id}", :order => "field_name ASC")
        field_rows.each do |field_row|
          fields[field_row['field_name']] = field_row['value']
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing fields"
            puts self.inspect
            puts e.message
    end
    
    return fields
    
  end

  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    section_id = args[0]
    descriptor_name = args[1]
    
    descriptor_id = -1
    begin
        # Try to find Descriptor first
        descriptor_row = self.find(:first, :conditions => "field_name='#{descriptor_name}' AND section_id=#{section_id}")
        unless (descriptor_row.nil?)
            if (descriptor_row.id > -1)
              descriptor_id = descriptor_row.id
              puts "[DEBUG] SELECTED Descriptor #{descriptor_name}, Id = #{descriptor_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting descriptor"
            puts self.inspect
            puts e.message
    end
    
    return descriptor_id
    
  end

  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    section_id = args[0]
    descriptor_name = args[1]
    
    descriptor_id = -1
    begin
        # Try to create Object with title
        descriptor_obj = self.new("field_name" => descriptor_name, "section_id" => section_id)
        descriptor_obj.save()
        descriptor_id = descriptor_obj.id
        puts "[DEBUG] INSERTED descriptor #{descriptor_name}, Id = #{descriptor_id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Descriptor"
            puts self.inspect
            puts e.message
    end
    
    return descriptor_id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    section_id = args[0]
    descriptor_name = args[1]
    
    already_retried = false
    descriptor_id = -1
    begin
        # Try to select Section by title first
        descriptor_id = self.select(section_id, descriptor_name)
        
        # If not exists then insert
        unless (descriptor_id > -1)
            descriptor_id = self.insert(section_id, descriptor_name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Descriptor entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Descriptor"
            puts self.inspect
            puts e.message
        end
    end
    
    return descriptor_id     
  
  end

  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    section_id = args[0]
    descriptor_name = args[1]
    
    descriptor_id = -1
    begin
        # Try to find Section by title first
        descriptor_id = self.select(section_id, descriptor_name)
        if (descriptor_id > -1)
              self.delete(descriptor_id)
              puts "[DEBUG] DELETED descriptor #{descriptor_name}, Id = #{descriptor_id}"
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Descriptor"
            puts self.inspect
            puts e.message
    end
    
    return object_id
  end  
  
  
end
