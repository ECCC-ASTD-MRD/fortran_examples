#include <stdint.h>
#include <stdio.h>
#include <example_027.h>

// get a struct from Fortran
// return a struct to fortran
demo init_demo(demo d){
  d = (demo) { .i64 = 1234, .i32 = 33, .j32 = 55, .p64 = NULL} ; // Compound-Literal
  d.c8[0] = 'a' ;
  d.c16[15] = 'z' ;
  return d ;
}
