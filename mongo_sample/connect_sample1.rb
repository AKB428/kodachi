require 'mongo'

@con = Mongo::Connection.new
@db = @con['sample']
@users = @db['users']