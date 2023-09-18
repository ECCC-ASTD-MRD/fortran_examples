! example of Fortran code using different ways to describe array shapes
! and of some of the associated potential side effects
! compile with -DNO_2018 to omit assumed rank testing (Fortran 2018 feature)
module array_shapes
  implicit none
  interface
    subroutine assumed_size(a, n, ref, nr)       ! example of assumed size arrays
      implicit none
      integer, intent(IN) :: n, nr               ! effective sizes of a and ref
      integer, dimension(*), target :: a         ! expecting a subset of the full array
      integer, dimension(*), target :: ref       ! the full array
    end
    subroutine assumed_shape(a, n, ref, nr)      ! example of assumed shape arrays
      implicit none
      integer, intent(IN) :: n, nr               ! effective sizes of a and ref
      integer, dimension(:,:,:), target :: a     ! expecting a subset of the full array
      integer, dimension(:,:,:), target :: ref   ! the full array
    end
#if ! defined(NO_2018)
    subroutine assumed_rank(a, n, ref, nr, nd)   ! example of assumed shape arrays
      implicit none                              ! Fortran 2018 feature, not supported by all compilers
      integer, intent(IN) :: n, nr               ! effective sizes of a and ref
      integer, intent(IN) :: nd                  ! expected rank (number of dimensions)
      integer, dimension(..), target :: a        ! expecting a subset of the full array
      integer, dimension(..), target :: ref      ! the full array
    end
#endif
  end interface
end module
program example_024
  use, intrinsic :: iso_fortran_env
  use array_shapes
  implicit none
  integer, dimension(7)     :: a1
  integer, dimension(7,6)   :: a2
  integer, dimension(7,6,5) :: a3
  character(len=256) :: cv

  cv = compiler_version()
  print '(2a)', 'This file was compiled by ', cv(1:45)
!   print '(2a)', 'with options ', compiler_options()

  print '(/A)', 'testing assumed size arrays'
  call assumed_size(a1, size(a1), a1, size(a1))       ! calling with full array a1
  call assumed_size(a2, size(a2), a2, size(a2))       ! calling with full array a2
  call assumed_size(a3, size(a3), a3, size(a3))       ! calling with full array a3
  ! a copy-in operation will be necessary
  call assumed_size(a3(2:6,2:5,2:4), 60, a3, size(a3))  ! calling with subset of a3

  print '(/A)', 'testing assumed shape arrays'
  call assumed_shape(a3, size(a3), a3, size(a3))
  ! a copy-in operation should not be necessary
  call assumed_shape(a3(2:6,2:5,2:4), 60, a3, size(a3))  ! calling with subset of a3

#if ! defined(NO_2018)
  print '(/A)', 'testing assumed rank arrays'
  call assumed_rank(a1, size(a1), a1, size(a1), 1)       ! calling with full array a1
  call assumed_rank(a2, size(a2), a2, size(a2), 2)       ! calling with full array a2
  call assumed_rank(a3, size(a3), a3, size(a3), 3)       ! calling with full array a3
  call assumed_rank(a3(2:6,2:5,2:4), 60, a3, size(a3), 3)  ! calling with subset of a3
#endif
end program

subroutine assumed_size(a, n, ref, nr)
  use, intrinsic :: ISO_C_BINDING
  use, intrinsic :: iso_fortran_env
  implicit none
  integer, intent(IN) :: n, nr
  integer, dimension(*), target :: a     ! assumed size
  integer, dimension(*), target :: ref   ! assumed size
  integer(C_INTPTR_T) :: loca, locr
  type(C_PTR) :: pa, pr

  pa   = C_LOC(a)
  pr   = C_LOC(ref)
  loca = transfer(pa, loca)
  locr = transfer(pr, locr)
  print '(A,Z16.16,A,I3)', 'address of a : ', loca, ', size of a : ',n
  if(loca < locr .or. loca >= locr+nr) then
    print '(A,Z16.16,A,Z16.16)', ' bounds of ref : ', locr, ', ', locr+nr-1
    print '(A)', ' address of a is not inside ref'
  else
    print '(A)', ' a is found inside ref'
  endif
end

subroutine assumed_shape(a, n, ref, nr)
  use, intrinsic :: ISO_C_BINDING
  use, intrinsic :: iso_fortran_env
  implicit none
      integer, intent(IN) :: n, nr
  integer, dimension(:,:,:), target :: a     ! assumed shape
  integer, dimension(:,:,:), target :: ref   ! assumed shape
  integer(C_INTPTR_T) :: loca, locr
  type(C_PTR) :: pa, pr

  pa   = C_LOC(a)
  pr   = C_LOC(ref)
  loca = transfer(pa, loca)
  locr = transfer(pr, locr)
  if(n .ne. size(a) .or. nr .ne. size(ref)) print '(A)', 'ERROR: dimension mismatch'
  print '(A,Z16.16,A,I3)', 'address of a : ', loca, ', size of a : ',n
  if(loca < locr .or. loca >= locr+nr) then
    print '(A,Z16.16,A,Z16.16)', ' bounds of ref : ', locr, ', ', locr+nr-1
    print '(A)', ' address of a is not inside ref (not expected)'
  else
    print '(A)', ' a is found inside ref (as expected)'
  endif
end

#if ! defined(NO_2018)
subroutine assumed_rank(a, n, ref, nr, nd)
  use, intrinsic :: ISO_C_BINDING
  use, intrinsic :: iso_fortran_env
  implicit none
  integer, intent(IN) :: n, nr, nd
  integer, dimension(..), target :: a     ! assumed rank
  integer, dimension(..), target :: ref   ! assumed rank
  integer(C_INTPTR_T) :: loca, locr
  type(C_PTR) :: pa, pr

  pa   = C_LOC(a)
  pr   = C_LOC(ref)
  loca = transfer(pa, loca)
  locr = transfer(pr, locr)
  print '(A,Z16.16,A,I3)', 'address of a : ', loca, ', size of a : ',n
  if(rank(a) .ne. nd .or. rank(ref) .ne. nd) then
    print '(A,I2)', ' ERROR: rank mismatch, expected rank = ', nd
    print '(A,I2,A,I2)', ' rank of array a :', rank(a), ', rank of array ref :', rank(ref)
  endif
  if(n .ne. size(a) .or. nr .ne. size(ref)) print '(A)', 'ERROR: dimension mismatch'
  if(loca < locr .or. loca >= locr+nr) then
    print '(A,Z16.16,A,Z16.16)', ' bounds of ref : ', locr, ', ', locr+nr-1
    print '(A)', ' address of a is not inside ref (not expected)'
  else
    print '(A)', ' a is found inside ref (as expected)'
  endif
end
#endif
