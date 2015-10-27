class ConfirmOrderLines

  def self.calc(order)
    ConfirmOrderLines.new.confirmed_order_lines(order)
  end

# order = {:dish1 => {:quantity => 2, :subtotal => 5 },:dish2 => {:quantity => 3, :subtotal => 10},:total => 10}


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

end