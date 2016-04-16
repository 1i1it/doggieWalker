set :views, Proc.new { File.join(root, "/") }
set :public_folder, Proc.new { File.join(root, "/") }

#db
DB_NAME= ENV["MONGOLAB_DBNAME"] || ('doggie-walker')
DB_URI = ENV["MONGOLAB_URI"] || 'mongodb://localhost:27017'

begin #mongo mock
  $tasks = Mongo::MongoClient.from_uri(DB_URI).db(DB_NAME).collection('tasks')
  $users = Mongo::MongoClient.from_uri(DB_URI).db(DB_NAME).collection('users')
rescue => e

  # below is a mock for mongo, we are not actually using it. it's for
  #ppl who dont have mongo
  puts "Using a mock for Mongo."  
  $docs = {}; $tasks = Object.new

  def $tasks.find
    $docs.values.compact
  end

  def $tasks.insert(doc) 
    $docs[doc[:name]] = doc; 
  end

  def $tasks.remove(doc)
    doc ? $docs[doc[:name]] = nil : $docs = {} #remove all       
  end
end 



