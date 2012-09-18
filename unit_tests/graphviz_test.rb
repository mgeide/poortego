require 'graphviz'

# Create a new graph
g = GraphViz.new( :G, :type => :digraph )

# Create two nodes
hello = g.add_nodes( "Hello" )
world = g.add_nodes( "World" )

# Create an edge between the two nodes
g.add_edges( hello, world )

# Generate output image
g.output( :png => "hello_world.png" )
