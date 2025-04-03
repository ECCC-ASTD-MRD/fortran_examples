! demonstration of C void * in Fortran
! expected output :
!  integer value :         123
!  integer value :         123
!  real value :   123.456001    
!  real value :   123.456001    

module module_037
  use ISO_C_BINDING
  implicit none
contains
  subroutine sub_037(what, is_integer)
    implicit none
    type(*), dimension(*), target, intent(INOUT) :: what
    logical, intent(IN), value :: is_integer
    type(C_PTR) :: cptr
    integer, dimension(:), pointer :: ip
    real,    dimension(:), pointer :: fp
    cptr = C_LOC(what)                 ! address of what (target is necessary)
    if(is_integer)then
      call c_f_pointer(cptr, ip, [1])  ! associate to integer arrray
      print *, 'integer value :',ip(1)
    else
      call c_f_pointer(cptr, fp, [1])  ! associate to real arrray
      print *, 'real value :',fp(1)
    endif
  end
end
program example_037
  use module_037
  implicit none
  integer, dimension(1) :: is
  real, dimension(1)    :: fs
  integer, dimension(12, 23) :: ia
  real, dimension(12, 23, 34)    :: fa
  is = 123
  ia = is(1)
  fs = 123.456
  fa = fs(1)
  call sub_037(is, .true.)
  call sub_037(ia, .true.)
  call sub_037(fs, .false.)
  call sub_037(fa, .false.)
end
