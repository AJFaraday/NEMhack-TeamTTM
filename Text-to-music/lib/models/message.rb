class Message < ActiveRecord::Base

  belongs_to :message_bus

  def to_s
    "[#{ip_address}] - #{text}"
  end

end
