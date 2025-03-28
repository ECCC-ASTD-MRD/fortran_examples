! unsigned arithmetic, binary format descriptor, adaptive field length format descriptor
! borrowed from fortran-lang.org
program example_036
  use,intrinsic :: iso_fortran_env, only : int8
  implicit none
  integer            :: i
  integer(kind=int8) :: byte
    ! Compare some one-byte values to 64.
    ! Notice that the values are tested as bits not as integers
    ! so sign bits in the integer are treated just like any other
    ! similar to the C unsigned integer behavior
    write(*,'(a)') 'we will compare other values to 64'
    i=64
    byte=i
    ! sp format descriptor : always print the sign (s), until further notice (p)
    ! i0.4, b0.4 : 0.4 means use as much space as necessary, but at least 4 characters
    ! b descriptor : binary format
    ! bgt intrinsic : "bitwise greater than" for all practical purposes, unsigned comparison
    ! https://gcc.gnu.org/onlinedocs/gcc-4.7.0/gfortran/BGT.html
    write(*,'(sp,i0.4,*(1x,1l,1x,b0.8))')i,bgt(byte,64_int8),byte

    write(*,'(a)') "comparing at the bit level, not as whole numbers."
    write(*,'(a)') "so pay particular attention to the negative"
    write(*,'(a)') "values on this two's complement platform ..."
    do i=-128,127,32
        byte=i
        write(*,'(sp,i0.4,*(1x,1l,1x,b0.8))')i,bgt(byte,64_int8),byte
    enddo
end
! expected output :
!
!     we will compare other values to 64
!     +0064 F 01000000
!     comparing at the bit level, not as whole numbers.
!     so pay particular attention to the negative
!     values on this two's complement platform ...
!     -0128 T 10000000
!     -0096 T 10100000
!     -0064 T 11000000
!     -0032 T 11100000
!     +0000 F 00000000
!     +0032 F 00100000
!     +0064 F 01000000
!     +0096 T 01100000
