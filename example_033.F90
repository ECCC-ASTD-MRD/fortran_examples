module test_rank_mod
  use ISO_C_BINDING
  implicit none
  interface
    function rank_2018(this) result(r) BIND(C, name='rank_2018')
      type(*), intent(IN), dimension(..) :: this
      integer :: r
    end function
    function elem_len_2018(this) result(r) BIND(C, name='elem_len_2018')
      type(*), intent(IN), dimension(..) :: this
      integer :: r
    end function
    function elem_type_2018(this) result(r) BIND(C, name='elem_type_2018')
      type(*), intent(IN), dimension(..) :: this
      integer :: r
    end function
  end interface
contains
  subroutine find_rank(this, expected)
    integer, intent(IN) :: expected
    integer :: lrank, lrankc
    type(*), intent(IN), dimension(..) :: this
#if defined(__PGI)
!   bad behavior with type(*)
    if(expected == 0) then
      print *, 'WARNING, skipping Fortran rank length test for rank 0'
      return
    endif
#endif
    lrankc = rank_2018(this)
    lrank  = rank(this)
    if(lrankc .ne. expected .or. lrank .ne. expected) then
      print '(A,2I12,A,I2)', 'ERROR:   rank (C,Fortran) = ',lrankc, lrank, ' , expected ',expected
    else
      print '(A,2I12,A,I2)', 'SUCCESS: rank  (C,Fortran) = ',lrankc, lrank, ' , expected ',expected
    endif
  end
end module
program test_rank
  use test_rank_mod
  implicit none
  integer :: a0, lrank, lrankc, llenc, ltypec
  integer(C_INT32_T), dimension(1)   :: a1
  integer(C_INT64_T), dimension(1,2) :: a2
  real(C_FLOAT), dimension(1,2,3)    :: a3
  real(C_DOUBLE), dimension(1,2,3)   :: a4

  print *,'================= C/Fortran 2018 interface test ================='

  lrank  = rank(a0)
  lrankc = rank_2018(a0)
  llenc  = elem_len_2018(a0)
  ltypec = elem_type_2018(a0)
  write(0,1) 'int32 : rank', lrank, lrankc, ', C element length/type', llenc, ltypec
  if(llenc .ne. 4) write(0,*) 'ERROR, expected length to be 4'
  call find_rank(a0, 0)
  print *,'================================================================='

  lrank  = rank(a1)
  lrankc = rank_2018(a1)
  llenc  = elem_len_2018(a1)
  ltypec = elem_type_2018(a1)
  write(0,1) 'int32 : rank', lrank, lrankc, ', C element length/type', llenc, ltypec
  if(llenc .ne. 4) write(0,*) 'ERROR, expected length to be 4'
  call find_rank(a1, 1)
  print *,'================================================================='

  lrank  = rank(a2)
  lrankc = rank_2018(a2)
  llenc  = elem_len_2018(a2)
  ltypec = elem_type_2018(a2)
  write(0,1) 'int64 : rank', lrank, lrankc, ', C element length/type', llenc, ltypec
  if(llenc .ne. 8) write(0,*) 'ERROR, expected length to be 8'
  call find_rank(a2, 2)
  print *,'================================================================='

  lrank  = rank(a3)
  lrankc = rank_2018(a3)
  llenc  = elem_len_2018(a3)
  ltypec = elem_type_2018(a3)
  write(0,1) 'float : rank', lrank, lrankc, ', C element length/type', llenc, ltypec
  if(llenc .ne. 4) write(0,*) 'ERROR, expected length to be 4'
  call find_rank(a3, 3)
  print *,'================================================================='

  lrank  = rank(a4)
  lrankc = rank_2018(a4)
  llenc  = elem_len_2018(a4)
  ltypec = elem_type_2018(a4)
  write(0,1) 'double: rank', lrank, lrankc, ', C element length/type', llenc, ltypec
  if(llenc .ne. 8) write(0,*) 'ERROR, expected length to be 8'
  call find_rank(a4, 3)
  print *,'================================================================='
1 format(A,2I4,A,2I4)
end
