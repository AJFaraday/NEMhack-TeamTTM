# ActiveRecord classes to keep hold of working data

class InstaImage < ActiveRecord::Base

  def InstaImage.create_from_array(array)
    image_list = `ls #{File.dirname(__FILE__)}/../images`
    array.each do |hash|
      i = InstaImage.new

      name = hash[:user][:full_name]
      caption = hash[:caption][:text]
      i.label = "[#{name}] #{caption}"

      loc = hash[:location]
      i.lat = loc[:latitude]
      i.long = loc[:longitude]
      
      i.url = hash[:images][:standard_resolution][:url]
      if image_list.include?(image_url.split('/')[-1])
        puts "#{image_url} is already downloaded."
      else
        `cd #{File.dirname(__FILE__)}/../images && wget #{image_url}`
      end
      i.save!
    end
  end


end
