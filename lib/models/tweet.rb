class Tweet < ActiveRecord::Base

  has_one :ttm_message


  after_create :create_messages
  #
  # creates related records
  # Message - to watch progress in the web interface
  # TtmMessage - To play wit text to music and generate score
  #
  def create_messages
    bus = MessageBus.find_by_label('Twitter')
    ip = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
    bus.messages.create!(
      :ip_address => ip,
      :text => "Tweet: [#{self.username}] #{self.content}"
    )
    
    TTMMessage.create!(
      :text => "[#{self.username}] #{self.content}",
      :source_type => 'Tweet',
      :source_id => self.id
    )
  end

end
