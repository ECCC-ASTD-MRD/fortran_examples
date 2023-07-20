! size in memory of user defined types
! influence of the SEQUENCE attribute (varies with the compiler)
program example_014
  use ISO_C_BINDING
  implicit none
  type :: type1
    character(C_CHAR), dimension(1) :: c3
    integer(C_INT32_T) :: i4a
    integer(C_INT64_T) :: i8
    integer(C_INT32_T) :: i4b
    character(C_CHAR), dimension(1) :: c5
  end type
  type, bind(C) :: type2
    character(C_CHAR), dimension(3) :: c5
    integer(C_INT64_T) :: i8
    integer(C_INT32_T) :: i4a
    integer(C_INT32_T) :: i4b
    character(C_CHAR), dimension(5) :: c3
  end type
  type :: type3
    sequence
    character(C_CHAR), dimension(3) :: c3
    integer(C_INT32_T) :: i4a
    integer(C_INT64_T) :: i8
    integer(C_INT32_T) :: i4b
    character(C_CHAR), dimension(5) :: c5
  end type
  type :: type4
    sequence
    character(C_CHAR), dimension(5) :: c5
    integer(C_INT64_T) :: i8
    integer(C_INT32_T) :: i4a
    integer(C_INT32_T) :: i4b
    character(C_CHAR), dimension(3) :: c3
  end type
  type(type1), dimension(2) :: t1
  type(type2), dimension(2) :: t2
  type(type3), dimension(2) :: t3
  type(type4), dimension(2) :: t4
  print *,'length of type1 is',storage_size(t1)
  print *,'length of type2 is',storage_size(t2)
  print *,'length of type3 is',storage_size(t3)
  print *,'length of type4 is',storage_size(t4)
end
