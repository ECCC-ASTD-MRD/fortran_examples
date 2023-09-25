
! Demonstration of a compilation issue with gfortran
! gfortran reports a name conflict between procedures in a specific case:
!  1. The two procedures have the same name, but are part of 2 different modules (modules A and B)
!  2. The two procedures are private
!  3. The two procedures are accessible through a derived type (as a type-bound procedure) (types A and B)
!       - The binding name of each type-bound procedure does not matter
!  4. One of the procedures must be a subroutine, the other a function
!  5. The procedures must be called on these 2 types (A and B) while they are members of a third derived type (type USER)
!  6. The type-bound procedure from USER must be compiled in a submodule

module type_a_module
  implicit none
  private
  type, public :: type_a
    integer :: a
    contains
    procedure, PASS :: setvalue => setval2
  end type
contains
!   subroutine setval(this, val)
!     implicit none
!     class(type_a), intent(inout) :: this
!     integer, intent(in) :: val
!     this % a = val
!   end subroutine

  function setval2(this, val) result(old)
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
  private
  type, public :: type_b
    integer :: a
    contains
    procedure, PASS :: setval => setval2
  end type
contains
  subroutine setval2(this, val)
    implicit none
    class(type_b), intent(inout) :: this
    integer, intent(in) :: val
    this % a = val
  end subroutine

!   function setval(this, val) result(old)
!     implicit none
!     class(type_b), intent(inout) :: this
!     integer, intent(in) :: val
!     integer :: old
!     old = this % a
!     this % a = val
!   end function
end module

module type_user
  use type_a_module
  use type_b_module
  implicit none
  private

  type, public :: user_t
    type(type_a) :: ta
    type(type_b) :: tb
  contains
    procedure, pass :: use_type
  end type

  interface
  module subroutine use_type(this) 
    implicit none
    class(user_t), intent(inout) :: this
  end subroutine
  end interface
end module type_user

submodule (type_user) sub_use_type
  use type_a_module
  use type_b_module
  implicit none

contains

  module procedure use_type
    implicit none
    integer :: old_a, old_b
    ! call this % ta % setval(-2)
    call this % tb % setval(-3)
    old_a = this % ta % setvalue(-2)
    ! old_b = this % tb % setval(-3)
    print *, 'Expecting -2, -3: ', this % ta % a, this % tb % a
  end procedure

end submodule

program main
  use type_user
  implicit none

  type(user_t) :: user
  call user % use_type()
end program main
