require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'
require 'json'
require 'active_support'


require File.dirname(__FILE__) + '/lib/init_db.rb'


class DbMonitor < Sinatra::Base

  set :static, true
  set :public_dir, File.dirname(__FILE__) + '/public'

  get '/' do
    @message_busses = MessageBus.all(:order => 'label asc')
    display(:index)
  end 

  get '/score' do
    @message = TTMMessage.oldest_not_shown
    display(:score)
  end

  get '/refresh_score' do
    @message = TTMMessage.oldest_not_shown
    if @message 
      {:new => true, :image_path => @message.image_path}.to_json
    else 
      {:new => false}.to_json
    end
  end

  get '/get_messages' do
    @message_busses = MessageBus.all(:order => 'label asc') 
    @data = {}
    @message_busses.each do |message_bus|
      @data.merge!({"message_bus_#{message_bus.id}_content" => erb(:"message.html", :locals => {:message_bus => message_bus})})
    end 
    @data.to_json
  end


  def display(view)
    result = ''
    result << erb(:"header.html")
    result << erb(:"#{view}.html")
    result << erb(:"footer.html")
    result
  end

end


