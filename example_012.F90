! module contains a generic and multiple specific function interfaces
!
! when compiled with -DERROR, specific function interfaces fna_2 and fna_3 are not provided
!
! therefore using fna_g(t2,10) or fna_g(t3,10)will generate the following (or similar) error
! "There is no specific function for the generic 'fna_g'"
! as the compiler is looking for a function accepting a 2 or 3 dimensional array
!
! N.B. some compilers will tolerate this situation and successfully compile and execute
module demo
  implicit none

  interface fna_g                                         ! generic name
    function fna_s(src, n) result(r) bind(C, name='FNA')  ! specific name (scalar)
      implicit none
      integer, intent(IN) :: src
      integer, intent(IN), value :: n
      integer :: r
    end function
    function fna_1(src, n) result(r) bind(C, name='FNA')  ! specific name (1D array)
      implicit none
      integer, dimension(*), intent(IN) :: src
      integer, intent(IN), value :: n
      integer :: r
    end function
#if ! defined(ERROR)
    function fna_2(src, n) result(r) bind(C, name='FNA')  ! specific name (2D array)
      implicit none
      integer, dimension(1,*), intent(IN) :: src
      integer, intent(IN), value :: n
      integer :: r
    end function
    function fna_3(src, n) result(r) bind(C, name='FNA')  ! specific name  (3D array)
      implicit none
      integer, dimension(1,1,*), intent(IN) :: src
      integer, intent(IN), value :: n
      integer :: r
    end function
#endif
  end interface
end module

! this function treats everything as a 1 dimensional array
function fna(src, n) result(r) bind(C, name='FNA')
  implicit none
  integer, dimension(*), intent(IN) :: src
  integer, intent(IN), value :: n
  integer :: r
  r = src(n)
end function

program test
  use demo
  implicit none
  integer, dimension(10)   :: t1
  integer, dimension(10,1) :: t2
  integer, dimension(10,1,1) :: t3
  integer :: r, i

  t1 = [(i, i=1,size(t1))]
  t2(:,1) = t1
  t3(:,1,1) = t1
  print *,'fna_g(t1   , 10) =',fna_g(t1, 10)
  print *,'fna_g(t1(1), 10) =',fna_g(t1(1),10)
  print *,'fna_g(t1(6),  5) =',fna_g(t1(6),5)
  print *,'fna_1(t2   , 10) =',fna_1(t2, 10)    ! O.K. if using specific name fna_1
#if ! defined(ERROR)
  print *,'fna_3(t2   , 10) =',fna_3(t2, 10)    ! O.K. if using specific name fna_3
#endif
  print *,'fna_g(t2   , 10) =',fna_g(t2, 10)    ! ERROR if using generic name
  print *,'fna_1(t3   , 10) =',fna_1(t3, 10)    ! O.K. if using specific name fna_1
#if ! defined(ERROR)
  print *,'fna_2(t3   , 10) =',fna_2(t3, 10)    ! O.K. if using specific name fna_2
#endif
  print *,'fna_g(t3   , 10) =',fna_g(t3, 10)    ! ERROR if using generic name
end program
