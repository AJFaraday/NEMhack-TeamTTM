require 'erb'
require 'active_support'
class TTMMessage < ActiveRecord::Base

 
  self.table_name = 'ttm_messages' 

  cattr_accessor :pd

  TTMMessage.pd ||= PureData.new


  def generate_score
    lilypond_markup = ERB.new(File.open("#{File.dirname(__FILE__)}/../../views/score_fragment.ly.erb").read)
    #lilypond --png -o notation/test notation/test.ly
    File.open("#{File.dirname(__FILE__)}/../../notation/tmp.ly", 'w') { |file| file.write(lilypond_markup.result)}
    `lilypond --png -o #{File.dirname(__FILE__)}/../../notation/fragment_#{self.id} #{File.dirname(__FILE__)}/../../notation/tmp.ly`
  end

  def play
    TTMMessage.pd.send_string(self.text)
    self.update_attribute(:played, true) 
  end

end 
