###
#
# Transform Active Record
#
# Attributes:    
#  title:          string
#  description:    text
#  source_file:    string
#  entity_type_id: reference
#
###
class Transform < ActiveRecord::Base
  belongs_to :entity_type
  
  #
  # List
  #
  def self.list(*args)
    transform_rows = Array.new()
    begin
      transform_rows = self.find(:all, :order => "title ASC")
    rescue Exception => e
      puts "Exception listing Transform"
      puts self.inspect
      puts e.message
    end
    return transform_rows
  end
  
  #
  # Select
  #
  def self.select(*args)
    transform_row = nil
    begin
      name = args[0]
      transform_row = self.find(:first, :conditions => "title='#{name}'")
    rescue Exception => e
      puts "Exception selecting Transform"
      puts self.inspect
      puts e.message
    end
    return transform_row
  end
  
  #
  # Insert
  #
  def self.insert(*args)
    transform_row = nil
    begin
      name = args[0]
      transform_row = self.new("title" => name)
      transform_row.save()
      puts "[DEBUG] INSERTED transform with title #{name}, Id = #{transform_row.id}"
    rescue Exception => e
      puts "Exception inserting Transform"
      puts self.inspect
      puts e.message
    end
    return transform_row
  end
  
  #
  # Select if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    transform_row = nil
    begin
      name = args[0]
      transform_row = self.select(name)
      if (transform_row.nil?)
        transform_row = self.insert(name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Transform"
      puts self.inspect
      puts e.message
    end
    return transform_row
  end
  
  #
  # Delete from name
  #
  def self.delete_from_name(*args)
    transform_row = nil
    begin
      name = args[0]
      transform_row = self.find(:first, :conditions => "title='#{name}'")
      unless (transform_row.nil?)
        self.delete(transform_row.id)
        puts "[DEBUG] DELETED transform with title #{name}, Id = #{transform_id}"
      end
    rescue Exception => e
      puts "Exception deleting Transform"
      puts self.inspect
      puts e.message
    end
    return transform_row
  end
  
  
end
