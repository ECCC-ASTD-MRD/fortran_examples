! pointer manipulation
! dumping contents of Fortran pointers
! show that pointer size = base amount + fixed amount per dimansion
! exception : a pointer to a scalar seems to contain only its address
program self_test
  use ISO_C_BINDING
  implicit none
  type(C_PTR) :: cptr
  ! prank0 -> prank5 : wrapped pointers to be able to create arrays of Fortran pointers
  type :: prank0      ! rank 0 pointer (scalar)
    integer, pointer :: p => NULL()
  end type
  type :: prank1      ! rank 1 pointer (1 dimensional array)
    integer, dimension(:), pointer :: p => NULL()
  end type
  type :: prank2      ! rank 2 pointer (2 dimensional array)
    integer, dimension(:,:), pointer :: p => NULL()
  end type
  type :: prank3      ! rank 3 pointer (3 dimensional array)
    integer, dimension(:,:,:), pointer :: p => NULL()
  end type
  type :: prank4      ! rank 4 pointer (4 dimensional array)
    integer, dimension(:,:,:,:), pointer :: p => NULL()
  end type
  type(prank0) :: pint0      ! rank 0 pointer (scalar)
  type(prank1) :: pint1      ! rank 1 pointer (1 dimensional array)
  type(prank2) :: pint2      ! rank 2 pointer (2 dimensional array)
  type(prank3) :: pint3      ! rank 3 pointer (3 dimensional array)
  type(prank4) :: pint4      ! rank 4 pointer (4 dimensional array)
  integer, dimension(1024000), target :: array1
  integer(C_INTPTR_T), dimension(1024) :: array2
  integer :: i, j
  integer, dimension(:), pointer :: tmp

  cptr = C_LOC(array1)              ! address of array1 in memory (C pointer)
  array1 = [(i, i=1,size(array1))]  ! fill array1
  array2 = 0                        ! set array2 to 0

  print *,'size of rank 0 pointer =', storage_size(pint0) / 8, ' bytes'
  i = storage_size(pint0) / 64
  call c_f_pointer(cptr, pint0%p)         ! pointer to scalar
  array2(1:i) = TRANSFER(pint0, array2)   ! transfer pointer contents into array2
  print 1, array2(1:i)                    ! print it from array2
  print *,'size of rank 1 pointer =', storage_size(pint1) / 8, ' bytes'

  i = storage_size(pint1) / 64
  call c_f_pointer(cptr, tmp, [7])        ! pointer to array containing 7 elements
  pint1%p(2:8) => tmp(1:7)                ! pointer to 1 dimensional array with lower bound .ne. 1
  array2(1:i) = TRANSFER(pint1, array2)   ! transfer pointer contents into array2
  print 1, array2(1:i)                    ! print it from array2
  print *,'size of rank 2 pointer =', storage_size(pint2) / 8, ' bytes'

  i = storage_size(pint2) / 64
  call c_f_pointer(cptr, tmp, [7*8])      ! pointer to array containing 7*8 elements
  pint2%p(2:8,3:10) => tmp(1:7*8)         ! pointer to 2 dimensional array with lower bounds .ne. 1
  array2(1:i) = TRANSFER(pint2, array2)   ! transfer pointer contents into array2
  print 1, array2(1:i)                    ! print it from array2
  print *,'size of rank 3 pointer =', storage_size(pint3) / 8, ' bytes'

  i = storage_size(pint3) / 64
  call c_f_pointer(cptr, tmp, [7*8*9])    ! pointer to array containing 7*8*9 elements
  pint3%p(2:8,3:10,-1:7) => tmp(1:7*8*9)  ! pointer to 3 dimensional array with lower bounds .ne. 1
  array2(1:i) = TRANSFER(pint3, array2)   ! transfer pointer contents into array2
  print 1, array2(1:i)                    ! print it from array2

  print *,'size of rank 4 pointer =', storage_size(pint4) / 8, ' bytes'
1 format(32(Z16.16,2X))
end
