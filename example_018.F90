! example of module cross-dependency
! module1 needs sub2r from module2
! module2 needs sub1r from module1
!
! if in separate files, the compilation order would 2
! 1 : the 2 modules (any order)
! 2:  the 2 submodules (any order)
!
module module1  ! provides INTERFACE to sub1r and implementation of sub1
  implicit none
  interface
    recursive module subroutine sub1r(n) ! uses sub2r from module2
      implicit none
      integer, intent(IN) :: n
    end subroutine
  end interface
contains
  subroutine sub1(n)
    implicit none
    integer, intent(IN) :: n
    print *, 'entering sub1 : n =',n
    print *, 'exiting  sub1 : n =',n
  end subroutine
end module
!
module module2  ! provides INTERFACE to sub2r and implementation of sub2
  implicit none
  interface
    recursive module subroutine sub2r(n) ! uses sub1r from module1
      implicit none
      integer, intent(IN) :: n
    end subroutine
  end interface
contains
  subroutine sub2(n)
    implicit none
    integer, intent(IN) :: n
    print *, 'entering sub2 : n =',n
    print *, 'exiting  sub2 : n =',n
  end subroutine
end module
!
submodule(module1) submodule1
  implicit none
contains
    recursive module subroutine sub1r(n)  ! actual implementation of interface described in module1
      use module2, only : sub2r           ! may use module2
      implicit none
      integer, intent(IN) :: n
      print *, 'entering sub1r : n =',n
      if(n >  0) call sub2r(n-1)          ! call sub2r from module2
      if(n == 0) call sub1(n)             ! call sub1 from parent module
      print *, 'exiting  sub1r : n =',n
    end subroutine
end submodule
!
submodule(module2) submodule2
  implicit none
contains
    recursive module subroutine sub2r(n)  ! actual implementation of interface described in module2
      use module1, only : sub1r           ! may use module1
      implicit none
      integer, intent(IN) :: n
      print *, 'entering sub2r : n =',n
      if(n >  0) call sub1r(n-1)          ! call sub1r from module1
      if(n == 0) call sub2(n)             ! call sub1 from parent module
      print *, 'exiting  sub2r : n =',n
    end subroutine
end submodule
!
program demo
!  expected output :
!
!  entering sub1 : n =         -10
!  exiting  sub1 : n =         -10
!  ===============================================
!  entering sub2 : n =         -20
!  exiting  sub2 : n =         -20
!  ===============================================
!  entering sub1r : n =           3
!  entering sub2r : n =           2
!  entering sub1r : n =           1
!  entering sub2r : n =           0
!  entering sub2 : n =           0
!  exiting  sub2 : n =           0
!  exiting  sub2r : n =           0
!  exiting  sub1r : n =           1
!  exiting  sub2r : n =           2
!  exiting  sub1r : n =           3
!  ===============================================
!  entering sub2r : n =           2
!  entering sub1r : n =           1
!  entering sub2r : n =           0
!  entering sub2 : n =           0
!  exiting  sub2 : n =           0
!  exiting  sub2r : n =           0
!  exiting  sub1r : n =           1
!  exiting  sub2r : n =           2
  use module1, only : sub1r, sub1
  use module2, only : sub2r, sub2
  implicit none
  call sub1(-10)
  print *,'==============================================='
  call sub2(-20)
  print *,'==============================================='
  call sub1r(3)
  print *,'==============================================='
  call sub2r(2)
end program
