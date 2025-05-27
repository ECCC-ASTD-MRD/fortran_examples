! allocation, deallocation, test for memory leaks
!
program example_039
  use ISO_C_BINDING
  implicit none
  integer, parameter :: NI = 8192, NJ = 8192
  interface
    function getrss() result(amount) bind(C,name='get_rss')
      import C_INT64_T
      integer(C_INT64_T) :: amount
    end function
    subroutine allocz(z, isize)
      real, dimension(:), intent(OUT), pointer :: z
      integer :: isize
    end subroutine
  end interface
  real, dimension(:), pointer :: z
  integer, parameter :: MAXRSS = 10
  integer(C_INT64_T), dimension(0:MAXRSS) :: rss
  integer :: i, isize
  integer, dimension(0:MAXRSS) :: isz

  rss(0) = getrss()
  isz(0) = 0
  isize = 2000000
  do i = 1, MAXRSS
    isz(i) = isize
    nullify(z)
    if(mod(i,2) == 0) then
      call allocz(z, isize)        ! allocate in callee
    else
      allocate(z(isize))           ! allocate in caller
    endif
    z = i+3
    print '(F12.0,2X,Z16.16)',SUM(z),LOC(z)
    rss(i) = getrss()
    deallocate(z)                  ! deallocate in caller
    if(i < 6) then
      isize = isize - 100000
    else
      isize = isize + 100000
    endif
  enddo
  print 1, 'RSS1  =', rss(0:MAXRSS)

  isize = 2000000
  do i = 1, MAXRSS
    isz(i) = isize
    block                          ! automatic allocation in block
      real, dimension(isize) :: zb
      zb = i+3
      print '(F12.0,2X,Z16.16)',SUM(zb),LOC(zb)
    end block
      rss(i) = getrss()
    if(i < 6) then
      isize = isize - 100000
    else
      isize = isize + 100000
    endif
  enddo
  print 1, 'RSS2  =', rss(0:MAXRSS)
  print 1, 'sizes =', isz(0:MAXRSS)

1 format(A,11I9)
end program

subroutine allocz(z, isize)
  real, dimension(:), intent(OUT), pointer :: z
  integer :: isize
  allocate(z(isize))
  return
end
