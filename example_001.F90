! module containing generic declarations
! make FC=my_fortran_compiler example_001      ! 
! make FC=ifort example_001                    ! O.K.
! make FC=gfortran DEF=-DERROR_1 example_001   ! FAILURE (attempt to use private item)
! make FC=ifort FFLAGS=-i8 example_001         ! FAILURE 8 byte default integer in call to subc
module demo
  implicit none
  type :: bidule
    integer :: i                      ! default integer length
    real :: x                         ! default real length
  end type
  interface subc                      ! interfaces for generic subroutine subc 
    module procedure suba             ! suba comes from module
    module procedure subb             ! subb comes from module demo
    subroutine sub_ext(i)             ! sub_ext is external to the module
      implicit none
      integer, intent(INOUT) :: i
    end subroutine
  end interface
  interface fng
    module procedure fne
    module procedure fnf
  end interface
  ! everything in module is public by default
  ! all variables have the save attribute by default
  integer, public :: entier           ! ,public was not needed
  real, private   :: reel = 1.234     ! ,private makes this variable accessible only by module members
contains
  subroutine suba(x, y)
    implicit none
    integer, intent(INOUT) :: x       ! default integer length
    type(bidule), intent(IN) :: y
    x=x+1
    print *,'suba : x=',x
  end
  subroutine subb(x, y)
    implicit none
    real, intent(INOUT) :: x          ! default real length
    type(bidule), intent(IN) :: y
    x=x+1
    print *,'subb : x=',x
  end
  function fne(x) result(r)
    implicit none
    integer, intent(IN), value :: x   ! default integer length
    integer :: r                      ! default integer length
    r = x + 1
  end function
  function fnf(x) result(r)
    implicit none
    real, intent(IN), value :: x      ! default real length
    real :: r                         ! default real length
    r = x + 1
  end function
  subroutine print_reel
    implicit none
    print *,'print_reel : reel =', reel
  end
end module

subroutine sub_ext(i)
  implicit none
  integer, intent(INOUT) :: i         ! default integer length
  i = i + 1
  print *,'sub_ext : i =',i
end

subroutine subd
  use demo, ONLY : bidule, subc, fng  ! import what we need from the module
  implicit none
  integer(kind=4) :: i            ! explicit 4 byte integer
  real(kind=4) :: r               ! explicit 4 byte real
  type(bidule) :: z
  i = 123
  r = 1.23
  call subc(i, z)
  call subc(r, z)
  print *, 'fng(1.0) =',fng(1.0), 'fng(123) =', fng(123)
  call sub_ext(i)
end 

subroutine sube
  use demo, ONLY : entier         ! import what we need from the module
  implicit none
  print *,'entier =',entier
end

program self_test
  use demo            ! import everything that is public from the module
  implicit none
  call subd
  entier = 123        ! entier is public  in module demo
#if defined(ERROR_1)
  reel = 1.23         ! reel is private in module demo, this would be a syntax error
#endif
  call sube           ! will print entier with the value set here
  call print_reel
end program
