! example of pointer manipulations (LOC/C_LOC/TRANSFER)
program demo
  use ISO_C_BINDING
  implicit none
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
  integer, parameter :: low=-3
  integer, parameter :: high=2
  integer, dimension(low:high), target :: array
  integer(C_INTPTR_T) :: address
  type(C_PTR) :: ptr, ptrc
  integer :: i
  do i=low, high
    array(i) = i
  enddo
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
  call c_passthru(ptr , low, high)  ! get C routine to call Fortran routine
  call c_passthru(ptrc, low, high)  ! get C routine to call Fortran routine
end program

subroutine f_passthru(ptr, low, high) BIND(C,name='F_passthru')
  use ISO_C_BINDING
  implicit none
  type(C_PTR), intent(IN), value :: ptr
  integer(C_INT32_T), intent(IN), value :: low, high
  integer, dimension(:), pointer :: array1, array2
  integer(C_INTPTR_T) :: address
  call c_f_pointer(ptr, array1, [high-low+1])
  array2(low:high) => array1(1:high-low+1)
  print 2,'low, high =',lbound(array2), ubound(array2)
  print 2,'array     =',array2
  address = TRANSFER(ptr, address)
  print 1, 'address   = ', address
#if defined(ERROR_1)
! print refuses to print a type(C_PTR) variable (most compilers)
  print 1, 'address   = ', ptr
#endif
1 format(A,Z16.16)
2 format(A,100I5)
end
