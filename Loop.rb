# Some counting with a while.
a = 0
while a < 15
  print a, " "
  if a == 10 then
    print "made it to ten!!"
  end
  a = a + 1
end
print "\n"

# Here's a way to empty an array.
joe = %w(eggs. some break to Have)
print(joe.pop, " ") while joe.size > 0
print "\n"



# Simple for loop using a range.
for i in (1..4)
  print i," "
end
print "\n"

for i in (1...4)
  print i," "
end
print "\n"

# Running through a list (which is what they do).
items = [ 'Mark', 12, 'goobers', 18.45 ]
for it in items
  print it, " "
end
print "\n"

# Go through the legal subscript values of an array.
for i in (0...items.length)
  print items[0..i].join(" "), "\n"
end