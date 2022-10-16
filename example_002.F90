! example of code using definitions and procedures from a module
! and of some of the associated pitfalls
!  - import statement possibly needed in an interface block
!  - only argument/result type declarations allowed in an interface block
module something
    type :: awesome
        integer :: truth
    end type

    interface
        ! interface using a type defined in the module
        function thruth_squared(local_awesome) result(square)
! if a non intrinsic type is used in an interface section,
! it must be imported from the containing scope
#if ! defined(ERROR_1)
            import :: awesome
#endif
            implicit none
            type(awesome), intent(in) :: local_awesome
            integer :: square
! an interface section MAY NOT contain anything other than argument and result type declarations
#if defined(ERROR_2)
            square = local_awesome%truth * local_awesome%truth
#endif
        end function
    end interface

contains
    ! A subroutine/function in the contains using a type defined in the module works
    subroutine speak_thruth(local_awesome)
        implicit none

        type(awesome), intent(in) :: local_awesome

        print *, 'truth is ', local_awesome%truth
    end subroutine
end module

function thruth_squared(local_awesome) result(square)
#if defined(ERROR_3)
  use something                   ! duplicate interface declaration for thruth_squared
                                  ! generates a syntax error with some compilers (gnu / llvm)
#else
  use something, only : awesome   ! do not import thruth_squared interface from module
#endif
  implicit none
  type(awesome), intent(in) :: local_awesome
  integer :: square
  square =  local_awesome%truth * local_awesome%truth
end

subroutine test_thruth_squared
  use something
  implicit none
  type(awesome) :: this
  integer :: square
  this%truth = 12
  square =  thruth_squared(this)
  print *,'square =', square
end

program self_test
  use something
  implicit none
  type(awesome) :: this
  this%truth = 123456
  call speak_thruth(this)
  call test_thruth_squared
end
