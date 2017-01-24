# Implement the new web-based CRM here.
# Do NOT copy the CRM class from the old crm assignment, as it won't work at all for the web-based version!
# You'll have to implement it from scratch.
require_relative 'contact'
require 'sinatra'


# Fake data
# Contact.create('Mark', 'Zuckerberg', 'mark@facebook.com', 'CEO')
# Contact.create('Sergey', 'Brin', 'sergey@google.com', 'Co-Founder')
# Contact.create('Steve', 'Jobs', 'steve@apple.com', 'Visionary')
#


get '/' do
  @crm_app_name = "Bitmaker's CRM"
  erb(:index)
end

get '/contacts' do
  erb(:contacts)
end

get '/contacts/new' do
  erb(:new_contact)
end


post '/contacts' do
  Contact.create(params[:first_name], params[:last_name], params[:email], params[:note])
  # erb(:contacts)
  redirect to('/contacts')
end
