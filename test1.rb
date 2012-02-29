require "rubygems"
require "dbi"
require "./atomic/atoms.rb"
begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:project:localhost","root", "123")
     sth = dbh.prepare("show Fields from dummy1")
     sth.execute()
     sth.fetch do |row|
        puts "#{row[0]}\t#{row[1]}\n"
     end
     sth.finish
rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
ensure
     # disconnect from server
     dbh.disconnect if dbh
end