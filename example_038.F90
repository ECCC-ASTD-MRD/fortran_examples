! there are sums ... and there is SUM()
! -O2 used by default
! intel/25.1  (seems to have a better intrinsic in library for -O2 and to recognize sum in explicit code)
! sum/(ni*nj) =  0.50001  , z4/(ni*nj)  =  0.49999  , z8/(ni*nj)  =  0.50001  , z0/(ni*nj)  =  0.50001  (-O2)
! sum/(ni*nj) =  0.25000  , z4/(ni*nj)  =  0.25000  , z8/(ni*nj)  =  0.50001  , z0/(ni*nj)  =  0.50001  (-O0) (-O1)
! gnu/14
! sum/(ni*nj) =  0.25000  , z4/(ni*nj)  =  0.25000  , z8/(ni*nj)  =  0.50001  , z0/(ni*nj)  =  0.50001
! aoccc/5.0.0
! sum/(ni*nj) =  0.25000  , z4/(ni*nj)  =  0.25000  , z8/(ni*nj)  =  0.50000  , z0/(ni*nj)  =  0.50000
! Nvidia/PGI/25.5
! sum/(ni*nj) =  0.25000  , z4/(ni*nj)  =  0.25000  , z8/(ni*nj)  =  0.50000  , z0/(ni*nj)  =  0.50000
! llvm flang/20
! sum/(ni*nj) =  0.25000  , z4/(ni*nj)  =  0.25000  , z8/(ni*nj)  =  0.49995  , z0/(ni*nj)  =  0.49995
!
program example_038
  use ISO_C_BINDING
  implicit none
  integer, parameter :: NI = 8192, NJ = 8192
  interface getrss
    function getrss() result(amount) bind(C,name='get_rss')
      import C_INT64_T
      integer(C_INT64_T) :: amount
    end function
  end interface
  real, dimension(NI,NJ) :: z
  real(kind=4) :: z8, z4, z0, zs
  integer, allocatable :: seed(:)
  integer :: n
  real(kind=4), external :: sum4, sum0
  real(kind=8), external :: sum8
!   call random_init(.false.,.false.)
!   call random_seed(size = n)
!   allocate(seed(n))
!   call random_seed(get=seed)
!   write (*, *) n, seed
  call random_number(z)
  zs = sum(z)
  z8 = sum8(z,NI*NJ)
  z4 = sum4(z,NI*NJ)
  z0 = sum0(z,NI*NJ)
  print 1, 'example_038, rss =', getrss(),', sum/(ni*nj) = ', zs/(ni*nj),', z4/(ni*nj)  = ', z4/(ni*nj),&
           ', z8/(ni*nj)  = ', z8/(ni*nj),', z0/(ni*nj)  = ', z0/(ni*nj)
1 format (A,I12,4(2X,A,F8.5))
end program
! DUMB sum
real(kind=4) function sum4(f, n)
  integer, intent(IN) :: n
  real(kind=4), dimension(N), intent(IN) :: f
  integer :: i
  sum4 = 0.0
  do i=1,n
    sum4=sum4+f(i)
  enddo
  return
end
! DUMB sum but using double precision accumulator
real(kind=8) function sum8(f, n)
  integer, intent(IN) :: n
  real, dimension(N), intent(IN) :: f
  integer :: i
  sum8 = 0.0
  do i=1,n
    sum8=sum8+f(i)
  enddo
  return
end
! DIVIDE and CONQUER sum
real(kind=4) function sum0(f, n)
  integer, intent(IN) :: n
  real(kind=4), dimension(N), intent(INOUT) :: f
  integer :: i, nn
  nn = n/2
  do while(nn > 0)
    do i = 1, nn
      f(i) = f(i) + f(nn+i)
    enddo
    nn = nn / 2
  enddo
  sum0 = f(1)
  return
end
