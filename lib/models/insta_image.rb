# ActiveRecord classes to keep hold of working data
require 'socket'
class InstaImage < ActiveRecord::Base

  after_create :drop_message
  def drop_message
    # Current computers IP
    ip = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
    bus = MessageBus.find_by_label 'Instagram'
    bus.messages.create!(
      :ip_address => ip,
      :text => "Image downloaded: #{self.label}"
    )
  end
 
  def InstaImage.create_from_array(array)
    if array.any?
      array.each do |hash|
        i = InstaImage.new

        name = hash[:user][:full_name]
        caption = hash[:caption][:text] if hash[:caption]
        caption ||= ''
        i.label = "[#{name}] #{caption}"

        loc = hash[:location]
        i.lat = loc[:latitude]
        i.long = loc[:longitude]
      
        i.url = hash[:images][:thumbnail][:url]

        i.save unless InstaImage.find_by_url(i.url)
      end
    end
  end

  def InstaImage.downloaded?(filename)
    InstaImage.find_by_filename(filename) ? true : false
  end

end
