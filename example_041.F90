! importing symbols from modules
! if AMBIGUOUS is defined, a compilation error is expected
module mod_040_1
  implicit none
  integer :: s1 = 1
end module
module mod_040_2
  implicit none
  integer :: s1 = 2
end module
program example_041
  use mod_040_1
#if defined(AMBIGUOUS)
  use mod_040_2
#else
  use mod_040_2, local2 => s1
#endif
  implicit none
  print *,'s1 =', s1
end program
