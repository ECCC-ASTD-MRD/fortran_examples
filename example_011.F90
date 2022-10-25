! elemental functions in Fortran
module test_mod
  implicit none
  interface increment      ! generic interface
    module procedure increment_i
    module procedure increment_r
  end interface
contains
  elemental integer function increment_i(x)  ! elemental function
    integer, intent(in) :: x
    increment_i = x + 1
  end function
  elemental real function increment_r(x)     ! elemental function
    real, intent(in) :: x
    increment_r = x + 1
  end function
end module

subroutine vincr(fi, fr, n)
  use test_mod
  implicit none
  integer, intent(IN) :: n
  integer, dimension(n), intent(INOUT) :: fi
  real, dimension(n), intent(INOUT)    :: fr
  fi(1:n) = increment(fi(1:n))               ! call elemental function with a vector argument
  fr(1:n) = increment(fr(1:n))               ! call elemental function with a vector argument
end subroutine

program test
  implicit none
  integer, dimension(5) :: fi
  real, dimension(5)    :: fr
  integer :: i

  fi(1:5) = [(i, i=1,5)]
  fr = fi
  print *,'fi avant =',fi
  print *,'fr avant =',fi
  call vincr(fi, fr, 5)
  print *,'fi apres =',fi
  print *,'fr apres =',fi
end
