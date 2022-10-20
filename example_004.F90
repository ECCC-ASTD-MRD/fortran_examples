! examples of pointer manipulations (LOC/C_LOC/TRANSFER) (including non unit stride)
! example of array constructor with implied do loop
program demo
  use ISO_C_BINDING
  implicit none
  ! interfaces to the C and Fortran functions
  interface
    subroutine c_passthru(ptr, low, high) BIND(C,name='C_passthru')
      import :: C_PTR, C_INT32_T
      implicit none
      type(C_PTR), intent(IN), value :: ptr
      integer(C_INT32_T), intent(IN), value :: low, high
    end
    subroutine f_passthru(ptr, low, high) BIND(C,name='F_passthru')
      import :: C_PTR, C_INT32_T
      implicit none
      type(C_PTR), intent(IN), value :: ptr
      integer(C_INT32_T), intent(IN), value :: low, high
    end
  end interface
  integer, parameter :: low=-3     ! lower index bound for array
  integer, parameter :: high=5     ! upper index bound for array
  integer, dimension(low:high), target :: array
  integer(C_INTPTR_T) :: address   ! integer large enough to contain an address
  type(C_PTR) :: ptr, ptrc         ! a honest C pointer
  integer :: i

  array = [ (i-1, i=low,high) ]    ! array constructor with implied do loop

  address = LOC(array)             ! get address using the LOC() extension
  ptr = TRANSFER(address, ptr)     ! use the TRANSFER intrinsic to move result of LOC() into a C pointer
  ptrc = C_LOC(array(low))         ! get address through C_LOC intrinsic
  if(C_ASSOCIATED(ptr,ptrc)) then  ! check that answer is the same for both methods
    print *,'addresses match'
  else
    print *,'ERROR: addresses do not match'
  endif
  ! WARNING
  ! call f_passthru(transfer(address, ptr), low, high)
  ! call f_passthru(C_LOC(array(low)), low, high)
  ! is NOT A GOOD IDEA
  ! some compilers silently generate bad code (if you are unlucky)  or crash (if you are lucky)
  ! when the TRANSFER function or the C_LOC function are used directly as a procedure argument
  ! therefore putting the result into a variable and passing the variable is the SAFE way
  print *,'direct call'
  call f_passthru(ptr , low, high)  ! call Fortran routine directly
  call f_passthru(ptrc, low, high)  ! call Fortran routine directly
  print *,'indirect call via C function'
  call c_passthru(ptr , low, high)  ! make the C routine call the Fortran routine
  call c_passthru(ptrc, low, high)  ! make the C routine call the Fortran routine
end program

! called directly by the main program or through a call to c_passthru
subroutine f_passthru(ptr, low, high) BIND(C,name='F_passthru')
  use ISO_C_BINDING
  implicit none
  type(C_PTR), intent(IN), value :: ptr                    ! base address of data array
  integer(C_INT32_T), intent(IN), value :: low, high       ! lower and upper bounds for data array
  integer, dimension(:), pointer :: array1, array2, array3 ! integer, rank 1 arrays
  integer(C_INTPTR_T) :: address                           ! integer large enough to contain an address

  ! array1 will have a lower index bound of 1
  call c_f_pointer(ptr, array1, [high-low+1])      ! make Fortran pointer from C pointer
  ! array 2 has a lower index bound not equal to 1
  array2(low:high) => array1(1:high-low+1)         ! every element of array1 is used
  print 2,'array2    =',array2
  print 2,'low, high =',lbound(array2), ubound(array2)
  address = TRANSFER(ptr, address)
  print 1, 'address   = ', address
#if defined(ERROR_1)
! print refuses to print a type(C_PTR) variable (most compilers)
  print 1, 'address   = ', ptr
#endif
  ! array 3 points to every other element of array1 (stride 2)
  ! the lower bound of array3 will be 0
  array3(0:) => array1(1:high-low+1:2)
  print 2,'low, high =',lbound(array3), ubound(array3)
  print 3,'array3    =',array3
  print *,'------------------------------------------'
1 format(A,Z16.16)
2 format(A,100I5)
3 format(A,I5,50I10)
end
