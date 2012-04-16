# encoding: utf-8
#!/usr/bin/env ruby

require 'rubygems'
require 'sqlite3'
require 'active_record'

current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/../../models/project"
require "#{current_dir}/../../models/section"
require "#{current_dir}/../../models/entity"
require "#{current_dir}/../../models/entity_type"
require "#{current_dir}/../../models/entity_type_field"
require "#{current_dir}/../../models/entity_field"

# Establish ActiveRecord Connection
begin
  ENV['RAILS_ENV'].nil? ? RAILS_ENV = 'development' : RAILS_ENV = ENV['RAILS_ENV']
  config = YAML::load(IO.read("#{current_dir}/../../../config/database.yml"))
  ActiveRecord::Base.establish_connection(config[RAILS_ENV])
  Dir["#{current_dir}/../../models/*.rb"].each {|file|
	eval(IO.read(file), binding)
  }
rescue Exception => e
    puts "Exception establishing activerecord connection"
    puts self.inspect
    puts e.message
end

##########################
# Test Project Insertion #
##########################
project_title = "Test Project"
project_id = -1
already_retried = false
begin
    # Try to find Project by title first
    project_row = Project.find(:first, :conditions => "title='#{project_title}'")
    unless (project_row.nil?)
      if (project_row.id > -1)
        project_id = project_row.id
        puts "[DEBUG] SELECTED project with title #{project_title}, Id = #{project_id}"
      end
    end
    
    # If not exists then insert
    unless (project_id > -1)
      project = Project.new("title" => project_title, "description" => "This is a test project")
      project.save()
      project_id = project.id
      puts "[DEBUG] INSERTED project with title #{project_title}, Id = #{project_id}"
    end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying Project entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving Project"
    puts self.inspect
    puts e.message
  end
end

#################
#################

##########################
# Test Section Insertion #
##########################
section_title = "Test Section"
section_id = -1
already_retried = false
begin
    # Try to find Section by title first
    section_row = Section.find(:first, :conditions => "title='#{section_title}' AND project_id=#{project_id}")
    unless (section_row.nil?)
      if (section_row.id > -1)
        section_id = section_row.id
        puts "[DEBUG] SELECTED section with title #{section_title}, Id = #{section_id}"
      end
    end
    
    # If not exists then insert
    unless (section_id > -1)
      section = Section.new("title" => section_title, "description" => "This is a test section", "project_id" => project_id)
      section.save()
      section_id = section.id
      puts "[DEBUG] INSERTED section with title #{section_title}, Id = #{section_id}"
    end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying Section entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving Section"
    puts self.inspect
    puts e.message
  end
end

#################
#################

##############################
# Test Entity Type Insertion #
##############################
entity_type_title = "Person"
entity_type_id = -1
already_retried = false
begin
    # Try to find EntityType by title first
    entity_type_row = EntityType.find(:first, :conditions => "title='#{entity_type_title}'")
    unless (entity_type_row.nil?)
      if (entity_type_row.id > -1)
        entity_type_id = entity_type_row.id
        puts "[DEBUG] SELECTED entity_type with title #{entity_type_title}, Id = #{entity_type_id}"
      end
    end
    
    # If not exists then insert
    unless (entity_type_id > -1)
      entity_type = EntityType.new("title" => entity_type_title, "description" => "Person entity type")
      entity_type.save()
      entity_type_id = entity_type.id
      puts "[DEBUG] INSERTED entity_type with title #{entity_type_title}, Id = #{entity_type_id}"
    end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying EntityTypeField type field entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving EntityTypeField"
    puts self.inspect
    puts e.message
  end
end

#################
#################

#########################################################
# Test Entity Type Field Insertion                      #
#  -- EntityTypeField: field_name:string entity_type:id #
#########################################################
entity_type_field_name = "Hair Color"
entity_type_field_id = -1
already_retried = false
begin
    # Try to find EntityTypeField by field name first
    entity_type_field_row = EntityTypeField.find(:first, :conditions => "field_name='#{entity_type_field_name}' AND entity_type_id=#{entity_type_id}")
    unless (entity_type_field_row.nil?)
      if (entity_type_field_row.id > -1)
        entity_type_field_id = entity_type_field_row.id
        puts "[DEBUG] SELECTED entity_type_field with field_name #{entity_type_field_name}, Id = #{entity_type_field_id}"
      end
    end
    
    # If not exists then insert
    unless (entity_type_field_id > -1)
      entity_type_field = EntityTypeField.new("field_name" => "Hair Color", "entity_type_id" => entity_type_id)
      entity_type_field.save()
      entity_type_field_id = entity_type_field.id
      puts "[DEBUG] INSERTED entity_type_field with field_name #{entity_type_field_name}, Id = #{entity_type_field_id}"
    end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying EntityTypeField type field entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving EntityTypeField"
    puts self.inspect
    puts e.message
  end
end

#################
#################

#########################
# Test Entity Insertion #
# title:text entity_type:references description:text project:references section:references #
#########################
entity_title = "Mike"
entity_id = -1
already_retried = false
begin
    # Try to find Entity by title first
    entity_row = Entity.find(:first, :conditions => "title='#{entity_title}' AND entity_type_id=#{entity_type_id} AND project_id=#{project_id} AND section_id=#{section_id}")
    unless (entity_row.nil?)
      if (entity_row.id > -1)
        entity_id = entity_row.id
        puts "[DEBUG] SELECTED entity with title #{entity_title}, Id = #{entity_id}"
      end
    end
    
    # If not exists then insert
    unless (entity_id > -1)
      entity = Entity.new("title" => entity_title, "description" => "test entity", "entity_type_id" => entity_type_id, "project_id" => project_id, "section_id" => section_id)
      entity.save()
      entity_id = entity.id
      puts "[DEBUG] INSERTED entity with title #{entity_title}, Id = #{entity_id}"
    end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying Entity entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving Entity"
    puts self.inspect
    puts e.message
  end
end

#################
#################

############################################
# Pre-Definted EntityField Insertion       #
# name:string value:text entity:references #
###########################################
begin
  entity_type_field_rows = EntityTypeField.find(:all, :conditions => "entity_type_id=#{entity_type_id}")
  entity_type_field_rows.each do |row|
     puts "Enter #{row.field_name}: "
     value = 'unknown'
     field = EntityField.new("name" => row.field_name, "value" => value, "entity_id" => entity_id)
     field.save()
     puts "[DEBUG] INSERTED entity_field with field_name #{row.field_name}, Id = #{entity_id}"
  end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying EntityField entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving EntityField"
    puts self.inspect
    puts e.message
  end
end

#################
#################

#########################
# Test Entity Insertion #
# title:text entity_type:references description:text project:references section:references #
#########################
entityB_title = "Matt"
entityB_id = -1
already_retried = false
begin
    # Try to find Entity by title first
    entityB_row = Entity.find(:first, :conditions => "title='#{entityB_title}' AND entity_type_id=#{entity_type_id} AND project_id=#{project_id} AND section_id=#{section_id}")
    unless (entityB_row.nil?)
      if (entityB_row.id > -1)
        entityB_id = entityB_row.id
        puts "[DEBUG] SELECTED entity with title #{entityB_title}, Id = #{entityB_id}"
      end
    end
    
    # If not exists then insert
    unless (entityB_id > -1)
      entityB = Entity.new("title" => entityB_title, "description" => "test entity", "entity_type_id" => entity_type_id, "project_id" => project_id, "section_id" => section_id)
      entityB.save()
      entityB_id = entityB.id
      puts "[DEBUG] INSERTED entity with title #{entityB_title}, Id = #{entityB_id}"
    end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying Entity entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving Entity"
    puts self.inspect
    puts e.message
  end
end

#################
#################

############################################
# Pre-Definted EntityField Insertion       #
# name:string value:text entity:references #
###########################################
begin
  entity_type_field_rows = EntityTypeField.find(:all, :conditions => "entity_type_id=#{entity_type_id}")
  entity_type_field_rows.each  do |row|
     puts "Enter #{row.field_name}: "
     value = 'unknown'
     field = EntityField.new("name" => row.field_name, "value" => value, "entity_id" => entityB_id)
     field.save()
     puts "[DEBUG] INSERTED entity_field with field_name #{row.field_name}, Id = #{entityB_id}"
  end
rescue Exception => e
  #ActiveRecord::Base.connection.reconnect!
  unless already_retried
    already_retried = true
    puts "Retrying EntityField entry"
    retry
  else
    #ActiveRecord::Base.clear_active_connections!
    puts "Exception saving EntityField"
    puts self.inspect
    puts e.message
  end
end

# TODO: setup link
# $ rails generate model LinkType title:string description:text
# $ rails generate model LinkTypeField field_name:string link_type:references
# $ rails generate model Link title:string description:text project:references section:references
# $ rails generate model LinkField name:string value:text link:references

