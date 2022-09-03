import unittest

import Echon
#[
  Hopefully enough tests to make this library not that buggy. Hopefully. :D
]#
test "generate l-systems":
  check generateSystem("A", @[(sym: 'A', word: "ABCA")], 0) == "ABCA"
  check generateSystem("A", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 0) == "AB"
  check generateSystem("C", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 0) == "C"
  check generateSystem("AA", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 0) == "ABAB"
  check generateSystem("AA", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 1) == "ABCCABCC"
  check generateSystem("ABC", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 1) == "ABCCCCC"
  check generateSystem("F--F--F", @[(sym: 'F', word: "F+F--F+F")], 0) == "F+F--F+F--F+F--F+F--F+F--F+F"
  check generateSystem("A", @[(sym: 'A', word: "AA")], 5) == "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

test "generate points":
  check generatePoints("", (x: 0.0, y: 0.0, dir: 0.0), 3.141) == @[(x: 0.0, y: 0.0, dir:0.0)]

test "generate points from system":
  check generatePoints(generateSystem("ABC", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 1), (x: 0.0, y: 0.0, dir: 0.0), 3.141) == generatePointsForSystem("ABC", @[(sym: 'A', word: "AB"), (sym: 'B', word: "CC")], 1, (x: 0.0, y: 0.0, dir: 0.0), 3.141)