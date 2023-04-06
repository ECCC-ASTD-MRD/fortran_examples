! example of abstract interfaces and Fortran procedure pointers
program demo
  use ISO_C_BINDING
  implicit none

  abstract interface                              ! abstract interface needed for pointer to function
    integer function procval(arg) BIND(C)         ! with argument passed by value (BIND(C) is HIGHLY RECOMMENDED)
      integer, intent(IN), value :: arg           ! errors have been seen at run time
    end function procval                          ! with some compilers if BIND(C) is missing
  end interface
  abstract interface                              ! abstract interface needed for pointer to function
    integer function procadr(arg) BIND(C)         ! with argument passed by address (BIND(C) is a good idea)
      integer, intent(IN) :: arg                  ! absence of BIND(C) seems not to induce runtime errors
    end function procadr
  end interface

  type(C_FUNPTR) :: cptrval, cptradr              ! C pointer to a function
  procedure(procadr) , pointer :: fpadr => NULL() ! Fortran pointer to generic integer function with one integer argument
  procedure(procval) , pointer :: fpval => NULL() ! Fortran pointer to integer function with one value integer argument
  integer :: i_in, i_out

  interface                                       ! interfaces to actual fFortran functions
    integer function ftnval(arg) BIND(C)
      implicit none
      integer, intent(IN), value :: arg
    end function
    integer function ftnadr(arg) BIND(C)
      implicit none
      integer, intent(IN) :: arg
    end function
  end interface

  cptrval = C_FUNLOC(ftnval)
  call c_f_procpointer(cptrval, fpval)      ! make Fortran function pointer from C function pointer
  i_out = fpval(23)
  print *,'(expecting 123) i_out =', i_out

  i_in = 45
  cptradr = C_FUNLOC(ftnadr)
  call c_f_procpointer(cptradr, fpadr)      ! make Fortran function pointer from C function pointer
  i_out = fpadr(i_in)
  print *,'(expecting 245) i_out =', i_out

end program
integer function ftnval(arg) BIND(C)
  implicit none
  integer, intent(IN), value :: arg
  ftnval = arg + 100
end function
integer function ftnadr(arg) BIND(C)
  implicit none
  integer, intent(IN) :: arg
  ftnadr = arg + 200
end function
