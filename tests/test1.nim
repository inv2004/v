import unittest
import zero_functional

import v

test "init":
  check initV[int](5).len == 5

test "add":
  let v = @[1,2,3]
  check 100+v == @[101,102,103]
  check v+100 == @[101,102,103]
  check @[1,2,3] + @[100,200,300] == @[101,202,303]

test "mul":
  let v = @[1,2,3]
  check 100*v == @[100,200,300]
  check v*100 == @[100,200,300]
  check @[1,2,3] * @[100,200,300] == @[100,400,900]

test "rand":
  let v = randV[int](100, 5..10)
  check v.len == 100
  check v *>= 5
  check v *<= 11

test "cmp":
  var v = @[10,11,12]
  check v *> 9
  check v *>= 10
  check v *< 13
  check v *<= 12

test "group":
  let v = @[1,2,1,1,2]
  let c = v.toCounter()
  echo c

test "groupByte":
  let v = @[byte(1),2,1,1,2] 
  echo v.toCounter()