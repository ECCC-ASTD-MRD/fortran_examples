#:def ranksuffix(RANK)
$:'' if RANK == 0 else '(' + ':' + ',:' * (RANK - 1) + ')'
#:enddef ranksuffix
#!
#:set MALLOC   = 'ShmemHeap_alloc_block'
#:set METADATA = 'ShmemHeap_set_block_meta'
#:set TYPEDICT = {'I': 'integer(kind=', 'R': 'real(kind=', 'T': 'type('}
#:set types = [      'I',          'I',         'I',         'I',       'R' ]
#:set kindt = ['C_INT8_T', 'C_INT16_T', 'C_INT32_T', 'C_INT64_T', 'C_FLOAT',  ]
#:set kindn = [        5,            5,           5,           5,         5 ]
#:set types = types +     [        'R',         'T',         'T',         'T',         'T',         'T' ]
#:set kindt = kindt +     [ 'C_DOUBLE',     'C_PTR','PC_INT32_T','PC_INT64_T',  'PC_FLOAT', 'PC_DOUBLE' ]
#:set kindn = kindn +     [          5,           2,           1,           1,           1,           1 ]
#:assert len(types) == len(kindt)
#:assert len(types) == len(kindn)
#:set kinds_types = list(zip(kindn, kindt, types))
#!
module c_f_pointer_plus
  use ISO_C_BINDING
! number of module procedures = ${sum(kindn)}$
! types = ${kindt}$
! ranks = ${kindn}$
#:for L, KIND, RI in kinds_types[2:6]
#: set TYPE = TYPEDICT[RI] + KIND + ')'
#: set D = 1
#: set DIMENSION = ranksuffix(D)
  type :: P${KIND}$
    ${TYPE}$, dimension${DIMENSION}$, pointer :: p
  end type
#:endfor
#!
  interface c_f_pointer_
#:for L, KIND, RI in kinds_types
#: for D in range(1,L+1)
    module procedure cfptr_${KIND}$_${D}$D
#:endfor
#:endfor
  end interface
contains
#!
#:for L, KIND, RI in kinds_types
#:set BOUNDS = 'lo(1):hi(1)'
#!
#: for D in range(1,L+1)
#:set TYPE = TYPEDICT[RI] + KIND + ')'
#:set DIMENSION = ranksuffix(D)

subroutine cfptr_${KIND}$_${D}$D(cptr, array_ptr, sz, lo) ! ${TYPE}$(kind=${KIND}$) ${D}$D array allocator
  use ISO_C_BINDING
  implicit none
  type(C_PTR), intent(IN), value :: cptr
  ${TYPE}$, dimension${DIMENSION}$, intent(OUT), pointer :: array_ptr !< ${D}$ (dimensional pointer to ${TYPE}$ array
  integer(C_INT32_T), dimension(:), intent(IN) :: sz  !< dimension of sz must be the same as the rank of array_ptr
  integer(C_INT32_T), dimension(:), intent(IN) :: lo  !< dimension of lo must be the same as the rank of array_ptr
  ${TYPE}$, dimension(:), pointer :: tmp
  integer, dimension(${D}$) :: hi

!   if(size(sz) .ne. ${D}$ .or. size(lo) .ne. ${D}$) then
!     nullify(array_ptr)
!     return
!   endif
  hi(1:${D}$) = sz(1:${D}$) + lo(1:${D}$) -1
  if(C_ASSOCIATED(cptr))then
    call C_F_POINTER(cptr, tmp, [product(sz(1:${D}$))])      ! 1D pointer
    array_ptr(${BOUNDS}$) => tmp(1:product(sz(1:${D}$)))    ! reshape to ${D}$D pointer with lower and upper bound
  else                                                      ! NULL pointer
    allocate(array_ptr(${BOUNDS}$))
  endif
end subroutine
#:set BOUNDS = BOUNDS + ',lo(' + str(D+1) + '):hi(' + str(D+1) + ')'
#:endfor
#!
#:endfor
end module
!#:set LISTLEN = len(kinds_types)
! length of list is ${LISTLEN} $
program self_test
  use c_f_pointer_plus
  implicit none
  type(C_PTR) :: cptr
  type :: prank0
    integer, pointer :: p => NULL()
  end type
  type :: prank1
    integer, dimension(:), pointer :: p => NULL()
  end type
  type :: prank2
    integer, dimension(:,:), pointer :: p => NULL()
  end type
  type :: prank3
    integer, dimension(:,:,:), pointer :: p => NULL()
  end type
  type :: prank4
    integer, dimension(:,:,:,:), pointer :: p => NULL()
  end type
  type :: prank5
    integer, dimension(:,:,:,:,:), pointer :: p => NULL()
  end type
  type(prank0) :: pint0
  type(prank1) :: pint1
  type(prank2) :: pint2
  type(prank3) :: pint3
  type(prank4) :: pint4
  type(prank5) :: pint5
  type(PC_INT32_T), dimension(:), pointer :: parray
  integer, dimension(1024), target :: array1
  integer, dimension(:), pointer :: ia1
  integer, dimension(:,:), pointer :: ia2
  integer :: i, j

  cptr = C_LOC(array1)
  array1 = [(i, i=1,size(array1))]
  print *,'size of rank 0 pointer =', storage_size(pint0) / 8, ' bytes'
  print *,'size of rank 1 pointer =', storage_size(pint1) / 8, ' bytes'
  print *,'size of rank 2 pointer =', storage_size(pint2) / 8, ' bytes'
  print *,'size of rank 3 pointer =', storage_size(pint3) / 8, ' bytes'
  print *,'size of rank 4 pointer =', storage_size(pint4) / 8, ' bytes'
  print *,'size of rank 5 pointer =', storage_size(pint5) / 8, ' bytes'

  call c_f_pointer_(cptr, ia2, [5, 5], [-2, -2])
  print *,'size   of ia2 =', size(ia2,1), size(ia2,2)
  print *,'lbound of ia2 =', lbound(ia2,1), lbound(ia2,2)
  print *,'ubound of ia2 =', ubound(ia2,1), ubound(ia2,2)
  do j = ubound(ia2,2), lbound(ia2,2), -1
    print 1,j, ia2(:,j)
  enddo
  print 2,'J/I',(i,i=lbound(ia2,1),ubound(ia2,1))

  call c_f_pointer_(C_NULL_PTR, ia2, [7, 3], [-3, -1])
  print *,'size   of ia2 =', size(ia2,1), size(ia2,2)
  print *,'lbound of ia2 =', lbound(ia2,1), lbound(ia2,2)
  print *,'ubound of ia2 =', ubound(ia2,1), ubound(ia2,2)
  do j = ubound(ia2,2), lbound(ia2,2), -1
    print 1, j, ia2(:,j)
  enddo
  print 2,'J/I',(i,i=lbound(ia2,1),ubound(ia2,1))

  call c_f_pointer_(cptr, parray, [5], [-2])           ! allocate array of wrapped pointers from array1
  print *,'size   of parray =', size(parray,1)
  print *,'lbound of parray =', lbound(parray,1)
  print *,'ubound of parray =', ubound(parray,1)
  do i = ubound(parray,1), lbound(parray,1), -1
    cptr = C_LOC(array1(512+10*i))
    call c_f_pointer_(cptr, parray(i)%p, [5], [i-3])   ! point element i of parray to array1(512*10*i)
    print 1, i, parray(i)%p, lbound(parray(i)%p,1), ubound(parray(i)%p,1)
  enddo
  print 2,'I/I',(i,i=lbound(parray(0)%p,1), ubound(parray(0)%p,1))
1 format(I3,20I5)
2 format(A3,20I5)
end
