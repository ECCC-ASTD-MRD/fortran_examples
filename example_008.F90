! ignore type/kind/rank
subroutine demo
  implicit none
  interface
    subroutine test(argument)
      implicit none
      logical :: argument
!GCC$ ATTRIBUTES NO_ARG_CHECK :: argument
!DEC$ ATTRIBUTES NO_ARG_CHECK :: argument
!$PRAGMA IGNORE_TKR argument
!DIR$ IGNORE_TKR argument
!IBM* IGNORE_TKR argument
    end subroutine
  end interface
  integer, dimension(1,2,3) :: i123
  real, dimension(4,5)      :: r45
  call test(i123)
  call test(r45)
  call test(123)
  call test(4.5)
end subroutine
