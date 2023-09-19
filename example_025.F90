module type_1
  implicit none
  type :: type1
    integer :: val
  contains
    procedure, PASS :: setval
  end type
  interface
    module subroutine setval(this, what)
#if defined(IMPNONE)
      implicit none
#endif
      class(type1), intent(INOUT) :: this
      integer, intent(IN) :: what
    end
  end interface
end

submodule (type_1) sub_type_1
  implicit none
contains
  module procedure setval
    this%val = what
  end
end

module type_2
  implicit none
  type :: type2
    integer :: val
  contains
    procedure, PASS :: setval
  end type
  interface
    module subroutine setval(this, what)
#if defined(IMPNONE)
      implicit none
#endif
      class(type2), intent(INOUT) :: this
      integer, intent(IN) :: what
    end
  end interface
end

submodule (type_2) sub_type_2
  implicit none
contains
  module procedure setval
    this%val = what
  end
end

program example_025
  use type_1
  use type_2
  implicit none
  type(type1) :: t1
  type(type2) :: t2
  call t1%setval(12)
  call t2%setval(13)
  print *, 'expecting 12, 13', t1%val, t2%val
end
