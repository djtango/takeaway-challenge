require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

require './lib/dish'
require './lib/menu'
require './lib/menufactory'
require './lib/orderfactory'
require './lib/order'
require './lib/invoice'
require './twilio'
require './lib/confirmorderlines'

menus = {
  :nobu => [{:name=>:nigiri_sushi, :price=>13.99},
                  {:name=>:tonkotsu_ramen, :price=>9.95},
                  {:name=>:teriyaki_salmon, :price=>8.80}],
  :meatliquor => [{:name=>:dead_hippy, :price=>8.99},
              {:name=>:black_palace, :price=>9.95},
              {:name=>:buffalo_chicken, :price=>8.80},
              {:name=>:cheese_fries, :price=>5.50}]
}

begin_order = "Thank you for hitting up Deon Dumplings, what restaurant would you like to order from? \nPlease reply 'meatliquor' for Meat Liquor, 'nobu' for Nobu."

unrecognised_command = "Thank you for hitting up Deon Dumplings, your favourite double Ds. Text ordering is now supported, text 'order' to start!"

sms_order_placed = "Order placed, please await confirmation..."

def sms_confirm_order(order)
  "Your order is: #{confirmed_order_lines(order)}\nPlease text 'place_order' to proceed to checkout."
end

def confirmed_order_lines(order)
  ConfirmOrderLines.calc(order)
end
def present_order(order)
  string = 'Your order so far is:'
  order.current_order.each {|dish| string += "#{dish.name}: #{dish.price}\n" }
  string
end
def text_menu(menu)
  menu_txt = "Menu:\nPlease reply with the name of the dish to add that item to your order. Text 'place_order' separately when you're done ordering."
  menu.each {|dish| dish.each {|key,value| menu_txt = "#{menu_txt}#{value}" + key_or_value(key,value) } }
  menu_txt
end
def key_or_value(key,value)
    key == :price ? "\n" : " "
end

get '/sms-quickstart' do
  body = params['Body']
  puts params
  p params.inspect
  twiml = Twilio::TwiML::Response.new do |r|
    if body == 'order'
      r.Message(begin_order)
    elsif body == 'meatliquor'
      $menu = MenuFactory.build(menus[:meatliquor])
      $order = OrderFactory.load($menu)
      r.Message(text_menu(menus[:meat_market]))
    elsif body == 'nobu'
      $menu = MenuFactory.build(menus[:nobu])
      $order = OrderFactory.load($menu)
      r.Message(text_menu(menus[:nobu]))
    elsif body == 'nigiri_sushi'
      $order.choose_item(:nigiri_sushi)
      r.Message(present_order($order))
    elsif body == 'place_order'
      final_order = $order.confirm_order
      $order.place_order(params['From'])
      r.Message(sms_order_placed)
    elsif body == 'confirm'
      $order.confirm_order
      r.Message(sms_confirm_order)
    else
      r.Message(unrecognised_command)
    end
  end
  twiml.text
end