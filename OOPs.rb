# Class names must be capitalized. Technically, it's a constant.
class Fred

    # The initialize method is the constructor. The @val is
    # an object value.
    def initialize(v)
  
      @val = v
    end
  
    # Set it and get it.
    def set(v)
      @val = v
    end
  
    def get
      return @val
    end
  end
  
  # Objects are created by the new method of the class object.
  a = Fred.new(10)
  b = Fred.new(22)
  
  print 'A: ', a.get, ' ', b.get, "\n";
  b.set(34)
  print 'B: ', a.get, ' ', b.get, "\n";
  
  # Ruby classes are always unfinished works. This does not
  # re-define Fred, it adds more stuff to it.
  class Fred
    def inc
      @val += 1
    end
  end
  
  a.inc
  b.inc
  print "C: ", a.get, " ", b.get, "\n";
  
  # Objects may have methods all to themselves.
  def b.dec
    @val -= 1
  end
  
  begin
    b.dec
    a.dec
  rescue StandardError => msg
    print "Error: ", msg, "\n"
  end
  
  print "D: ", a.get, " ", b.get, "\n";
  
  
  
  
  
  # Class names must be capitalized. Technically, it's a constant.
  class Fred
  
    # The initialize method is the constructor. The @val is
    # an object value.
    def initialize(v)
      @val = v
    end
  
    # Set it and get it.
    def set(v)
      @val = v
    end
  
    def get
      return @val
    end
  
    def more(y)
      @val += y
    end
  
    def less(y)
      @val -= y
    end
  
    def to_s
      return "Fred(val=" + @val.to_s + ")"
    end
  end
  
  # Class Barney is derived from Fred with the usual meaning.
  class Barney < Fred
    def initialize(x)
      super(x)
      @save = x
    end
  
    def chk
      @save = @val
    end
  
    def restore
      @val = @save
    end
  
    def to_s
      return "(Backed-up) " + super + " [backup value: " + @save.to_s + "]"
    end
  
  end
  
  # Objects are created by the new method of the class object.
  a = Fred.new(398)
  b = Barney.new(112)
  
  a.more(34)
  b.more(817)
  print "A: a = ", a, "\n b = ", b, "\n";
  
  a.more(34)
  b.more(817)
  
  print "B: a = ", a, "\n b = ", b, "\n";
  
  b.chk
  
  a.more(34)
  b.more(817)
  
  print "C: a = ", a, "\n b = ", b, "\n";
  
  b.restore
  
  print "D: a = ", a, "\n b = ", b, "\n";
  
  
  
  
  
  # Class names must be capitalized. Technically, it's a constant.
  class Fred
  
    # The initialize method is the constructor. The @val is
    # an object value.
    def initialize(v)
      @val = v
    end
  
    # Set it and get it.
    def set(v)
      @val = v
    end
  
    def to_s
      return "Fred(val=" + @val.to_s + ")"
    end
  
    # Since a simple access function is so common, ruby lets you declare one
    # automatically, like this:
    attr_reader :val
    # You can list any number of object variables. Separate by commas, and each
    # needs its own colon
    # attr_reader :fred, :joe, :alex, :sally
  end
  
  class Alice <Fred
    # We have a message, too.
    def initialize(n, m)
      super(n)
      @msg = m
    end
  
    # Takes the base result and changes the class name.
    def to_s
      ret = super
      ret.gsub!(/Fred/, 'Alice')
      return ret + ' ' + @msg + '!'
    end
  
    # The = allows the method to be used on the right, and the left of the
    # assignment is the parameter.
    def appmsg=(more)
      @msg += more
    end
  
    # Like attr_reader, if you want the data to be assignable.
    attr_writer :msg
  end
  
  a = Fred.new(45)
  b = Alice.new(11, "So there")
  
  print "A: a = ", a, "\n b = ", b, "\n"
  
  print "B: ", a.val, " ", b.val, "\n"
  
  b.msg = "Never"
  print "B: b = ", b, "\n"
  b.appmsg = " In a million years"
  print "C: b = ", b, "\n"