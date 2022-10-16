!
! if a variable is initialized through its type, it is NOT MADE STATIC
! if a variable is initialized directly, it becomes STATIC (save attribute is implicit)
!
! make  FC=my_fortran_compiler example_003
! make  FC=ifort example_003
module demo
  implicit none
  type :: patentagoss                    ! type supplies an initial value
    integer :: contenu = 123456
  end type
end module

subroutine test1  ! initialization of variable t through its type initialization
  use demo
  implicit none
  integer           :: contenu = 123456  ! variable is initialized and STATIC
  type(patentagoss) :: t                 ! variable is initialized and AUTOMATIC
  print *,'avant :', contenu, t%contenu
  contenu = contenu + 1                  ! new value will be remembered for next call
  t%contenu = t%contenu + 1              ! new value will be remembered for next call
  print *,'apres :', contenu, t%contenu
end subroutine

subroutine test2  ! initialization of variable t through an explicitely assigned value
  use demo
  implicit none
  integer           :: contenu = 234567         ! variable is initialized and STATIC
  type(patentagoss) :: t = patentagoss(234567)  ! variable is initialized and STATIC
  print *,'avant :', contenu, t%contenu
  contenu = contenu + 1                         ! new value will be remembered for next call
  t%contenu = t%contenu + 1                     ! new value will NOT be remembered for next call
  print *,'apres :', contenu, t%contenu
end subroutine

program self_test
  implicit none
  print *,'-------------------------------------'
  print *,'test1       contenu   t%contenu'
  print *,'-------------------------------------'
  call test1
  print *,'-------------------------------------'
  call test1
  print *,'-------------------------------------'
  print *,'test2       contenu   t%contenu'
  print *,'-------------------------------------'
  call test2
  print *,'-------------------------------------'
  call test2
  print *,'-------------------------------------'
end
