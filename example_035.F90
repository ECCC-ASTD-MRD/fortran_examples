! access to user defined type properties from function result and array member
module ex35
  implicit none
  type :: thing
    integer, dimension(3) :: a1
    integer :: i1
    character(len=3) :: c3
  end type
contains
  function f_ex35() result(r)
    type(thing) :: r
    r%a1 = [1,2,3]
    r%i1 = 123
    r%c3 = '123'
  end function
end module

program example_035
  use ex35
  implicit none
  type(thing) :: r
  type(thing), dimension(2) :: a
  integer :: i

  r = f_ex35()
  print *, r
  a = f_ex35()
  print *, a(1)%i1, a(2)%c3
  i = f_ex35()%i1
end
