submodule (module_017) submodule_017  ! submodule whose parent is module_017
#if ! defined(NO_IMPNONE)
  implicit none                       ! generates an error with some compilers if intput has the value attribute
#endif
  integer :: some_value = 123456
contains
! must use module procedure instead of subroutine/function in interface definition
  module procedure subroutine_017   ! must not duplicate the inferface, already defined in module module_017
      output = input
      print *,'some_value =', some_value
      print *,'subroutine_017 : input =', input
      some_value = input
  end
end submodule
