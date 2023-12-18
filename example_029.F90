! share a threadprivate variable between C and Fortran
! in this example Fortran provides the "accessor" functions
! it could be done the other way around with C providing the "accessor" functions
!
! with some compilers
! integer(C_INT), bind(C, name='some_name") :: sharedvar
! works directly
! with some compilers
! threadprivate and bind(C) used together induces a crash
!
! export OMP_NUM_THREADS=6
! gcc -c -fopenmp example_029_c.c   && gfortran -fopenmp example_029.F90 example_029_c.o && ./a.out
! icx -c -qopenmp example_029_c.c   && ifx -qopenmp example_029.F90 example_029_c.o      && ./a.out
! clang -c -fopenmp example_029_c.c && flang -mp example_029.F90 example_029_c.o         && ./a.out
! nvc -c -fopenmp example_029_c.c   && nvfortran -mp example_029.F90 example_029_c.o     && ./a.out
!
! some compilers consider the threadprivate line being found
! before the declaration of sharedvar as an error
! some compilers ar O.K. both ways
!
module example_029_vars
  use ISO_C_BINDING
  implicit none
  integer, external :: omp_get_thread_num
  integer(C_INT) :: sharedvar
!$omp threadprivate(sharedvar)
  interface
    subroutine c_thread(the_var) bind(C, name='C_thread')
      import :: C_INT
      integer(C_INT) :: the_var
    end
  end interface
contains
  subroutine f_thread(the_var)
  integer(C_INT), intent(OUT) :: the_var
  the_var = sharedvar
  end
  integer function get_sharedvar() bind(C, name='Get_sharedvar')  ! used by C to get the value
    get_sharedvar = sharedvar
  end
  subroutine set_sharedvar(v) bind(C, name='Set_sharedvar')       ! used by C to set the value
    integer, intent(IN), value :: v
    sharedvar = v
  end
end module

program example_029
  use example_029_vars
  implicit none
!$OMP parallel
  call fortran_thread  ! parallel call
!$OMP end parallel
end program

subroutine fortran_thread()
  use example_029_vars
  implicit none
  integer :: i, j, k, th, v
  th = omp_get_thread_num()
  print *, 'this is thread', th
  do i=1,100000000
    ! set the value of the threadprivate variable directly
    v = i  + mod(th,10) * 100000000    ! different values in different threads
    sharedvar = v
    call f_thread(j)   ! access the threadprivate variable via a Fortran function
    if(j .ne. v) then  ! check that we get the right value for this thread
      print *,'thread', th, ', expected', v, ', got', j
      exit
    endif
    call c_thread(k)   ! access the threadprivate variable via a C function
    if(k .ne. v) then  ! check that we get the right value
      print *,'thread', th, ', expected', v, ', got', k
      exit
    endif
  enddo
  return
end
