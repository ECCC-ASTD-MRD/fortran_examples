submodule (module_017) submodule_017  ! submodule whose parent is module_017
contains
! must use module procedure instead of subroutine/function in interface definition
  module procedure subroutine_017   ! must not duplicate the inferface, already defined in module module_017
      implicit none                 ! subroutine body here
      output = input
      print *,'subroutine_017 : input =', input
  end
end submodule
