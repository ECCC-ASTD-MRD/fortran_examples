! about strings and null character terminator (or their absence)
program strings
  use ISO_C_BINDING
  implicit none
  interface
    subroutine print_fstring(what) BIND(C,name='print_fstring')
      import :: C_CHAR
      character(C_CHAR), dimension(*), intent(IN) :: what
    end subroutine
  end interface
  character(len=*), parameter :: string1 = 'chaine numero 1'
  character(len=*), parameter :: string2 = 'chaine numero 02'
  character(len=*), parameter :: string3 = 'chaine numero 003'
  character(len=*), parameter :: string4 = 'chaine numero 004'
  call print_fstring(string1)
  call print_fstring(string2)
  call print_fstring(string3)
  call print_fstring(string4)
end program
