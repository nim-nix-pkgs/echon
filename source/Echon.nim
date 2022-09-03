import tables, math, algorithm

type
  ## A tuple that represents a replacement rule for the l-system.
  Prule* = tuple
    sym: char
    word: string
  
  ## A tuple that represents a point and a direction.
  Point* = tuple
    x: float
    y: float
    dir: float

proc generatePoints*(lsystem: string, start: Point, angle: float, stepsize: float = 1.0): seq[tuple[x: float, y: float, dir: float]] =
  ## Takes a lsystem as string, a starting point (x: float, y: float, dir: float), a initial angle and a optional stepsize to generate the
  ## points of the given lsystem.

  var res: seq[tuple[x: float, y: float, dir: float]] = @[start]
  var curPoint = start
  var positionStack: seq[tuple[x: float, y: float, dir: float]] = @[]

  for c in lsystem:
    case c:
      of 'A'..'Z':
        curPoint.x = curPoint.x + cos(curPoint.dir) * stepsize
        curPoint.y = curPoint.y + sin(curPoint.dir) * stepsize
        res.add(curPoint)
      of 'a'..'z':
        continue
      of '[':
        positionStack.add(curPoint)
      of ']':
        if positionStack.len > 0:
          curPoint = positionStack.pop()
      of '+':
        curPoint.dir += angle
      of '-':
        curPoint.dir -= angle
      else:
        discard
  
  res.reverse
  return res
  
proc generateSystem*(start: string, p: seq[Prule], cycle: int): string =
  ## Takes a starting word, a seq of rules and a int for the number of recurring cycles 
  ## and produces a string that represents the input string after the l-system transformations.
  
  #[
    Convert the rules into a table to get faster access to the keys.
  ]#
  let ruletable = p.toTable()

  var 
    input = start  
    res = ""

  #[
    Checks if there is a rule that applies to the current char c in the current word. 
    If so look up the replacement and put it in the string.
    If there is no such rule just write the character as it is.
  ]#
  for _ in countdown(cycle, 0):
    res = ""
    for c in input:
      if ruletable.hasKey(c):
        res.add(ruletable.getOrDefault(c, "ERROR"))
      else:
        res.add(c)
    input = res
  
  return res

proc generatePointsForSystem*(start: string, p: seq[Prule], cycle: int, startPoint: Point, angle: float, stepsize: float = 1.0): seq[tuple[x: float, y: float, dir: float]] =
  ## Takes a start word, a sequence of rules (sym: char, word: string), a cycle depth, a starting point (x: float, y: float, dir: float)
  ## a angle in radians and a optional stepsize (distance between the calculated points) and returns a sequence of points (x: float, y: float, dir: float)
  ## that represent the evaluated l-system in a two dimensional plane. This function combines the functions 'generateSystem' and 'generatePoints'.
  let system = generateSystem(start, p, cycle)
  let points = generatePoints(system, startPoint, angle, stepsize)
  return points

iterator generatePointsIter*(lsystem: string, start: Point, angle: float, stepsize: float = 1.0): tuple[x: float, y: float, dir: float] =
  let pointseq = generatePoints(lsystem, start, angle, stepsize)

  for p in pointseq:
    yield p
    