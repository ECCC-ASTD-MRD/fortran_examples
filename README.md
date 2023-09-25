#### Compilers
these sample codes have been tested with various Fortran compilers on an x86 platform  
- gfortran (versions 9.x thru 12.x)  
- ifort (Intel oneapi 2021.5)  
- flang (traditional, aocc 3.2.0)  
- nvfortran (PGI/Nvidia, 22.x)  
- flang-new (llvm, 15.0.5)  

#### Sample files
- example_001.F90 :  
. generic interfaces in a module  
. public/private items in module  

- example_002.F90 :  
. using definitions and procedures from a module

- example_003.F90 :  
. variable initialization (explicit or through user type)

- example_004.F90 :  
. LOC() / C\_LOC()  
. Fortran pointer manipulations (including non unit stride)  
. TRANSFER  
. array constructor with implied do loop  
. Fortran -> C -> Fortran pass through

- example_005.F90 :  
. allocatable strings and string pointers

- example_006.F90 :  
. write within write side effects

- example_007.F90 :  
. ambiguous code and side effects

- example_008.F90 :  
. ignore type/kind/rank

- example_009.F90 :  
. Fortran pointer manipulation  
. looking inside Fortran pointers

- example_010.fpp :  
. pointer conversion templates (c_f_pointer à la Fortran 202x)  
. uses fypp preprocessor

- example_011.F90 :  
. elemental functions in Fortran

- example_012.F90 :  
. generic interfaces use a strict interface signature

- example_013.F90 :  
. passing a Fortran string to a C function (side effects)

- example_014.F90 :  
. storage size in memory of user defined types with/out BIND(C) or SEQUENCE attribute

- example_015.F90 :  
. transfer data between C interoperable character(C_CHAR), dimension(nc1) and Fortran string character(len=nc2)

- example_016.F90 :  
. gymnastics with allocatable arrays

- example_017.F90 :  
. Fortran submodules and the file nomenclature that goes with them

- example_018.F90 :  
. Fortran modules : dealing with module cross-dependency

- example_019.F90 :  
. Fortran abstract interfaces and procedure pointers

- example_020.F90 :  
. passing Fortran optional arguments down the calling chain

- example_021.F90 :  
. Compile error with gfortran only: name conflict between modules (when used in a derived type in a submodule)

- example_022.F90 :  
. 

- example_023.F90 :  
. 

- example_024.F90 :  
. Fortran assumed size vs assumed shape vs assumed rank arrays

- example_025.F90 :  
. a twist on example_021.F90, problem demonstrated without a submodule

- example_026.F90 :  
. possible syntax problem with usage of implicit none 

#### Contributors
main contributors :  
- Philippe Carphin          (RPN-SI)  
- Jean-Philippe Gauthier    (RPN-SI)  
- Samuel Gilbert            (RPN-SI)  
- Vincent Magnoux           (RPN-SI)  
- Michel Valin              (RPN-SI)  
