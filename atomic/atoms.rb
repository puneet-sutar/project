#update 
#1.Atomic
#2.Inbuilt
#3.Used to create larger operations
#variables
#table=INPUT STREAM
#
module Atoms
  def update(input,dbh) #dbh = dbi statement variable  
  if input[3]==""
    sth = dbh.prepare("update #{input[0]}_updatable set #{input[1]} = #{input[2]}") #non conditonal update
  else
    sth = dbh.prepare("update #{input[0]}_updatable set #{input[1]} = #{input[2]} WHERE  #{input[3]}") #conditional update    
  end
    sth.execute()
    sth.finish
  end  
end
