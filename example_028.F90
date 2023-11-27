! implementing a Fortran 2023 feature with a macro using the BLOCK ... END BLOCK construct
! with the Fortran 2023 features, the macro definitions would become
! #define C_F_POINTER1(CPTR, FPTR, UPDIM, LODIM) call c_f_pointer(CPTR, FPTR, UPDIM, LODIM)
! #define C_F_POINTER2(CPTR, FPTR, UPDIM, LODIM) call c_f_pointer(CPTR, FPTR, UPDIM, LODIM)
! #define C_F_POINTER3(CPTR, FPTR, UPDIM, LODIM) call c_f_pointer(CPTR, FPTR, UPDIM, LODIM)
!
! the BLOCK ... END BLOCK construct hides local variables i and t
#define C_F_POINTER1(CPTR, FPTR, UPDIM, LODIM) \
  block ; \
    integer, dimension(2,1) :: i ; \
    integer, dimension(:), pointer :: t ; \
    i(1,:) = LODIM ; \
    i(2,:) = UPDIM ; \
    call c_f_pointer(CPTR, t, [1]) ; \
    FPTR(i(1,1):i(2,1)) => t ; \
  end block
#define C_F_POINTER2(CPTR, FPTR, UPDIM, LODIM) \
  block ; \
    integer, dimension(2,2) :: i ; \
    integer, dimension(:), pointer :: t ; \
    i(1,:) = LODIM ; \
    i(2,:) = UPDIM ; \
    call c_f_pointer(CPTR, t, [1]) ; \
    FPTR(i(1,1):i(2,1), i(1,2):i(2,2)) => t ; \
  end block
#define C_F_POINTER3(CPTR, FPTR, UPDIM, LODIM) \
  block ; \
    integer, dimension(2,3) :: i ; \
    integer, dimension(:), pointer :: t ; \
    i(1,:) = LODIM ; \
    i(2,:) = UPDIM ; \
    call c_f_pointer(CPTR, t, [1]) ; \
    FPTR(i(1,1):i(2,1), i(1,2):i(2,2), i(1,3):i(2,3)) => t ; \
  end block

program example_028
  use ISO_C_BINDING
  implicit none
  integer, dimension(:,:), pointer :: a2
!   integer, dimension(:,:), pointer :: b2
  integer, dimension(:    ), pointer :: c1
  integer, dimension(:,:  ), pointer :: c2
  integer, dimension(:,:,:), pointer :: c3
  integer, dimension(128), target :: c
  integer :: i, t       ! same name as used in BLOCK ... END BLOCK construct

  type(C_PTR) :: p
  p = C_LOC(c(1))
  call c_f_pointer(p, a2, [5, 6])
  print *,'lbound(a2) =', lbound(a2)
  print *,'ubound(a2) =', ubound(a2)

  C_F_POINTER1(p, c1, ([2]), ([-2]) )
  print *,'lbound(c1) =', lbound(c1)
  print *,'ubound(c1) =', ubound(c1)

  C_F_POINTER2(p, c2, ([2, 3]), ([-2, -3]) )
  print *,'lbound(c2) =', lbound(c2)
  print *,'ubound(c2) =', ubound(c2)

  C_F_POINTER3(p, c3, ([2, 3, 4]), ([-2, -3, -4]) )
  print *,'lbound(c3) =', lbound(c3)
  print *,'ubound(c3) =', ubound(c3)
end program
