!
! passing a structure (user defined type) to a C function
! getting a structure (user defined type) as the result of a C function
!
! $CC -c -I. example_027.c && $FC -I. example_027.F90 example_027.o && ./a.out
! where $CC is the C compiler and $FC the Fortran compiler
!
program example_027
  use ISO_C_BINDING
  implicit none
#define IN_FORTRAN_CODE
#include <example_027.h>
  interface
    function demo_init(d) result(r) bind(C, name='init_demo')
      import :: demo
      type(demo), intent(IN), value :: d
      type(demo) :: r
    end
  end interface
  type(demo) :: d = demo(0, C_NULL_PTR, 0, 0, ' ', ' ')
  print *,'demo_init'
  d = demo_init(d)  ! call the C function to initialize the structure
  print *, d%i64, d%i32, d%j32, d%c8(1:1), d%c16(16:16)
end
