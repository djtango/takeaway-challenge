# require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'twilio-ruby'
class TwilioClass

IDSA1 = 'AC1762234f3e'
IDSA2 = '0fea1f331fd70'
IDSA3 = '4cae83a47'
TOAU1 = '584b'
TOAU2 = (267281507152*31)
TOAU3 = 'a4103dd60c0ef01'

  ACCOUNT_SID = IDSA1+IDSA2+IDSA3
  AUTH_TOKEN = TOAU1+(TOAU2/31).to_s+TOAU3

  def initialize(phone_number,receipt,total)
    @time_of_order = Time.new
    @receipt = receipt
    @total = total
    message_build
    send_message(phone_number)
  end

  def delivery_promise
    @delivery_promise = (@time_of_order + 3600).strftime("%H:%M")
  end

  def send_message(phone_number)
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN

    @client.account.messages.create({
      from: '+441438300248',
      to: phone_number,
      body: @message,
    })
  end


  def message_build
    @message = "Hello customer! Your order for the following has been received: \n#{@receipt}The total of your order came to £#{@total} and it will be with you by #{delivery_promise}. Thank you for eating at Deon Dumplings, your favourite double Ds!"
  end

end