# Get the parts of speech.
print "Please enter a past-tense verb: "
verb = gets.chomp
print "Please enter a noun: "
noun = gets.chomp
print "Please enter a proper noun: "
prop_noun = gets.chomp
print "Please enter a an adverb: "
adv = gets.chomp

# See where to put it.
print "Please enter a file name: "
fn = gets.chomp
handle = open(fn,"w")

# Go.
printf(handle, "%s got a %s and\n%s %s around the block.\n",
       prop_noun, noun, verb, adv)
handle.close






# Count and report the number of lines and characters in a file.
print "File name: "
fn = gets.chomp
begin
  f = open(fn)
  nlines = 0
  length = 0
  f.each { |line| nlines += 1; length += line.length }
rescue
  print "File read failed: " + $! + "\n"
else
  print fn, ": ", nlines, " lines, ", length, " characters.\n"
end