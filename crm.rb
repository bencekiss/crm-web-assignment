# Implement the new web-based CRM here.
# Do NOT copy the CRM class from the old crm assignment, as it won't work at all for the web-based version!
# You'll have to implement it from scratch.
require_relative 'contact'
require 'sinatra'


# Fake data
# Contact.create('Mark', 'Zuckerberg', 'mark@facebook.com', 'CEO')
# Contact.create('Sergey', 'Brin', 'sergey@google.com', 'Co-Founder')
# Contact.create('Steve', 'Jobs', 'steve@apple.com', 'Visionary')
# Contact.create('Bence', 'Kiss', 'bence@kiss.hu', 'Regular person')


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
  Contact.create(
  first_name: params[:first_name],
  last_name: params[:last_name],
  email: params[:email],
  note: params[:note]
  )
  # erb(:contacts)
  redirect to('/contacts')
end

get '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end

end

get '/contacts/:id/edit' do
  @contact = Contact.find(params[:id])
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end

end

put '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    @contact.update(first_name: params[:first_name])
    @contact.update(last_name: params[:last_name])
    @contact.update(email: params[:email])
    @contact.update(note: params[:note])

    redirect to('/contacts')
  else
    raise Sinatra::NotFound
  end
end

delete '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    @contact.delete
    redirect to('/contacts')
  else
    raise Sinatra::NotFound
  end
end

post '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    erb :edit_contact
    # redirect to('/contacts/:id/edit')
  else
    raise Sinatra::NotFound
  end
end

get '/contacts/:id/delete' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    @contact.delete
    # flash[:success] = "#{ @contact.first_name } #{ @contact.last_name } at ID# #{ @contact.id } deleted!"
    erb :delete
  else
    raise Sinatra::NotFound
  end
end

get '/about' do
  erb :about
end


after do
  ActiveRecord::Base.connection.close
end
