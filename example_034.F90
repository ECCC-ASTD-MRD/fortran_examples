
! example of usage of intrinsic functions to initialize
! a parameter
program example_034
  implicit none
  integer, parameter :: a = 2
  integer, parameter :: b = merge(12, 23, a==2)
  real, parameter :: x = 2.0
  real, parameter :: y = sqrt(x)
  real, parameter :: z = sin(x)
  real, parameter :: pisur4 = atan(1.0)
  print *,b, y, z, pisur4
end
