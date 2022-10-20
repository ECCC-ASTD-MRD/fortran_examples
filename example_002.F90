! example of code using definitions and procedures from a module
! and of some of the associated pitfalls
!  - import statement possibly needed in an interface block
!  - only argument/result type declarations allowed in an interface block
! make FC=my_fortran_compiler example_002
! make FC=my_fortran_compiler example_002 DEF=-DOPTION_1
! make FC=my_fortran_compiler example_002 DEF=-DERROR_1
! make FC=my_fortran_compiler example_002 DEF=-DERROR_2
! my_fortran_compiler : gfortran/ifort/flang/nvfortran
module something
    type :: awesome            ! define a user type
        integer :: truth
    end type

    interface                  ! interface to a function not contained in the module
        ! interface using a type defined in the module
        function thruth_squared(local_awesome) result(square)
!           if a user defined type is needed in an interface definition,
!           it MUST be imported from the containing scope
#if ! defined(ERROR_1)
            import :: awesome  ! make type awesome available inside the interface definition
#endif
            implicit none
            type(awesome), intent(in) :: local_awesome
            integer :: square
! an interface definition MAY NOT contain anything other than argument and result type declarations
#if defined(ERROR_2)
            square = local_awesome%truth * local_awesome%truth    ! ILLEGAL inside an interface definition
#endif
        end function
    end interface

contains
    ! no explicit interface definition needed for a subroutine/function contained in the module
    ! this subroutine/function contained in the module needs a type defined in the module
    subroutine speak_thruth(local_awesome)
        implicit none
        type(awesome), intent(in) :: local_awesome  ! available because in same module as definition

        print *, 'truth is ', local_awesome%truth
    end subroutine
end module

function thruth_squared(local_awesome) result(square)
#if defined(ERROR_3)
  use something                   ! duplicate interface declaration for thruth_squared
                                  ! generates a syntax error with some compilers (gnu / llvm)
#else
#if ! defined(OPTION_1)
  use something, only : awesome   ! do not import thruth_squared interface from module
#else
  use something, some_other_name => thruth_squared ! or import it under another name
#endif
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
#if defined(OPTION_1)
  print *,'with : use something, some_other_name => thruth_squared'
#else
  print *,'with : use something, only : awesome'
#endif
  this%truth = 123456
  call speak_thruth(this)
  call test_thruth_squared
end
