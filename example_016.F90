! gymnastics with allocatable arrays
! demonstrate the use of a finalization clause in a user defined type

module module_016
  implicit none
  private :: destruct_elastic_allocatable, destruct_elastic_pointer

  type :: elastic_allocatable
    integer, dimension(:),   allocatable :: item_1d
    integer, dimension(:,:), allocatable :: item_2d
  contains
    final :: destruct_elastic_allocatable  ! will be called when getting "out of scope"
  end type

  ! initialization in type definition necessary for associated() to work reliably
  type :: elastic_pointer
    integer, dimension(:),   pointer :: item_1d => NULL()  ! type initialization
    integer, dimension(:,:), pointer :: item_2d => NULL()  ! type initialization
  contains
    final :: destruct_elastic_pointer  ! will be called when getting "out of scope"
  end type

contains

  subroutine destruct_elastic_allocatable(this)
    type(elastic_allocatable) :: this
    print *,'finalizing elastic_allocatable type'
    if(allocated(this%item_1d)) then
      deallocate(this%item_1d)
      print *,'allocatable item_1d deallocated'
    endif
    if(allocated(this%item_2d)) then
      deallocate(this%item_2d)
      print *,'allocatable item_2d deallocated'
    endif
  end subroutine

  subroutine destruct_elastic_pointer(this)
    type(elastic_pointer) :: this
    print *,'finalizing elastic_pointer type'
    if(associated(this%item_1d)) then
      deallocate(this%item_1d)
      print *,'pointer item_1d deallocated'
    endif
    if(associated(this%item_2d)) then
      deallocate(this%item_2d)
      print *,'pointer item_2d deallocated'
    endif
  end subroutine
end module

program example_016
  implicit none
  call sub1
  print *,'=================================='
  call sub2
  print *,'=================================='
  call sub_block
  print *,'=================================='
  stop
end program

subroutine sub_block
  use module_016
  implicit none
  ! type finalization in block does not always work
  print *,'entering block'
  block
    type(elastic_pointer) :: item1
    type(elastic_allocatable) :: item2
    allocate(item1%item_1d(3))
    item1%item_1d = 123
    print *,'item1%item_1d =', item1%item_1d
    item2%item_1d = item1%item_1d
    print *,'item2%item_1d =', item2%item_1d
  end block
  print *,'exited block'
end subroutine

subroutine sub1
  use module_016
  implicit none
  type(elastic_allocatable) :: item1, item2
  type(elastic_pointer) :: item3, item4
  integer :: i
  integer, dimension(5)   :: a1
  integer, dimension(2,3) :: a2

  a1 = [(i, i=1,5)]
  a2 = 123456

  print *,'in sub1'
  if(allocated(item1%item_1d)) then
    print *,'item1%item_1d is allocated with size =',size(item1%item_1d)
  else
    print *,'item1%item_1d is not yet allocated'
  endif
  item1%item_1d = a1              ! implicit allocation
  if(allocated(item1%item_1d)) then
    print *,'item1%item_1d is allocated with size =',size(item1%item_1d)
  else
    print *,'item1%item_1d is not yet allocated'
  endif

  if(associated(item3%item_1d)) then
    print *,'item3%item_1d is associated with size =',size(item3%item_1d)
  else
    print *,'item3%item_1d is not yet associated'
  endif
  allocate(item3%item_1d, mold=item1%item_1d)
  if(associated(item3%item_1d)) then
    print *,'item3%item_1d is associated with size =',size(item3%item_1d)
  else
    print *,'item3%item_1d is not yet associated'
  endif

! when this subroutine returns, item1, item2, item3, item4 will become "out of scope"

end subroutine

subroutine sub2
  use module_016
  implicit none
  type(elastic_allocatable) :: item1, item2
  type(elastic_pointer) :: item3, item4
  integer :: i
  integer, dimension(5)   :: a1
  integer, dimension(2,3) :: a2

  print *,'in sub2'
  a1 = [(i, i=1,5)]
  a2 = 123456

  if(allocated(item2%item_2d)) then
    print *,'item2%item_2d is allocated with size =',size(item2%item_2d)
  else
    print *,'item2%item_2d is not yet allocated'
  endif
  allocate(item2%item_2d(2,3))    ! explicit allocation
  item2%item_2d = a2
  if(allocated(item2%item_2d)) then
    print *,'item2%item_2d is allocated with size =',size(item2%item_2d)
  else
    print *,'item2%item_2d is not yet allocated'
  endif

  if(associated(item4%item_2d)) then
    print *,'item4%item_2d is associated with size =',size(item4%item_2d)
  else
    print *,'item4%item_2d is not yet associated'
  endif
  allocate(item4%item_2d, mold=item2%item_2d)

  print *,'before initialization :', item4%item_2d .eq. item2%item_2d
  item4%item_2d = item2%item_2d
  print *,'after initialization  :', item4%item_2d .eq. item2%item_2d

  if(associated(item4%item_2d)) then
    print *,'item4%item_2d is associated with size =',size(item4%item_2d)
  else
    print *,'item4%item_2d is not yet associated'
  endif

! when this subroutine returns, item1, item2, item3, item4 will become "out of scope"

end subroutine
