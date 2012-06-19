
  #
  # Set prompt
  #
  def set_prompt(driver)
     type = driver.interface.working_values["Current Selection Type"]
     if (type == 'none')
       driver.update_prompt("")
     else
       name = driver.interface.working_values["Current Object"].title
       driver.update_prompt("(%bld%red"+type+":"+name+"%clr)")
     end
  end