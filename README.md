#### Compilers
these sample codes have been tested with various Fortran compilers on an x86 platform  
- gfortran (versions 9.x thru 12.x)  
- ifort (Intel oneapi 2021.5)  
- flang (traditional, aocc 3.2.0)  
- nvfortran (PGI/Nvidia, 22.x)  

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


#### Contributors
main code contributors :  
- Samuel Gilbert (RPN-SI)  
- Michel Valin  (RPN-SI)  
