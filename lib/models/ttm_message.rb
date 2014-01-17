require 'erb'
require 'active_support'
class TTMMessage < ActiveRecord::Base

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

  def generate_score
    #@left_hand = "a8 r b r c"
    #@right_hand = "r8 a r b r"
    #@left_lyrics = "1 3 5"
    #@right_lyrics = "2 4"
    @left_hand =    ""
    @right_hand =   ""
    @left_lyrics =  ""
    @right_lyrics = ""
    self.text.chars.each_with_index{|char,index|generate_markup_for(char,index)}
    create_score_image
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
      when 32 # space
        add_rest(8)
      when 46 # full stop
        add_rest(4)
      when 44 # comma
        add_rest(8)
      else
        puts '.'
    end
  end

  def add_to_left(note,char)
    @left_hand << "#{note}8 "
    # r is a rest
    # s is an invisible rest
    @right_hand << "s8 "
    @left_lyrics << "\"#{char}\"8 "
  end

  def add_to_right(note,char)
    @left_hand << "s8 "
    @right_hand << "#{note}8 "
    @right_lyrics << "\"#{char}\"8 "    
  end

  def add_rest(note_value)
    @left_hand << "r#{note_value} "
    @right_hand << "r#{note_value} "
  end

  def create_score_image
    lilypond_markup = ERB.new(File.open("#{File.dirname(__FILE__)}/../../views/score_fragment.ly.erb").read)
    #lilypond --png -o notation/test notation/test.ly
    File.open("#{File.dirname(__FILE__)}/../../notation/tmp.ly", 'w') { |file| file.write(lilypond_markup.result(binding))}
    puts "lilypond --png -o #{self.image_command} #{File.dirname(__FILE__)}/../../notation/tmp.ly"
         `lilypond --png -o #{self.image_command} #{File.dirname(__FILE__)}/../../notation/tmp.ly`
  end

  def image_command
    "#{File.dirname(__FILE__)}/../../public/notation/#{self.image_name}"
  end

  def image_name
    "fragment_#{self.id}"
  end
 
  def image_path
    "public/notation/#{image_name}.png"
  end

  def play
    TTMMessage.pd.send_string(self.text)
    self.update_attribute(:played, true) 
  end

end 
