! ignore type/kind/rank
!
! make  FC=my_fortran_compiler example_008
! make  FC=ifort example_008
subroutine demo
  implicit none
  interface
    subroutine test(argument)  ! calling test, anything goes
      implicit none
      integer, dimension(*) :: argument
! some compilers may issue warnings about unrecognized directive(s)
!GCC$ ATTRIBUTES NO_ARG_CHECK :: argument
!DEC$ ATTRIBUTES NO_ARG_CHECK :: argument
!$PRAGMA IGNORE_TKR argument
!DIR$ IGNORE_TKR argument
!IBM* IGNORE_TKR argument
    end subroutine
  end interface
  integer, dimension(1,2,3) :: i123
  real, dimension(4,5)      :: r45
  i123 = 128
  call test(i123)     ! integer array
  r45 = 1.0
  call test(r45)      ! real array
  call test(128)      ! scalar integer
  call test(1.0)      ! scalar real
  call test('0123')   ! character string
end subroutine

program test_demo
  implicit none
  call demo
end

subroutine test(argument)
  use ISO_C_BINDING
  implicit none
  integer, dimension(*), target :: argument  ! target attribute NECESSARY if C_LOC is to be accepted
  integer(C_INTPTR_T) :: address             ! integer large enough to contain an address
  type(C_PTR) :: ptr                         ! some compilers will not allow to print it directly

  ptr = C_LOC(argument(1))                   ! get address of argument
  ! transfer(C_LOC(argument(1)),address) MAY OR MAY NOT produce correct results (compiler dependent)
  address = TRANSFER(ptr, address)           ! transfer into an integer large enough
  print 1,'argument, address :', argument(1), address
1 format(A,2X,Z8.8,2X,Z16.16)
end subroutine
