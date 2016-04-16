require 'bundler'
Bundler.require
require './setup'
require './app_config'
enable :sessions

def list_of_users_orig()
  users_array = []  
  #find all usernames in users and append them to users_array
  $users.find.to_a.each { |user_hash| users_array << (user_hash["username"]) }
  return users_array.compact.uniq
end

def list_of_users
  $users.find.to_a.map { |user| user["username"] }.compact.uniq
end


get '/sign_up' do
  erb (:sign_up)
end

post '/create_user' do
  username = params[:username]
  $users.insert({username: username,  password: params[:password]})
  session[:username] = username
  redirect to ('/')
end

get '/set_cookie' do
  cookies[:something] = 'foobar'
  redirect to('/view_cookies')
end

get '/view_cookies' do
  "value: #{cookies[:something]}"
end

get '/foo' do
  session[:message] = 'Hello World!'
  redirect to('/bar')
end

get '/who_am_i' do
  session[:username] || "nobody"
end

def get_user_by_username(username)
  $users.find_one(username: username)
end

get '/login' do
  username = params[:username].to_sym
  password = params[:password]
  user = get_user_by_username(username)

  return "no such user" if !user
  return "wrong password" if user['password']!= password

  session[:username] = username
  redirect to('/')
end

get '/log_out' do
  session.clear
  redirect to('/')
end

get '/bar' do
  session[:message]   # => 'Hello World!'
end

#functions
def current_user
  session[:username]
end

def view_tasks(tasks = nil)  
  #creates htlm file
  erb(:view, {locals: {tasks: $tasks.find.to_a, list_of_owners: list_of_users()}})
end

get '/practice_erb' do
  erb(:practice_erb, locals: {country: "Israel"})
end

get '/' do
  view_tasks
end

post '/add' do
   # $tasks is the database
  $tasks.insert({owner: params[:owner_name], name: params[:task_name], 
    description: params[:task_description], image: params[:task_image]})  
  view_tasks
  redirect back
end

get '/delete' do
  criterea_to_remove = {_id: BSON::ObjectId(params[:task_id])}

  $tasks.remove(criterea_to_remove)
  view_tasks
end

get '/delete_all' do
  $tasks.remove()
  redirect back
end

get '/my_tasks' do
  me = session[:username]
  redirect to ('/users/'+me)
end

#http://localhost:9494/users/Liliya 
get '/users/:owner_name' do
  owner = params[:owner_name]
  tasks = $tasks.find({owner: owner}).to_a
  if tasks.any?
    erb(:user, locals: {tasks: tasks})
  else
    redirect to('/')
  end
end

 get '/mark_completed' do
  $tasks.update({_id: BSON::ObjectId(params[:task_id])}, {"$set" => {completed: true}})
  redirect back
end

get '/mark_incomplete' do
    $tasks.update({_id: BSON::ObjectId(params[:task_id])}, {"$set" => {completed: false}})
    redirect back
end



# print to console
puts "Server is now running."

