# Copy your entire Contact class from the old crm assignment here.
# Then, run the following at the command line:
#
#   ruby test/contact_test.rb
#
# If your implementation of the Contact class is 'right', then you should see that all tests pass!

# require_relative './crm.rb'
require 'pry'

class Contact
  attr_accessor :first_name, :last_name, :email, :note
  attr_reader :id
  @@all_contacts = []
  @@next_id = 0


  def self.all
    @@all_contacts
  end

  def self.create(first_name, last_name, email, note)
    # 1. initialize a new contact w a unique id
    new_contact = new(first_name, last_name, email, note)
    # 2. add the new contact to the list of all contact
    @@all_contacts << new_contact
    # 3. Increment the next unique id
    @@next_id += 1
    new_contact
  end

  # adds a contact by getting its name from the user
  def self.add_contact
    puts "First name: "
    f = gets.chomp
    puts "Last name: "
    l = gets.chomp
    puts "Email: "
    e = gets.chomp
    puts "Note: "
    n = gets.chomp
  # using create instead of initialize helps
    c = self.create(f, l, e, n)

  end

# Display every contact in the respective CRM (Because there is only one).
# If there were multiple CRMs in the same time, it could display every contact that has ever been created.
  def self.display_contacts
    if @@all_contacts == []
      puts "Sorry, there is no contact in the system."
    else
      @@all_contacts.each do |cc|
        puts "ID: #{ cc.id }, First Name: #{ cc.first_name }, Last Name: #{ cc.last_name }, Email: #{ cc.email }, Note: #{ cc.note }."
      end
    end
    puts "[ Enter ] Get to the main menu"
    gets
    return @@all_contacts
  end

# initialize method, but create is a lot more effective
  def initialize(first_name, last_name, email, note)
    @id = @@next_id
    @first_name = first_name.capitalize
    @last_name = last_name.capitalize
    @email = email
    @note = note


  end

  def full_name
    "#{ first_name } #{ last_name }"
  end

# Since I always work with the @@all_contacts class variable,
# it made sense to make every method to be a class method.
#
# Modify method: finds a contact in the @@all_contacts and modifies it.

  def update(attribute, value)
    attribute = attribute + "="
    @@all_contacts.each do |contact|
      if contact.id == self.id
        contact.send(attribute, value)
        return value
      end
    end
  end

  def self.modify
    puts "Please enter the ID of the contact you want to modify"
    puts "If you want to go back to the main menu, hit #."
    input = gets.chomp
    if input == "#"
      return 0
    else
      input = input.to_i
    end

    @@all_contacts.each do |c|
      if c.id == input
        # Modifies its attribute to be precise.
        self.modify_attribute(c)
        return c
      end
    end

  end

  # Attribute modifier method, who takes a Contact as an argument and modifies one of its state.

  def self.modify_attribute(c)
    puts "Please give me the number of the attribute you'd like to modify"
    puts "[ 1 ] First Name"
    puts "[ 2 ] Last Name"
    puts "[ 3 ] Email"
    puts "[ 4 ] Note"
    puts "[ # ] Previous screen"
    mod = gets.chomp
    if mod == "#"
      self.modify
    end
    mod = mod.to_i

    # There is a way to make this work with the send command
    # though since there is an escape route if user misclicks
    # case is the choice. More coding...

    case mod
    when 1
      to_send = "first_name"
    when 2
      to_send = "last_name"
    when 3
      to_send = "email"
    when 4
      to_send = "note"
    else
      puts "Please give me one of the numbers in the 1..4 range."
      self.modify_attribute(c)
    end
    puts "Please give me the new value of #{ to_send }."
    value = gets.chomp
    c.update(to_send, value)
    return c
  end

# delete method, where the user can decide if the whole system has to be erased, or just one contact


  def self.delete_versions
    puts "[ 1 ] Delete every contact that ever existed."
    puts "[ 2 ] Delete one contact"
    puts "[ # ] Go back"
    input = gets.chomp
    if input == "#"
      return 0
    end
    input = input.to_i
    case input
    when 1
      self.delete_all
    when 2
      c = self.search_by_attribute
      if c
        c.delete
      else
        c
      end
    end

    return @@all_contacts
  end

  def self.delete_all
    @@all_contacts.each do |contact|
      contact = nil
    end
    @@all_contacts = []

  end
  def delete
    @@all_contacts.delete(self)
  end


# Search by attribute method, in which the user can choose which attribute they want to search for

  def self.search_by_attribute

    puts "Give me an attribute you want to search for"
    puts "[ 1 ] First Name"
    puts "[ 2 ] Last Name"
    puts "[ 3 ] Email"
    puts "[ 4 ] Note"
    puts "[ # ] Back to Main Menu"
    search = gets.chomp
    if search == "#"
      return false
    end
    search = search.to_i
    case search
      when 1
        to_send = "first_name"
      when 2
        to_send = "last_name"
      when 3
        to_send = "email"
      when 4
        to_send = "note"
    end
    puts "Please give me the exact expression you want me to search in #{ to_send }s!"
    search_for = gets.chomp
    result = self.find_by(to_send, search_for)
    if result == false
      puts "Couldn't find it, try another search!"
      gets
      self.search_by_attribute
    else
      puts "Is this what you were searching for?"
      puts "[ yes ]"
      puts "[ no ]"
      among = gets.chomp.downcase
      if among == "yes"
        return result
        # puts "Then give me the id of the contact you were looking for"
        # id = gets.chomp.to_i
        #
        # result.each do |contact|
        #   if contact.id == id
        #     contact.display
        #     puts "[ Enter ] Get to the main screen"
        #     gets
        #     return contact
        #   end
        # end
      else
        puts "[ Enter ] Then try another search!"
        gets
        self.search_by_attribute
      end
    end
  end

# find (attribute im searching in, phrase im looking for)
  def self.find(id)
    @@all_contacts.each do |contact|
      if contact.id == id
        return contact
      end
    end

    return
  end

  def self.find_by(att, sf)
    @@all_contacts.each do |contact|
      if contact.send(att) == sf
        contact.display
        return contact
      end
    end

    return
  end

  def display
    puts "ID: #{ id }, First Name: #{ first_name }, Last Name: #{ last_name }, Email: #{ email }, Note: #{ note }"
  end


end
