require './lib/dish'
require './lib/menu'
require './lib/menufactory'
require './lib/orderfactory'
require './lib/order'
require './lib/invoice'
require './twilio'



menus = {
  :meatliquor => [{:name=>:nigiri_sushi, :price=>13.99},
                  {:name=>:tonkotsu_ramen, :price=>9.95},
                  {:name=>:teriyaki_salmon, :price=>8.80}],
  :nobu => [{:name=>:dead_hippy, :price=>8.99},
              {:name=>:black_palace, :price=>9.95},
              {:name=>:buffalo_chicken, :price=>8.80},
              {:name=>:cheese_fries, :price=>5.50}]
}

list1 = [{:name=>:nigiri_sushi, :price=>13.99},
              {:name=>:tonkotsu_ramen, :price=>9.95},
              {:name=>:teriyaki_salmon, :price=>8.80}]

list2 = [{:name=>:dead_hippy, :price=>8.99},
              {:name=>:black_palace, :price=>9.95},
              {:name=>:buffalo_chicken, :price=>8.80},
              {:name=>:cheese_fries, :price=>5.50}]
nobu_menu = MenuFactory.build(list1)
meatliquor_menu = MenuFactory.build(list2)

order = OrderFactory.load(meatliquor_menu)
order.choose_item(:dead_hippy,2)
order.choose_item(:cheese_fries)
order.confirm_order
order.place_order(ENV['PNUM'])





order = {:dish1 => {:quantity => 2, :subtotal => 5 },:dish2 => {:quantity => 3, :subtotal => 10},:total => 10}

def confirmed_order_lines(order)
  str = ''
  order.each {|key,value|
    str += key.to_s
    if key == :total
      value
    else
      value.each {|k2,v2|
        str += (quan_or_sub1(k2,v2) + quan_or_sub3(k2,v2) + quan_or_sub2(k2,v2))
      }
    end
    }
  str
end

def quan_or_sub2(key,value)
  key == :subtotal ? "\n" : " "
end

def quan_or_sub1(key,value)
  key == :quantity ? "x" : ""
end

def quan_or_sub3(key,value)
  key == :subtotal ? "£#{num_format(value)}" : value.to_s
end

def num_format(num)
  '%.2f' % num
end

confirmed_order_lines(order)
