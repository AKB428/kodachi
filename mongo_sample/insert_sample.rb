require 'mongo'

@con = Mongo::Connection.new
@db = @con['sample']
@users = @db['XVVV']
  
abe = {"name" => "abe" , "last_name" => "sinzo"}
  
@users.insert(abe)