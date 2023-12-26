# Import the library.
require 'tk'

# Root window.
root = TkRoot.new { title 'Push Me'
background '#111188'
}

# Add a label to the root window.
lab = TkLabel.new(root) {
  text "Push the Button"
  background '#3333AA'
  foreground '#CCCCFF'
}

# Make it appear.
lab.pack('side' => 'left', 'fill' => 'y')

# Here's a button. Also added to root by default.
TkButton.new {
  text "PUSH"
  background '#EECCCC'
  activebackground '#FFEEEE'
  foreground '#990000'
  command { print "Arrrrrrg!\n" }
  pack('side' => 'right')
}

Tk.mainloop





# Import the library.
require 'tk'

# Root window.
root = TkRoot.new { title 'Push Me' }

# Add a label to the root window.
lab = TkLabel.new(root) { text "Push the Button" }
# Make it appear.
lab.pack

# Here's a button. Also added to root by default.
TkButton.new {
  text "PUSH"
  command { print "Arrrrrrg!\n" }
  pack
}

Tk.mainloop







require 'tk'

$resultsVar = TkVariable.new
root = TkRoot.new
root.title = "Window"

image = TkPhotoImage.new
image.file = "programminghub.gif"

label = TkLabel.new(root) 
label.image = image
label.place('height' => image.height, 
            'width' => image.width, 
           'x' => 10, 'y' => 10)
Tk.mainloop




#
# This creates a simple animation of five balls bouncing around inside a 
# rectagle. Balls bounce off the sides, but pass through each other. Nothing
# fancy.
#

# Import the library.
require 'tk'

# Dot diameter.
Diameter = 10

# Update rate (ms).
Frequency = 25

# Canvas size.
Width = 400
Height = 300

# Set defaults. Some we keep in constants to use later.
BG = '#ccccff'
TkOption.add('*background', BG)

# Root window.
root = TkRoot.new('background' => BG) { title 'Bouncy, Bouncy' }

# Canvas.
c = TkCanvas.new(root) {
  width Width
  height Height
  pack('fill' => 'both')
}

# This is the circle that wanders around the canvas.
class MovingCircle < TkcOval
  # Create with a moving circle on the canvas c with indicated color.
  def initialize(c, color)
    # Remember the canvas.
    @canv = c

    # Choose an initial location at random and create the object there.
    @xpos = rand(Width - Diameter)
    @ypos = rand(Height - Diameter)
    super(c, @xpos, @ypos, @xpos + Diameter, @ypos + Diameter, 'fill' => color)
    # Chose a velocity at random. 1 to 3 pixels per Frequency in each
    # dimension.
    @delx = (rand(3)+1)*(
    if rand(2) == 1 then
      1
    else
      -1
    end)
    @dely = (rand(3)+1)*(
    if rand(2) == 1 then
      1
    else
      -1
    end)

    # Start moving
    Tk.after(Frequency, proc { self.move })
  end
# This adjusts a single dimension by one step, taking account of the
  # walls. Send a position, increment, and limit, and get back a new pos
  # and new increment (which might have its sign changed).
  def del(pos, inc, limit)
    # Move
    pos += inc

    # See if we hit the top or left, and reverse.
    if pos < 0 then
      pos = -pos
      inc = -inc

      # Likewise check for hitting the right or bottom
    elsif pos > limit - Diameter then
      pos = (limit - Diameter) - (pos - (limit - Diameter))
      inc = -inc
    end

    # Send back the results.
    return pos, inc
  end

  # Move one step, then schedule the next move.
  def move
    # Remember current position, and compute the new one.
    oldx, oldy = @xpos, @ypos
    @xpos, @delx = del(@xpos, @delx, Width)
    @ypos, @dely = del(@ypos, @dely, Height)

    # Tell Tk about it.
    @canv.move(self, @xpos - oldx, @ypos - oldy)

    Tk.after(Frequency, proc { self.move })
  end
end

# Make several balls of different color.
for color in ['#FF9999', '#99FFFF', '#005588', '#992211', '#FF0055']
  MovingCircle.new(c, color)
end

Tk.mainloop







# This shows a potential problem in providing button actions. The code blocks
# are run in the context of the caller, but not until the button is pressed.  
# Therefore variable values are current as of the button press. This is not
# always what you want.
#
require 'tk'

# Root window
root = TkRoot.new{
  title 'Binding and Action'
}

# Three buttons created in a loop, numbering from 1 to 3.
bnum = 1
for fred in [ 17, 348, -48 ]
  TkButton.new(root) {
    text "Button " + bnum.to_s
    command proc { print "Button ", bnum, ", fred = ", fred, "\n" }
    grid('column' => 0, 'row' => bnum-1, 'sticky' => 'news')
  }

  bnum += 1
end
# This holds and prints two values. The parms are evaluated when the
# object is created, so we get the right values. The button command
# will use any object which understands the call method.
class Printer
  def initialize(num, fred)
    @num = num
    @fred = fred
  end
  def call
    print "Button ", @num, ", fred = ", @fred, "\n"
  end
end

# Three more buttons, but this time they use the Printer class and work
# correctly.
for fred in [ 'Dogbert', 97, 111 ]
  TkButton.new(root) {
    text "Button " + bnum.to_s
    command Printer.new(bnum, fred)
    grid('column' => 1, 'row' => bnum-4, 'sticky' => 'news')
  }

  bnum += 1
end
# This is a more generic solution
class Runner
  # Set a proc and some args.
  def initialize(method, *args)
    @method = method
    @args = args
  end

  # Run it with the args.
  def call
    @method.call(*@args)
 end
end

# Three more, but this time they work correctly.
for fred in [ 86, 12, 123 ]
  TkButton.new(root) {
    text "Button " + bnum.to_s
    command Runner.new(proc { |n, f|
                         print "Button ", n, ", fred = ", f, "\n" },
                       bnum, fred)
    grid('column' => 2, 'row' => bnum-7, 'sticky' => 'news')
  }

  bnum += 1
end

# These are sort of button-like, but use binding.
lnum = 1
for fred in [ 2973, 'Nosebleed', 349 ]
  b = TkLabel.new(root) {
    text "Label " + lnum.to_s
    grid('column' => 3, 'row' => lnum-1, 'sticky' => 'news')
    relief 'raised'
    background '#999999'
    padx 10
  }
  b.bind('Button-1',
         proc { print "Label ", lnum, ", fred = ", fred, "\n" })

  lnum += 1
end

# This shows a nice feature of bind which allows extra parameters to be
# sent in.
for fred in [ 98733, 128, 'Norbert' ]
  b = TkLabel.new(root) {
    text "Label " + lnum.to_s
    grid('column' => 4, 'row' => lnum-4, 'sticky' => 'news')
    relief 'raised'
    background '#999999'
    padx 10
  }
  b.bind('Button-1',
         proc { | n, f | print "Label ", n, ", fred = ", f, "\n" }, lnum, fred)

  lnum += 1
end

Tk.mainloop