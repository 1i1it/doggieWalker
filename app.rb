require 'bundler'
Bundler.require
require './setup'
require './app_config'
#require './user'

#functions
def view_tasks(tasks = nil)  
  #creates htlm file
  erb(:view, {locals: {tasks: $tasks.find.to_a, list_of_owners: LIST_OF_OWNERS}})
end

get '/practice_erb' do
  erb(:practice_erb, locals: {country: "Israel"})
end

get '/' do
  view_tasks
end

post '/add' do
   # $tasks is the database
  $tasks.insert({owner: params[:owner_name], name: params[:task_name], description: params[:task_description]})  
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

get '/users/:owner_name' do
  owner = params[:owner_name]
  tasks = $tasks.find({owner: owner}).to_a
  if tasks.any?
    erb(:user, locals: {tasks: tasks})
  else
    return "Nothing found"
  end

  #erb(:view, {locals: {tasks: tasks, list_of_owners: LIST_OF_OWNERS}})
  
  
end

#7. Create a "user" page: add a "get /:user" route that will render a "user.erb" file. 
#In that file, first just show the user's name, then use "$tasks.find({name: params[:username]}).to_a" 
#to get the tasks that belong to that user, then use "erb :tasks_list" to show just HIS tasks. 


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

