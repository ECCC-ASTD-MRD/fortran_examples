! gymnastics with allocatable arrays
! demonstrate the use of a finalization clause in a user defined type
! useful reference about allocatable arrays and their properties :
! https://fortran-lang.org/en/learn/best_practices/allocatable_arrays/
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
      print *,'allocatable component item_1d deallocated'
    else
      print *,'no need to deallocate allocatable component item_1d'
    endif
    if(allocated(this%item_2d)) then
      deallocate(this%item_2d)
      print *,'allocatable component item_2d deallocated'
    else
      print *,'no need to deallocate allocatable component item_2d'
    endif
  end subroutine

  subroutine destruct_elastic_pointer(this)
    type(elastic_pointer) :: this
    print *,'finalizing elastic_pointer type'
    if(associated(this%item_1d)) then
      deallocate(this%item_1d)
      print *,'pointer component item_1d deallocated'
    else
      print *,'no need to deallocate unassociated pointer component item_1d'
    endif
    if(associated(this%item_2d)) then
      deallocate(this%item_2d)
      print *,'pointer component item_2d deallocated'
    else
      print *,'no need to deallocate unassociated pointer component item_2d'
    endif
  end subroutine
end module

program example_016
  use module_016
  implicit none
  type(elastic_pointer), pointer :: machin
  call sub0
  print *,'=================================='
  call sub1
  print *,'=================================='
  call sub2
  print *,'=================================='
  call sub_block
  print *,'=================================='
  print *,'allocating machin and sub components'
  allocate(machin)
  allocate(machin%item_1d(3))
  allocate(machin%item_2d(2,3))
  print *,'deallocating machin'
  deallocate(machin)
  print *,'machin deallocated'
  print *,'=================================='
  stop
end program

subroutine sub_block
  use module_016
  implicit none
  type(elastic_allocatable) :: item1
  type(elastic_pointer) :: item3
  ! type finalization in block does not always work the same way wirth all compilers
  print *,'entering block'
  block
    type(elastic_pointer) :: item1
    type(elastic_allocatable) :: item2
    allocate(item1%item_1d(3))
    item1%item_1d = 123
    print *,'item1%item_1d =', item1%item_1d
    item2%item_1d = item1%item_1d
    print *,'item2%item_1d =', item2%item_1d
  end block  ! item1 and item2 from block now "out of scope"
  print *,'exited block'
  item1%item_1d = [1]   ! implicit allocation for item1%item_1d (allocatable, not pointer item)
  print *,'exiting sub_block'
end subroutine ! item1 and item3 from subroutine now "out of scope"

subroutine sub0
  use module_016
  implicit none
  type(elastic_pointer) :: item3
  integer, dimension(:), pointer   :: p1
  integer, dimension(:,:), pointer :: p2

  print *,'entering sub0'
  if(associated(item3%item_1d)) then
    print *,'item3%item_1d is associated with size =',size(item3%item_1d)
  else
    print *,'item3%item_1d is not yet associated'
  endif
  print *,'in sub0'
  allocate( p1(5) )
  nullify(p2)
  item3 = elastic_pointer(p1, p2)         ! creator
  if(associated(item3%item_1d)) then
    print *,'item3%item_1d is associated with size =',size(item3%item_1d)
  else
    print *,'item3%item_1d is not yet associated'
  endif
  if(associated(item3%item_2d)) then
    print *,'item3%item_2d is associated with size =',size(item3%item_2d)
  else
    print *,'item3%item_2d is not associated'
  endif

  print *,'exiting sub0'
! when this subroutine returns, item3 will become "out of scope"
end subroutine

subroutine sub1
  use module_016
  implicit none
  type(elastic_allocatable) :: item1
  type(elastic_pointer) :: item3
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

  print *,'exiting sub1'
! when this subroutine returns, item1, item3 will become "out of scope"

end subroutine

subroutine sub2
  use module_016
  implicit none
  type(elastic_allocatable) :: item2
  type(elastic_pointer) :: item4
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

  print *,'exiting sub1'
! when this subroutine returns, item2, item4 will become "out of scope"

end subroutine
