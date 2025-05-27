! there are sums ... and there is SUM()
! -O2 used by default
! intel/25.1  (seems to have a better intrinsic in library for -O2 and to recognize sum in explicit code)
!  (deviation from .5)   , sum = .352E-05  , z4  = .894E-07  , z8  = .596E-07  , z0  = .596E-07 (-O2)
!  (deviation from .5)   , sum = .250E+00  , z4  = .250E+00  , z8  = .596E-07  , z0  = .596E-07 (-O0) (-O1)
! gnu/14
!  (deviation from .5)   , sum = .250E+00  , z4  = .250E+00  , z8  = .596E-07  , z0  = .596E-07
! aoccc/5.0.0
!  (deviation from .5)   , sum = .250E+00  , z4  = .250E+00  , z8  = .596E-07  , z0  = .596E-07
! Nvidia/PGI/25.5
!  (deviation from .5)   , sum = .119E-06  , z4  = .119E-06  , z8  = .596E-07  , z0  = .596E-07
! llvm flang/20
!  (deviation from .5)   , sum = .596E-07  , z4  = .250E+00  , z8  = .596E-07  , z0  = .596E-07
!
program example_038
  use ISO_C_BINDING
  implicit none
  integer, parameter :: NI = 8192, NJ = 8192
  interface
    function getrss() result(amount) bind(C,name='get_rss')
      import C_INT64_T
      integer(C_INT64_T) :: amount
    end function
    function my_rand_f() result(r) bind(C,name='my_rand_f')
      import C_FLOAT
      real(C_FLOAT) :: r
    end function
  end interface
  real, dimension(NI,NJ) :: z
  real(kind=4) :: z8, z4, z0, zs
  integer, allocatable :: seed(:)
  integer :: n, i, j
  real(kind=4), external :: sum4, sum0
  real(kind=8), external :: sum8
  integer, dimension(0:10) :: dist

  dist = 0
  do j=1,nj
  do i=1,ni
    z(i,j) = my_rand_f()
    n = 10*z(i,j)
    dist(n) = dist(n)+1
  enddo
  enddo
  if(sum(dist(0:9)) .ne. ni*nj) stop
  print '(A,11I8)', 'dist =',dist
  zs = ABS(sum(z)/(ni*nj)-.5)
  z8 = ABS(sum8(z,NI*NJ)/(ni*nj)-.5)
  z4 = ABS(sum4(z,NI*NJ)/(ni*nj)-.5)
  z0 = ABS(sum0(z,NI*NJ)/(ni*nj)-.5)
  print 1, 'example_038 (deviation from .5) ',&
           ', sum = ', zs,', z4  = ', z4,&
           ', z8  = ', z8,', z0  = ', z0
1 format (A,4(2X,A,E8.3))
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
