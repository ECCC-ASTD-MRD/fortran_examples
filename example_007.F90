! ambiguous code, function and array have the same name
! this should NOT compile successfully
! if -DSIDE_EFFECT is used, the ambiguity is lifted,
! and the first element of array ambiguous will be printed
module demo
  contains
    integer function ambiguous(a)
    implicit none
      integer a
      AMBIGUOUS = a + a
      print *,'OOPS: function ambiguous called'
    end function
end module
program test
#if defined(SIDE_EFFECT)
  use demo, other=>ambiguous
  ! this will get the first element of array ambiguous printed
#else
  use demo
#endif
  implicit none
  integer, dimension(2) :: ambiguous = [33,44]
  integer :: answer

  answer = ambiguous(1)
  print *, 'ambiguous(1) =', answer

end program
