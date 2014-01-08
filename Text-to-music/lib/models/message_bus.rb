# Message Busses, locations for data to be passed back from scripts

class MessageBus < ActiveRecord::Base

  has_many :messages

  def to_s
    #TODO
    "Write this, you idiot!"
  end

end
