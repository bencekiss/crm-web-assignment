# Copy your entire Contact class from the old crm assignment here.
# Then, run the following at the command line:
#
#   ruby test/contact_test.rb
#
# If your implementation of the Contact class is 'right', then you should see that all tests pass!

# require_relative './crm.rb'
require 'active_record'
require 'mini_record'


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'crm3-web.sqlite3')

class Contact < ActiveRecord::Base
  # attr_accessor :first_name, :last_name, :email, :note
  # attr_reader :id

  field :first_name, as: :string
  field :last_name,  as: :string
  field :email,      as: :string
  field :note,       as: :text
  
  def full_name
    "#{ first_name } #{ last_name }"
  end


end
Contact.auto_upgrade!
