print "Hello, World!\n"



for i in (1..10)
  rno = rand(100) + 1
  msg = case rno
          when 42 then print "The ultimate result."
          when 1..10 then print "Way too small."
          when 11..15,19,27 then print "Sorry, too small"
          when 80..99 then print "Way to large"
          when 100 then
              print "TOPS\n"
          "Really way too large"
          else "Just wrong"
        end
  print "Result: ", rno, ": ", msg, "\n"
end



# Variables and expressions.
a = 10
b = 3 * a + 2
printf("%d %d\n", a, b);

# Type is dynamic.
b = "A string"
c = 'Another String'
print b + " and " + c + "\n"





# Let the user guess.
print "Enter heads or tails? "
hort = gets.chomp
unless hort == 'heads' || hort == 'tails'
  print "I _said_ heads or tails. Can't you read?\n"
  exit(1)
end

# Now toss the coin.
toss = if rand(2) == 1 then
         "heads"
       else
         "tails"
       end

# Report.
print "Toss was ", toss, ".\n"
print "You Win!\n" if hort == toss





# Double-quoted strings can substitute variables.
a = 17
print "a = #{a}\n";
print 'a = #{a}\n';

print "\n";

# If you're verbose, you can create a multi-line string like this.
b = <<ENDER
This is a longer string,
perhaps some instructions or agreement
goes here. By the way,
a = #{a}.
ENDER

print "\n[[[" + b + "]]]\n";

print "\nActually, any string
can span lines. The line\nbreaks just become
part of the string.
"

print %Q=\nThe highly intuitive "%Q" prefix allows alternative delimiters.\n=
print %Q[Bracket symbols match their mates, not themselves.\n]






s = "Hi there. How are you?"
print s.length, " [" + s + "]\n"

# Selecting a character in a string gives an integer ascii code.
print s[4], "\n"
printf("%c\n", s[4])

# The [n,l] substring gives the starting position and length. The [n..m]
# form gives a range of positions, inclusive.
print "[" + s[4,4] + "] [" + s[6..15] + "]\n"

print "Wow " * 3, "\n"

print s.index("there"), " ", s.index("How"), " ", s.index("bogus"), "\n"

print s.reverse, "\n"






# Assign three values.
a, b, c = 8, 10, 15
print "A: a = ", a, ", b = ", b, ", c = ", c, "\n"

# Compute three values, then assign three values.
a, b, c = 40, a + 11, a + b + c
print "B: a = ", a, ", b = ", b, ", c = ", c, "\n"

# Swap.
a, b = b, a
print "C: a = ", a, ", b = ", b, ", c = ", c, "\n"

# Extras on left get nil.
a, b, c = 2, 3
print "D: a = ", a, ", b = ", b, ", c = ", c, "\n"

# Extras on right get left behind
a, b, c = 11, 12, 13, 14, 15
print "E: a = ", a, ", b = ", b, ", c = ", c, "\n"

# The right can be an array, in which case the members are assigned to
# individual variables.
fred = [ 4, 5, 6, 7]
a, b, c = fred
print "F: a = ", a, ", b = ", b, ", c = ", c, "\n"





# Add the strings before and after around each param and print
def surround(before, after, *items)
  items.each { |x| print before, x, after, "\n" }
end

surround('[', ']', 'this', 'that', 'the other')
print "\n"

surround('<', '>', 'Snakes', 'Turtles', 'Snails', 'Salamanders', 'Slugs',
         'Newts')
print "\n"

def boffo(a, b, c, d)
  print "a = #{a} b = #{b}, c = #{c}, d = #{d}\n"
end

# Use * to adapt between arrays and arguments
a1 = %w(snack fast junk pizza)
a2 = [4, 9]

boffo(*a1)
boffo(17, 3, *a2)






# Place the array in a random order. Floyd's alg.
def shuffle(arr)
  for n in 0...arr.size
    targ = n + rand(arr.size - n)
    arr[n], arr[targ] = arr[targ], arr[n] if n != targ
  end
end

# Make strange declarations.
def pairs(a, b)
  a << 'Insane'
  shuffle(b)
  b.each { |x| shuffle(a); a.each { |y| print y, " ", x, ".\n" } }
end
first = ['Strange', 'Fresh', 'Alarming']
pairs(first, ['lemonade', 'procedure', 'sounds', 'throughway'])
print "\n", first.join(" "), "\n"






# Square the number
def sqr(x)
  return x*x
end

# See how it works.
(rand(4) + 2).times {
  a = rand(300)
  print a,"^2 = ", sqr(a), "\n"
}
print "\n"

# Don't need a parm.
def boom
  print "Boom!\n"
end

boom
boom

# Default parms
print "\n"
def line(cnt, ender = "+", fill = "-")
  print ender, fill * cnt, ender, "\n"
end

line(8)
line(5,'*')
line(11,'+','=')

# Do they change?
def incr(n)
    n = n + 1
end
a = 5
incr(a)
print a,"\n"






a = 10
b = a + 10
c = [ 5, 4, 10 ]
d = [ a ] + c
print "#{a} #{b} [", c.join(" "), "] [", d.join(" "), "]\n";






# Get the parts of speech
print "Please enter a past-tense verb: "
verb = gets.chomp
print "Please enter a noun: "
noun = gets.chomp
print "Please enter a proper noun: "
prop_noun = gets.chomp
print "Please enter a an adverb: "
adv = gets.chomp

# Make the sentence.
print "#{prop_noun} got a #{noun} and\n#{verb} #{adv} around the block.\n"







print "Triangle height: "
h = gets.to_f;
print "Triangle width: "
w = gets.to_f;
area = 0.5*h*w
print "Triangle height ", h, " width ", w, " has area ", area, "\n"






# Pick a random number.
rno = rand(100) + 1
print "Your magic number is ", rno, "\n"

# Perform all sort of totally uselss test on it and report the results.
if rno % 2 == 1 then
  print "Ooooh, that's an odd number.\n"
else
  print "That's an even number.\n"
  if rno > 2 then
    print "It's not prime, BTW.\n"
  end
end

if rno > 50
  print "That's more than half as big as it could be!\n"
elsif rno == 42
  print "That's the ultimate magic number!!!!\n"
elsif rno < 10
  print "That's pretty small, actually.\n"
else
  print "What a boring number.\n"
end

if rno == 100 then print "Gosh, you've maxxed out!\n" end






z = { 'mike' => 75, 'bill' => 18, 'alice' => 32 }
z['joe'] = 44
print z['bill'], " ", z['joe'], " ", z["smith"], "\n"
print z.has_key?('mike'), " ", z.has_key?("jones"), "\n"






a = [ 45, 3, 19, 8 ]
b = [ 'sam', 'max', 56, 98.9, 3, 10, 'jill' ]
print (a + b).join(' '), "\n"
print a[2], " ", b[4], " ", b[-2], "\n"
print a.sort.join(' '), "\n"
a << 57 << 9 << 'phil'
print "A: ", a.join(' '), "\n"

b << 'alex' << 48 << 220
print "B: ", b.join(' '), "\n"
print "pop: ", b.pop, "\n"
print "shift: ", b.shift, "\n"
print "C: ", b.join(' '), "\n"

b.delete_at(2)
b.delete('alex')
print "D: ", b.join(' '), "\n"