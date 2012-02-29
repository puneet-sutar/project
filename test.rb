require "rubygems"
require "dbi"
require "xmlsimple"
require "test1.rb"
require "mysql"
require "./atomic/atoms.rb"
require "mod1.rb"
require "./rules/rules.rb"
include Atoms
include Validations
include Rules

#config = XmlSimple.xml_in("./atomic/update.xml")
#id=config['id'].first
#id=config['param'][0]['name'][0]['content']

@operators=["|",">","<",">>","<<","&&"]
def read_atom_name
  $atoms={}
  fin=File.open("atom.info","r")
  fin.each{|line| temp=line.split(" ") ;$atoms[temp[0]]=temp[1];}
end
def create_op
  puts "Enter op name"
  name=gets.chomp
  fout=File.open("./operations/#{name}.xml","w")
  fout.puts"<#{name}>"
  fout.puts"<id>c1</id>"
  fout.puts"<name>#{name}</name>"
  fout.puts"<type>operation</type>"
  fout.puts"<process>"
  puts "Enter configuration"
  config=gets.chomp.split(" ")
  read_atom_name 
=begin  config.each do |val|
  if $atoms.has_key? val
    puts "true"
  end
=end
  input=""  
  @update=XmlSimple.xml_in("./atomic/update.xml")
  n=@update['param'][0]['num']
  i=0
  puts "enter parameters required for update"
  while i< n.to_i
    temp=@update['param'][0]['name'][i]
    puts "ENTER #{temp} : "
    input=input+"#{gets.chomp()}:"
    i=i+1
  end 
  input=input.chop
  fout.puts "<name input='#{input}'>update</name>"
  fout.puts "</process>"
  fout.puts "<rules>"
  
  fout.puts "</rules>"
  fout.puts "</#{name}>"
  ####===========================creating ruby code 
end

def prepare_input (input)
str=input.split(":")
object={}
table=str[0]
lhs=str[1]
rhs=str[2]
cond=str[3]
 #puts "rhs = #{rhs}"
puts $object
$object['object'].each do |obj|
if(obj['name'][0]['value']==table)
object=obj
 end
  end
  if object=={}
    puts "error: Table Does Not Exist"
  end
  #puts object['attr']
  index=1
  while index<str.length
  rhs_split=str[index].split(" ")
    i=0
  while i<rhs_split.length
    if rhs_split[i][0]==35  ##ascii value of #=35
      temp=rhs_split[i].split("#")[1]
      rhs_split[i]=$input[temp]
    elsif is_i?(rhs_split[i])
         puts ""       
    else
      flag=false
      object["attr"].each do |attr|
        if(attr["content"]==rhs_split[i])
          flag=true
        end
      end
      if flag==false
        puts "invalid while creating operation"
      end  
    end
    i=i+1
   end
   str[index]=rhs_split.join(" ");
  index=index+1;
 end
 return str
end

def prepare_input_rules(input)
  str=input.split(" ")
  i=0
  while i<str.length 
    if str[i][0]==35  ##ascii value of #=35
     temp=str[i].split("#")[1]
     str[i]=$input[temp]
    end
    i=i+1
  end
  str1=str.join(" ")
  str=str1.split(":")
  return str
end

def execute
  puts "ENTER REQUEST FILE NAME : "
  fname="request.xml"   #gets.chomp!
  $input={}
  $request=XmlSimple.xml_in(fname)
  $opname=$request['op_name'].first
  $request['input'][0].each do |i,j|
    $input[i]=j.first
  end
  $object=XmlSimple.xml_in("./objects/obj.xml")
  $operation=XmlSimple.xml_in("./operations/#{$opname}.xml")
  fresponse=File.open("response.xml","w")
  process=$operation['process'][0]['name']
  fresponse.puts"<response>"
  fresponse.puts"<opname>#{$operation['name'].first}<opname>"
  rules=$operation['rules']
  return1=$operation['return']
  begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:project:localhost","root", "123")
     dbh['AutoCommit'] = false # Set auto commit to false.
     process.each do |i|
        input=prepare_input(i['input']);
      if(i==process.first)  
        rules.each do |j|
        if(j['input']!="false")
          input_r=prepare_input_rules(j['input'])
        else
          input_r=[]
        end
        input_r.push(input[0])
        input_r.push(input.last)
        $condtion=input.last
        call_rule=j['name']
        puts call_rule
        puts "rule input = #{input_r}  "
        if send(call_rule,input_r,dbh)==false
          dbh.rollback
          fresponse.puts "<startus error='#{j['error']}'/>"
          puts "rule broken"
          return 
        end
     end
     end
        str=input.join(",")
        function=i['content'][0]
        send(function,input,dbh)
     end
     if return1[0]['value']!="false"
        value=return1[0]['value'].split(" ")
        value.each do |i|
          table=i.split(":")[0]
          field=i.split(":")[1]
          sth = dbh.prepare("select #{field} from #{table} where #{$condtion}")
           sth.execute()
           sth.fetch do |row|
              fresponse.puts "<output name='#{field}' value='#{row[0]}'/>"
           end
        end
        fresponse.puts "<status error='false'/>"        
     end
     
  rescue DBI::DatabaseError => e
     puts "Transaction failed"
     dbh.rollback
     fresponse.puts "<startus error='#{e.err}'/>"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
  ensure
     # disconnect from server
     fresponse.puts "<response/>"
     fresponse.close
     dbh.commit
     dbh['AutoCommit'] = true # Set auto commit to false.
     dbh.disconnect if dbh
  end
  
  #puts process
  
end 

puts "Select task"
puts "1.Create Operations"
puts "2.Execute"
op=gets.chomp
case op
  when "1"
    create_op
  when "2"
    execute 
end