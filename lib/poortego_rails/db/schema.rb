# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120406193844) do

  create_table "entities", :force => true do |t|
    t.text     "title"
    t.integer  "entity_type_id"
    t.text     "description"
    t.integer  "project_id"
    t.integer  "section_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "entities", ["entity_type_id"], :name => "index_entities_on_entity_type_id"
  add_index "entities", ["project_id"], :name => "index_entities_on_project_id"
  add_index "entities", ["section_id"], :name => "index_entities_on_section_id"

  create_table "entity_fields", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.integer  "entity_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "entity_fields", ["entity_id"], :name => "index_entity_fields_on_entity_id"

  create_table "entity_type_fields", :force => true do |t|
    t.string   "field_name"
    t.integer  "entity_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "entity_type_fields", ["entity_type_id"], :name => "index_entity_type_fields_on_entity_type_id"

  create_table "entity_types", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "link_fields", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.integer  "link_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "link_fields", ["link_id"], :name => "index_link_fields_on_link_id"

  create_table "link_type_fields", :force => true do |t|
    t.string   "field_name"
    t.integer  "link_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "link_type_fields", ["link_type_id"], :name => "index_link_type_fields_on_link_type_id"

  create_table "link_types", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "project_id"
    t.integer  "section_id"
    t.integer  "entity_a_id"
    t.integer  "entity_b_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "links", ["project_id"], :name => "index_links_on_project_id"
  add_index "links", ["section_id"], :name => "index_links_on_section_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "section_descriptors", :force => true do |t|
    t.string   "field_name"
    t.text     "value"
    t.integer  "section_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "section_descriptors", ["section_id"], :name => "index_section_descriptors_on_section_id"

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sections", ["project_id"], :name => "index_sections_on_project_id"

  create_table "transforms", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "source_file"
    t.integer  "entity_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "transforms", ["entity_type_id"], :name => "index_transforms_on_entity_type_id"

end
