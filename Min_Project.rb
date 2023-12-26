require 'tk'
require 'net/ftp'

# Close the connection and terminate pgm.
def term(conn)
  if conn
    begin
      conn.quit
    ensure
      conn.close
    end
  end
  exit
end

# Display an error dialog.
def thud(title, message)
  Tk.messageBox('icon' => 'error', 'type' => 'ok',
                'title' => title, 'message' => message)
end

# This is the login window. It pops up and asks for the remote host and the
# user credentials, and a button to initiate the login when the fields are
# ready.
class LoginWindow
  # Generate s label/entry pair for the login window. These will be
  # appropriately gridded on row row inside par. Text box has width
  # width and places its contents into the reference $ref. If $ispwd,
  # treat it as a password entry box. Returns the text variable which
  # gives access to the entry.
def genpair(row, text, width, ispwd=false)
    tbut = TkLabel.new(@main, 'text' => text) {
      grid('row' => row, 'column' => 0, 'sticky' => 'nse')
    }
    tvar = TkVariable.new('')
    lab = TkEntry.new(@main) {
      background 'white'
      foreground 'black'
      textvariable tvar
      width width
      grid('row' => row, 'column' => 1, 'sticky' => 'nsw')
    }
    lab.configure('show' => '*') if ispwd

    return tvar
  end

  # Log into the remote host. If successful, start the directory loader.
  # Modes are: 1: Anonymous, 2: User, 3: Return, which does anon if the
  # user infor was not filled in, and user otw.
  def do_login(mode)
    host = @host.value
    acct = @acct.value
    password = @password.value

# Adjust user data by mode.
    if mode == 1 || (mode == 3 && acct == "" && password == "")
      acct ='anonymous'
      if password == ""
        password = 'anonymous'
      end
    end

# Make sure we're all filled in.
    if host == "" || acct == "" || password == ""
      thud('No Login Info',
           "You must provide a hostname and login credentials.")
      return
    end

# Attempt to connect to the remote host and log in
    begin
      @conn = Net::FTP.new(host, acct, password)
      @conn.passive = true
    rescue
      thud("Login Failed", $!)
      @conn = nil
      return
    end
# Display the listing in the window.
    @listwin.setconn(@conn)
    @main.destroy()
  end

  def initialize(main, listwin, titfont, titcolor)
    @main = TkToplevel.new(main)
    @main.title('FTP Login')

    # Listing window.
    @listwin = listwin
    @conn = nil

    # This counts through the rows, which makes it easier to modify
    # the program.
    row = -1

    # Label at the top of window.
    toplab = TkLabel.new(@main) {
      text "FTP Server Login"
      justify 'center'
      font titfont
      foreground titcolor
      grid('row' => (row += 1), 'column' => 0, 'columnspan' => 2,
           'sticky' => 'news')
    }
    # Hostname entry
    @host = genpair(row += 1, 'Host:', 25)

    # Login buttons, in a frame for layout.
    bframe = TkFrame.new(@main) {
      grid('row' => (row += 1), 'column' => 0, 'columnspan' => 2,
           'sticky' => 'news')
    }
    TkButton.new(bframe, 'command' => proc { self.do_login(1) }) {
      text 'Anon. Login'
      pack('side' => 'left', 'expand' => 'yes', 'fill' => 'both')
    }
    TkButton.new(bframe, 'command' => proc { self.do_login(2) }) {
      text 'User Login'
      pack('side' => 'left', 'expand' => 'yes', 'fill' => 'both')
    }

    # Login and password entries.
    @acct = genpair(row += 1, 'Login:', 15)
    @password = genpair(row += 1, 'Password:', 15, true)

    stop = TkButton.new(@main, 'command' => proc { term(@conn) }) {
      text 'Exit'
      grid('row' => (row += 1), 'column' => 0, 'columnspan' => 2,
'sticky' => 'news')
    }

    # CR same as pushing login.
    @main.bind('Return', proc { self.do_login(3) })
  end
end

# This is a window containing the file listing.
class FileWindow < TkFrame
  def initialize(main)
    super

    # Set up the title appearance.
    titfont = 'arial 16 bold'
    titcolor = '#228800'

    @conn = nil

    # Label at top.
    TkLabel.new(self) {
      text 'FTP Download Agent'
      justify 'center'
      font titfont
      foreground titcolor
      pack('side' => 'top', 'fill' => 'x')
    }

    # Status label.
    @statuslab = TkLabel.new(self) {
      text 'Not Logged In'
      justify 'center'
      pack('side' => 'top', 'fill' => 'x')
    }

    # Exit button
    TkButton.new(self) {
      text 'Exit'
      command { term(@conn) }
      pack('side' => 'bottom', 'fill' => 'x')
    }

    # List area with scroll bar. The list area is disabled since we
    # don't want the user to type into it.
@listarea = TkText.new(self) {
      height 10
      width 40
      cursor 'sb_left_arrow'
      state 'disabled'
      pack('side' => 'left')
      yscrollbar(TkScrollbar.new).pack('side' => 'right', 'fill' => 'y')
    }

    # Bind the system exit button to our exit.
    main.protocol('WM_DELETE_WINDOW', proc { term(@conn) })

    # Create the login window.
    LoginWindow.new(main, self, titfont, titcolor)
  end

  # Change the color of a tag for entering and leaving. Unfortunately, there
  # is no active color for tags in a text box.
  def recolor(tag, color)
    @listarea.tag_configure(tag, 'foreground' => color)
  end

  # Do a CD and load the contents. If there is no directory name, skip
  # the CD.
  def load_dir(dir)
    if dir
      begin
        @conn.chdir(dir)
      rescue
        thud('No ' + dir, $!)
      end
      @statuslab.configure('text' => "[Loading " + dir + "]")
    else
      @statuslab.configure('text' => '[Loading Home Dir]')
    end
    update

    # Get the list of files.
    files = []
    dirs = []
    sawdots = false
    @conn.list() do |line|
# Real lines start with the perm bits. And we don't want specials.
      if line =~ /^[\-d]([r\-][w\-][x\-]){3}/
        # Extract the useful parts, toss the bones. The limit keeps us from
        # dividing file names containing spaces.
        parts = line.split(/\s+/, 9)
        if parts.length >= 9
          fn = parts.pop()
          sawdots = true if fn == '..'
          if parts[0][0..0] == 'd'
            dirs.push(fn)
          else
            files.push(fn)
          end
        end
      end
    end

    # Add .. if not present, then sort the list.
    dirs.push('..') unless sawdots
    files.sort!
    dirs.sort!

    # Clear the old contents from the directory listing box.
    @listarea.configure('state' => 'normal')
    @listarea.delete('1.0', 'end')

    # Fill in the directories. Bind for directory load (us).
    ct = 0
    while fn = dirs.shift
      tagname = "fn" + ct.to_s
      @listarea.insert('end', fn+"\n", tagname)
      @listarea.tag_configure(tagname, 'foreground' => '#4444FF')
      @listarea.tag_bind(tagname, 'Button-1',
                         proc { |f| self.load_dir(f) }, fn)
      @listarea.tag_bind(tagname, 'Enter',
                         proc { |t| self.recolor(t, '#0000aa') },
                         tagname)
      @listarea.tag_bind(tagname, 'Leave',
                         proc { |t| self.recolor(t, '#4444ff') },
                         tagname)
      ct += 1
    end
# Fill in the files. Bind for download.
    while fn = files.shift
      tagname = "fn" + ct.to_s
      @listarea.insert('end', fn+"\n", tagname)
      @listarea.tag_configure(tagname, 'foreground' => 'red')
      @listarea.tag_bind(tagname, 'Button-1',
                         proc { |f| self.dld_file(f) }, fn)
      @listarea.tag_bind(tagname, 'Enter',
                         proc { |t| self.recolor(t, '#880000') },
                         tagname)
      @listarea.tag_bind(tagname, 'Leave',
                         proc { |t| self.recolor(t, 'red') },
                         tagname)
      ct += 1
    end

    # Lock it up so the user can't mess with it.
    @listarea.configure('state' => 'disabled')

    # Update the status label.
    begin
      loc = @conn.pwd()
    rescue
      thud('PWD Failed', $!)
      loc = '???'
    end
    @statuslab.configure('text' => loc)
  end

  # Download the file.
  def dld_file(fn)
    # Announce.
    @statuslab.configure('text' => "[Retrieving " + fn + "]")
    update

    # Get the file.
    begin
      @conn.getbinaryfile(fn)
    rescue
      thud('DLD Failed', fn + ': ' + $!)
      @statuslab.configure('text' => '')
    else
      @statuslab.configure('text' => 'Got ' + fn)
    end
  end
# This is a hook that the login window calls after a successful login.
  # The login window makes the connection and attempts to login. When this
  # succeeds, it calls setconn() and destroys itself. Setconn records the
  # connection (which the login box created), then does the initial
  # directory load.
  def setconn(conn)
    @conn = conn
    load_dir(nil)
  end
end

# Create the main window, set the default colors, create the GUI, then
# fire the sucker up.
BG = '#E6E6FA'
root = TkRoot.new('background' => BG) { title "FTP Download" }
TkOption.add("*background", BG)
TkOption.add("*activebackground", '#FFE6FA')
TkOption.add("*foreground", '#0000FF')
TkOption.add("*activeforeground", '#0000FF')
FileWindow.new(root).pack()

Tk.mainloop






















#!/usr/bin/ruby -w

time1 = Time.new

puts "Current Time : " + time1.inspect

# Time.now is a synonym:
time2 = Time.now
puts "Current Time : " + time2.inspect