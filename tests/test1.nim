import unittest
import zero_functional
import tables

import v

test "init":
  check initV[int](5).len == 5
  check initV[byte](5).len == 5

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
  check randV(100, 10) *<= 10

  let v = randV(100, 5..10)
  check v.len == 100
  check v *>= 5
  check v *<= 11

test "cmp":
  var v = @[10,11,12]
  check v *> 9
  check v *>= 10
  check v *< 13
  check v *<= 12

test "count":
  check @[1,2,1,1,2].count() == initCounter({1:3, 2:2})
  check @[1'u8,2,1,1,2].count() == initCounter({1'u8:3, 2'u8:2})

test "sum":
  check @[1,2,3,4,5].sum() == 15
  check @[1'u8,2,3,4,5].sum() == 15

test "sumC":
  check @[1000,2,3,4,5].count().sum() == 5
  check @[1'u8,2,3,4,5].count().sum() == 5