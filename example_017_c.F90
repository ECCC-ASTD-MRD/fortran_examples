! Fortran submodules example
! must be compiled in the following order
! 1 : example_017_a.F90    module
! 2 : example_017_b.F90    submodule, needs the module to get the interface
! 3 : example_017_c.F90    program that uses the module
!
! different compiler wil produce different files with FC -c example_017_*.F90
!
! gfortran   : module_017.mod  module_017.smod  module_017@submodule_017.smod
! intel      : module_017.mod  module_017.smod  module_017@submodule_017.smod
! aocc flang : module_017-submodule_017.mod  module_017.mod  module_017.smod  module_017@submodule_017.smod
! nvhpc      : module_017-submodule_017.mod  module_017.mod  module_017.smod  module_017@submodule_017.smod
! llvm       : module_017-submodule_017.mod  module_017.mod  module_017.smod  module_017@submodule_017.smod
!
! nvhpc has a problem with the value attribute
program demo_017
  use module_017
  implicit none
  integer :: output
  call sub_017(123, output)            ! use generic name as defined in module
  print *, 'program demo_017 : value = ',output
  call subroutine_017(456, output)     ! use actual name as defined in module
  print *, 'program demo_017 : value = ',output
end
