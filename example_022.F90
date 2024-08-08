! example of use ot the atexit() functionality
program example_022
use iso_c_binding
implicit none
interface
  function c_atexit(fn)  result(status) bind(C,name='atexit')
  import :: C_INT, C_FUNPTR
  implicit none
  type(C_FUNPTR), intent(IN), value :: fn
  integer(C_INT) :: status
  end function c_atexit
end interface
external :: bye_bye1, bye_bye2, bye_bye3
integer(C_INT) :: status
status = c_atexit(C_FUNLOC(bye_bye1))
status = c_atexit(C_FUNLOC(bye_bye2))
status = c_atexit(C_FUNLOC(bye_bye3))
end
subroutine bye_bye1()
print *,'bye_bye 1'
return
end
subroutine bye_bye2()
print *,'bye_bye 2'
return
end
subroutine bye_bye3()
print *,'bye_bye 3'
return
end
