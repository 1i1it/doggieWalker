require 'bundler'
Bundler.require
require './setup'

#functions
def view_tasks(tasks = nil)  
  #creates htlm file
  erb(:view, {locals: {tasks: $tasks.find.to_a, list_of_owners:["Sella", "Liliya", "Bubba"]}})
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
  #criterea_to_remove = {name: params[:task_name]}
  criterea_to_remove = {_id: BSON::ObjectId(params[:task_id])}

  $tasks.remove(criterea_to_remove)
  view_tasks
end

get '/delete_all' do
  $tasks.remove()
  redirect back
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

