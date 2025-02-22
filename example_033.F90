module test_rank_mod
  implicit none
  interface
    function rank_2018(this) result(r) BIND(C, name='rank_2018')
      type(*), intent(IN), dimension(..) :: this
      integer :: r
    end function
  end interface
contains
  subroutine find_rank(this, expected)
#if ! defined(__PGI)
    type(*), intent(IN), dimension(..) :: this  ! wrong element length from rank_2018 with type(*)
#else
    integer, intent(IN), dimension(..) :: this
#endif
    integer :: expected
    integer :: lrank, lrankc
    lrankc = rank_2018(this)
    lrank  = rank(this)
    if(lrankc .ne. expected .or. lrank .ne. expected) then
      print '(A,2I6,A,I2)', 'ERROR: rank (C,Fortran) = ',lrankc, lrank, ' , expected ',expected
    else
      print '(A,2I6,A,I2)', 'SUCCESS:  (C,Fortran) = ',lrankc, lrank, ' , expected ',expected
    endif
  end
end module
program test_rank
  use test_rank_mod
  implicit none
  integer :: a0, lrank, lrankc
  integer, dimension(1) :: a1
  integer, dimension(1,2) :: a2

  lrank = rank(a0)
  lrankc = rank_2018(a0)
  write(0,*) 'rank', lrank, lrankc
#if ! defined(__PGI)
  call find_rank(a0, 0)
#endif

  lrank = rank(a1)
  lrankc = rank_2018(a1)
  write(0,*) 'rank', lrank, lrankc
  call find_rank(a1, 1)

  lrank = rank(a2)
  lrankc = rank_2018(a2)
  write(0,*) 'rank', lrank, lrankc
  call find_rank(a2, 2)
end
