! example of allocatable strings and string pointers
! this example shows that allocatable and pointer induce a different behaviour
!
! make  FC=my_fortran_compiler example_005
! make  FC=ifort example_005
module machin
contains

! this function returns a dynamically allocated string of length lng
! the string is not initialized
! the allocated memory will disappear when the caller retuns
function make_string(lng) result(str)
  implicit none
  integer, intent(IN) :: lng
  character(len=:), allocatable :: str

  allocate(character(len=lng) :: str)    ! allocate string with required length
  print 1, 'make_string: address 1 of str =',LOC(str)
  str(1:lng) = ' '                       ! initialize string without reallocating it
  print 1, 'make_string: address 2 of str =',LOC(str)
1 format(A,1X,Z16.16)
end function

! similar to make_string
! but str = ' ' reallocates the string and will return a string of length 1
function oops_make_string(lng) result(str)
  implicit none
  integer, intent(IN) :: lng
  character(len=:), allocatable :: str   ! allocatable string, not a string pointer
  character(len=:), allocatable :: str2

  str2 = 'abcd'
  allocate(character(len=lng) :: str)    ! allocate string
  print 1, 'oops_make_string: address 1 of str =',LOC(str)
  str = '                              ' ! this will reallocate the string with a different length
  print 1, 'oops_make_string: address 2 of str =',LOC(str)
1 format(A,1X,Z16.16)
end function

! this function returns a string pointer, permanently allocated
function allocate_string(lng) result(str)
  implicit none
  integer, intent(IN) :: lng
  character(len=:), pointer :: str       ! string pointer
  allocate(character(len=lng) :: str)    ! allocate string
  str = ' '                              ! initialize string, do not reallocate
  print 1, 'allocate_string: address of str =',LOC(str)
1 format(A,1X,Z16.16)
end function

function get_demo_string() result(str)
  implicit none
  character(len=:), allocatable :: str
  str = 'this is a demo'
end function

end module

program demo
  use machin
  implicit none
  character(len=:), allocatable :: str1, str2, str4
  character(len=:), pointer :: str3

  str1 = '1234567890'
  print *,'length of str1 =',len(str1)

  str2 = make_string(13)
  print 1, "str2 = '"//str2//"'"
  print 1, 'address of str2 =',LOC(str2)
  print *,'length of str2 =',len(str2)

  str4 = oops_make_string(11)
  print 1, 'address of str4 =',LOC(str4)
  print *,'length of str4 =',len(str4)

  str3 => allocate_string(15)
  print 1, 'address of str3 =',LOC(str3)
  print *,'length of str3 =',len(str3)

  print *,"get_demo_string returned '"//get_demo_string()//"'"
1 format(A,1X,Z16.16)
end program
