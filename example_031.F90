! example of MPI Fortran code attempting to get error codes upon error
! MPICH and OpenMPI do not "react" in the same manner
module mod_031
  implicit none
  integer :: rank, wsize
contains
  subroutine print_status(message, status)
    character(len=*), intent(IN) :: message
    integer, intent(IN), value :: status
    if(rank == 0)print '(A50,I10)', message, status
  end subroutine
end module

program test_031
  use mpi
  use mod_031
  implicit none
  integer :: ierr, comm, lrank, lsize, temp
  integer, dimension(1024) :: vtemp

  call mpi_init(ierr)
! set error handler for communicators to MPI_ERRORS_RETURN
  call MPI_comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN, ierr)
  call MPI_comm_rank(MPI_COMM_WORLD, rank, ierr)
  call print_status('comm_rank(MPI_COMM_WORLD,...) status =',ierr)

  call MPI_comm_set_errhandler(123456, MPI_ERRORS_RETURN, ierr)
  call print_status('set_errhandler(123456,...) status =',ierr)
  call MPI_comm_rank(123456, lrank, ierr)
  call print_status('comm_rank(123456,...) status =',ierr)

  call MPI_comm_size(MPI_COMM_WORLD, wsize, ierr)
  call print_status('comm_size(MPI_COMM_WORLD,...) status =',ierr)
  call MPI_comm_size(123456, lsize, ierr)
  call print_status('comm_size(123456,...) status =',ierr)

  call MPI_bcast(temp, 1, 123456, 0, MPI_COMM_WORLD, ierr)
  call print_status('bcast(...,123456,...) status =',ierr)
  call MPI_bcast(temp, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
  call print_status('bcast(...,MPI_COMM_WORLD,...) status =',ierr)

  call MPI_allgather(temp, 1, MPI_INTEGER, vtemp, 1, MPI_INTEGER, MPI_COMM_WORLD, ierr)
  call print_status('allgather(...,MPI_COMM_WORLD,...) status =',ierr)
#if defined(WITH_MPICH)
  ! OpenMPI does not like this
  call MPI_allgather(temp, 1, MPI_INTEGER, vtemp, 1, MPI_INTEGER, 123456, ierr)
  call print_status('allgather(...,123456,...) status =',ierr)
#endif
  call mpi_finalize(ierr)
end
