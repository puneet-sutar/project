#Errors returened 
# -1 opname not valid  -- from initialize
class Operation
  attr_reader :id
  attr_reader :name
  attr_reader :type
  attr_reader :process
  attr_reader :rules
  attr_reader :return
  def initialize
    
  end
  def initialize(opname)
     create(opname) 
  end
  def create(opname)
    fin=File.open("../operations/operations.info")
    operations=fin.read.split(" ")
    if operations.include?(opname)==false
      puts "invalid operation name : #{opname}"
      return -1
    end
    hash=XmlSimple.xml_in("../operations/#{opname}.xml")
    @id=operations.index(opname)
    @name=opname
    @type="operation"
    @process=hash['process'][0]['name']
    @rules=[]
    if(hash['rules']!=nil)
    hash['rules'].each do |rule|
      @rules.push(Rule.new(rule))
    end
    end
    @return=hash['return']
  end
  def execute(dbh)
    @process.each do |process|
      if (process['type']=="operation")
        Operation.new(process['content'].first).execute(dbh)
      elsif(process['type']=="atom")
        Atom.new(process['content'].first).execute(process['input'],dbh) 
      else
        puts "invalid operation type : #{process['type']}"  
      end
    end
  end
  
end
