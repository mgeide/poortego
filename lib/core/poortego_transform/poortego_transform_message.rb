
###
#
# PoortegoTransformMessage Class
#
###
class PoortegoTransformMessage
  attr_accessor :title, :type, :body
  
  #
  # Constructor
  #
  def initialize(*args)
    if (args.length == 3)
      @title = args[0]
      @type  = args[1]
      @body  = args[2]
    else
      puts "[ERROR] invalid PoortegoTransformMessage"
    end
  end
  
  #
  # TODO limit supported Message types
  # E.G., exception, error, warning, status, debug
  #
  
end
