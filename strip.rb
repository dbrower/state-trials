#!/usr/bin/env ruby -E ASCII-8bit
f = nil
n = 1
STDIN.each do |s|
  case
  when s =~ /^=====+(\w+)/
    f.close if f
    f = open("#{$1}.txt", "w")
  when s =~ /^=====/
    (f.close; f = nil) if f
  when s =~ /(\d{3})\./
    f = open("#{$1}.txt", "w") unless f
    f.write(s)
  else
    unless f
      f = open("xx#{n}.txt", "w")
      n += 1
      print "#{$.}: #{s}"
    end
    f.write(s)
  end
end
f.close if f
