! example of passing Fortran optional arguments down the calling chain
program optional
  implicit none
  interface
    subroutine first(msg, a, b, c)
    implicit none
    logical, dimension(2), intent(IN) :: msg
    integer a
    integer, optional :: b, c
    end
  end interface

  call first([.false., .false.], 5)            ! both b and c absent
  call first([.false.,  .true.], 6, c=4)       ! b absent, c present
  call first([.true. , .false.], 7, b=4)       ! b present, c absent
  call first([.true. ,  .true.], 8, c=4, b=4)  ! b present, c present
end program

subroutine first(msg, a, b, c)
  implicit none
  logical, dimension(2), intent(IN) :: msg ! .false if b , c are expected to be absent
  integer a
  integer, optional :: b, c
  interface
    subroutine second(msg, a, b, c)
    implicit none
    logical, dimension(2), intent(IN) :: msg
    integer a
    integer, optional :: b, c
    end
  end interface

! combine received status with what the call does
! msg[1] == .false. : b is expected to be absent
! msg[2] == .false. : c is expected to be absent
call second(msg .and. [.true. ,  .true.], a , b, c)       ! b, c as received
call second(msg .and. [.true. ,  .true.], a , b=b, c=c)   ! b, c as received
call second(msg .and. [.false.,  .true.], a , c=c)        ! b absent, c as received
call second(msg .and. [.true. , .false.], a , b=b)        ! b as received, c absent
call second(msg .and. [.false., .false.], a)              ! b absent, c absent
return
end subroutine

subroutine second(msg, a, b, c)
  implicit none
  logical, dimension(2), intent(IN) :: msg ! .false if b , c are expected to be absent
  integer a
  integer, optional :: b, c
  logical, dimension(2) :: found
  character(len=10) :: status

! msg[1] == .false. : b is expected to be absent
! msg[2] == .false. : c is expected to be absent
  found = [present(b), present(c)]  ! presence of b, c
  if(all(found .eqv. msg))then      ! as expected ?
    status = ' : SUCCESS'
  else
    status = ' : ERROR'
  endif
  print 1, 'A =', a, ', B, C presence =', found, ', expected :',  msg, trim(status)
1 format(A,I2,A,2L2,A,2L2,A)
  return
end subroutine
