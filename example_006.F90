! example of write within write side effects
! make  FC=my_fortran_compiler example_006
! make  FC=ifort example_006
! make  FC=ifort example_006 DEF=-DMIX
!
! when activating -DMIX
! with some sompilers the output will get a bit scrambled
! with some sompilers the program will crash
! normal output :
! [head 'abcdef' tail]
!
! output samples with -DMIX (crash with some compilers)
!  IN string1
! [head 'abcdef' tail]
!
! [head  IN string1
! 'abcdef' tail]

module demo
  implicit none
contains
  function string1() result(str)       ! string allocated by assignation
    implicit none
    character(len=:), allocatable :: str

    str = 'abcdef'                     ! automatic string allocation when assigning value
#if defined(MIX)
    print *,'IN string1'
#endif
  end function
  function string2() result(str)       ! allocate string, set value with constant
    implicit none
    character(len=:), pointer :: str

    allocate(character(len=8) :: str)  ! allocate with a specific size
    str = '123456'                     ! set allocated string to value
#if defined(MIX)
    print *,'IN string2'
#endif
  end function
  function string3() result(str)       ! allocate string, user write statement to set value
    implicit none
    character(len=:), pointer :: str

    allocate(character(len=8) :: str)  ! allocate with a specific size
    write(str,*) 'a1b2c3'              ! in memory write
#if defined(MIX)
    print *,'IN string3'
#endif
  end function
end module

program test
  use demo
  implicit none
  print 1, '[head ', "'"//string1()//"'", ' tail]'
  print 1, '[head ', "'"//string2()//"'", ' tail]'
  print 1, '[head ', "'"//string3()//"'", ' tail]'
1 format(A,A,A)
end program
