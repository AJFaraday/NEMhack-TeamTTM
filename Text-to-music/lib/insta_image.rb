# ActiveRecord classes to keep hold of working data

class InstaImage < ActiveRecord::Base

  def InstaImage.create_from_array(array)
    if array.any?
      image_list = `ls #{File.dirname(__FILE__)}/../images`
      array.each do |hash|
        i = InstaImage.new

        name = hash[:user][:full_name]
        caption = hash[:caption][:text] if hash[:caption]
        caption ||= ''
        i.label = "[#{name}] #{caption}"

        loc = hash[:location]
        i.lat = loc[:latitude]
        i.long = loc[:longitude]
      
        i.url = hash[:images][:standard_resolution][:url]
        i.filename = i.url.split('/')[-1]
        if InstaImage.downloaded?(i.filename)
          puts "#{i.url} is already downloaded."
        else
          `cd #{File.dirname(__FILE__)}/../images && wget #{i.url}`
          i.save!
        end
      end
    end
  end

  def InstaImage.downloaded?(filename)
    InstaImage.find_by_filename(filename) ? true : false
  end

end
