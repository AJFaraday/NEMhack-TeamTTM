require 'erb'
require 'active_support'

require "#{File.dirname(__FILE__)}/../../Text-to-music/lib/pd-connect"
class TTMMessage < ActiveRecord::Base

  belongs_to :source, :polymorphic => true

  LOWER_CASE_NOTES = [
    "c",  "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "ais", "b", 
    "c'", "cis'","d'","dis'","e'","f'","fis'","g'","gis'","a'","ais'","b'",
    "c''","cis''"
  ]	
 
  UPPER_CASE_NOTES = [
    "c'",  "cis'", "d'", "dis'", "e'", "f'", "fis'", "g'", "gis'", "a'", "ais'", "b'", 
    "c''", "cis''","d''","dis''","e''","f''","fis''","g''","gis''","a''","ais''","b''",
    "c'''","cis'''"
  ]

  NUMBER_NOTES = [
    "c",  "eis",  "gis",  "a",
    "c'", "eis'", "gis'", "a'",
    "c''","eis''"
  ]

  self.table_name = 'ttm_messages' 

  
  
  cattr_accessor :pd

  begin
    TTMMessage.pd ||= PureData.new
  rescue => er
    puts er.message
    puts er.backtrace[0..4].join("\n")
  end


  after_create :generate_score
  after_update :delete_if_finished

  def generate_score
    @left_hand =    ""
    @right_hand =   ""
    @left_lyrics =  ""
    @right_lyrics = ""
    @right_rests = 0
    @left_rests = 0
    @hidden_notes = ""
    @character_lyrics = ""
    self.text.chars.each_with_index{|char,index|generate_markup_for(char,index)}
    draw_left_rests
    draw_right_rests
    create_score_image
  end

  # 
  # It it's been played and the score has been show. get rid.
  #
  def delete_if_finished
    self.destroy if self.played and self.score_shown
  end

  def generate_markup_for(char,index)
    n = char.bytes.to_a[0]
    case char.bytes.to_a[0] # get ascii number
      when 97...122 # lower case
        n = n - 97
        if n <= 11 
          add_to_left(LOWER_CASE_NOTES[n],char)
        else
          add_to_right(LOWER_CASE_NOTES[n], char)
        end
      when 65..90   # upper case
        n = n - 65
        add_to_right(UPPER_CASE_NOTES[n], char)
      when 48..57 # numbers
        n = n - 48
        if n <= 3
          add_to_left(NUMBER_NOTES[n],char)
        else
          add_to_right(NUMBER_NOTES[n], char)
        end         
      else
        add_char(char)
    end
  end

  def add_to_left(note,char)
    draw_left_rests
    @right_rests += 1
    @hidden_notes << "s8 "
    @left_hand << "#{note}8 "
    @left_lyrics << "\"#{char}\"8 "
  end

  def add_to_right(note,char)
    draw_right_rests
    @left_rests += 1
    @right_hand << "#{note}8 "
    @right_lyrics << "\"#{char}\"8 "
    @hidden_notes << "s8 "
  end

  def add_char(char)
    #draw_left_rests
    #draw_right_rests
    @hidden_notes << "c''8 "
    @character_lyrics << "\"#{char}\"8 "
    @right_rests += 1
    @left_rests += 1
  end

  # r is a rest
  # s is an invisible rest
  def draw_left_rests
    if @left_rests > 0
      big_rests = @left_rests / 2
      small_rests = @left_rests % 2
      big_rests.times{@left_hand << "r4 "}
      @left_hand << "r#{(8.0/small_rests).to_i} " if small_rests > 0
      @left_rests = 0
    end
  end

  def draw_right_rests
    if @right_rests > 0
      big_rests = @right_rests / 2
      small_rests = @right_rests % 2
      big_rests.times{@right_hand << "r4 "}
      @right_hand << "r#{(8.0/small_rests).to_i} " if small_rests > 0
      @right_rests = 0
    end
  end

  def create_score_image
    lilypond_markup = ERB.new(File.open("#{File.dirname(__FILE__)}/../../views/score_fragment.ly.erb").read)
    File.open("#{File.dirname(__FILE__)}/../../notation/tmp.ly", 'w') { |file| file.write(lilypond_markup.result(binding))}
    puts "lilypond --png -o #{self.image_command} #{File.dirname(__FILE__)}/../../notation/tmp.ly"
         `lilypond --png -o #{self.image_command} #{File.dirname(__FILE__)}/../../notation/tmp.ly`
    self.update_attribute :file_generated, true
  end

  def image_command
    "#{File.dirname(__FILE__)}/../../public/notation/#{self.image_name}"
  end

  def image_name
    "fragment_#{self.id}"
  end
 
  def image_path
    "/notation/#{image_name}.png"
  end

  def play
    TTMMessage.pd.send_string(self.text)
    self.update_attribute(:played, true) 
  end
 
  def TTMMessage.newest_unplayed
    TTMMessage.first(:conditions => ['played is null'], :order => 'id desc')
  end

  def TTMMessage.newest_not_shown
    message = TTMMessage.first(:conditions => ['score_shown is null'], :order => 'id desc')
    if message 
      message.update_attribute :score_shown, true
    end
    message
  end 

  def TTMMessage.oldest_unplayed
    TTMMessage.first(:conditions => ['played is null'], :order => 'id asc')
  end

  def TTMMessage.oldest_not_shown
    message = TTMMessage.first(:conditions => ['score_shown is null'], :order => 'id asc')
    if message 
      message.update_attribute :score_shown, true
    end
    message
  end 


end 
