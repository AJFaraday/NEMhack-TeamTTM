# Message Busses, locations for data to be passed back from scripts

class MessageBus < ActiveRecord::Base

  has_many :messages

  def to_s
    result = ""
    result << '=' * 100
    result << "\n"
    result << self.label.upcase
    result << "\n"
    result << '=' * 100
    result << "\n"
    self.messages.order('id desc').limit(5).each do |message|
      result << message.to_s
      result << "\n"
    end
    result << "\n"
  end

end
