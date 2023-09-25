
! Demonstration of a compilation issue with gfortran
! gfortran reports a name conflict between procedures in a specific case:
!  1. The two procedures have the same name, but are part of 2 different modules (modules A and B)
!  2. The two procedures are accessible through a derived type (as a type-bound procedure) (types A and B)
!       - The binding name of each type-bound procedure does not matter
!  3. One of the procedures must be a subroutine, the other a function
!  4. The procedures must be called on these 2 types (A and B) while they are members of a third derived type (type USER)
!
! to demonstrate the problem, compile with -DWITH_PROBLEM
!
module type_a_module
  implicit none
  type, public :: type_a
    integer :: a
    contains
    procedure, PASS :: setval
  end type
contains

  function setval(this, val) result(old)
    implicit none
    class(type_a), intent(inout) :: this
    integer, intent(in) :: val
    integer :: old
    old = this % a
    this % a = val
  end function
end module

module type_b_module
  implicit none
  type, public :: type_b
    integer :: a
    contains
#if defined(WITH_PROBLEM)
    procedure, PASS :: setval           ! same binding name as in type_a
#else
    procedure, PASS :: setval=>setval2  ! different binding name
#endif
  end type
contains
#if defined(WITH_PROBLEM)
  subroutine setval(this, val)   ! same name as in type_a
#else
  subroutine setval2(this, val)  ! different name
#endif
    implicit none
    class(type_b), intent(inout) :: this
    integer, intent(in) :: val
    this % a = val
  end subroutine
end module

module type_user
  use type_a_module
  use type_b_module
  implicit none

  type, public :: user_t
    type(type_a) :: ta
    type(type_b) :: tb
  contains
    procedure, pass :: use_type
  end type
contains
  subroutine use_type(this) 
    implicit none
    class(user_t), intent(inout) :: this
    integer :: old_a
    call this % tb % setval(-3)
    old_a = this % ta % setval(-2)
    print *, 'Expecting -2, -3: ', this % ta % a, this % tb % a
  end subroutine
end module type_user

program main
  use type_user
  implicit none

  type(type_a) :: ta
  type(type_b) :: tb
  type(user_t) :: user
  integer :: old_a
  old_a = ta % setval(-2)   ! direct use of type_a
  call tb % setval(-3)      ! direct use of type_b
  call user % use_type()    ! use through user_t
end program main
