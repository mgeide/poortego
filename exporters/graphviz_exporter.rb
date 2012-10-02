require 'graphviz'

class GraphvizExporter
  
  def initialize(*args)
    @working_values = args[0] # See shellinterface.rb for the keys
  end
  
  def export(*args)
    if (args.include?(0))
      export_path = args[0]
    else
      export_path = "#{ENV['POORTEGO_LOCAL_BASE']}/poortego/graphviz_export.png"
    end

    type = @working_values["Current Selection Type"]
    obj = @working_values["Current Object"]
    
    puts "[DEBUG] Export #{type} #{obj.title} to #{export_path}"
    
    #g = GraphViz.new( :G, :type => :digraph )
    g = GraphViz::new("structs", "type" => "graph")
    g[:rankdir] = "LR"
    
    # Set global node options
    g.node[:color] = "#ddaa66"
    g.node[:style] = "filled"
    g.node[:shape] = "box"
    g.node[:penwidth] = "1"
    g.node[:fontname] = "Trebuchet MS"
    g.node[:fontsize] = "8"
    g.node[:fillcolor]= "#ffeecc"
    g.node[:fontcolor]= "#775500"
    g.node[:margin] = "0.0"
    
    # set global edge options
    g.edge[:color] = "#999999"
    g.edge[:weight] = "1"
    g.edge[:fontsize] = "6"
    g.edge[:fontcolor]= "#444444"
    g.edge[:fontname] = "Verdana"
    g.edge[:dir] = "forward"
    g.edge[:arrowsize]= "0.5"
    
    case type
    when 'project'
      # Get the sections
      ## TODO
    when 'section'
      # Get the entities
      entity_lookup = Hash.new()
      entity_objs = PoortegoEntity.list(@working_values["Current Project"].id,
                                 @working_values["Current Section"].id)
      entity_objs.each do |entity_obj|
        g.add_nodes(entity_obj.title)
        entity_lookup[entity_obj.id] = entity_obj.title
      end
      
      # Get the corresponding links
      link_objs = PoortegoLink.list(@working_values["Current Project"].id,
                             @working_values["Current Section"].id)
      link_objs.each do |link_obj|
        entityA = entity_lookup[link_obj.entity_a_id]
        entityB = entity_lookup[link_obj.entity_b_id]
        link_title = ''
        if (link_obj.title !~ / --> /)
          link_title = link_obj.title
        end
        g.add_edges( entityA, entityB).label = link_title
      end
      
      #g.output( :png => "graphviz_export.png" )
      g.output( :png => "#{export_path}" )

    when 'entity'
      # Get the links
      ## TODO
    else
      puts "ERROR: invalid current selection type (#{type})."
    end
     
  end
  
end




