#include <sys/time.h>
#include <sys/resource.h>
#include <stdint.h>

static uint32_t my_seed = 0xBEBEFADA ;

int64_t get_rss(){
  struct rusage rsrc ;
  int status = getrusage(RUSAGE_SELF, &rsrc) ;
  return rsrc.ru_maxrss ;
}

uint32_t my_rand_i(){
  my_seed = 1664525 * my_seed + 1013904223 ;
  return my_seed ;         // [0 , 0xFFFFFFFF] range
}

float my_rand_f(){
  union { uint32_t u ; float f ; } uf ;
  uf.u = my_rand_i() ;
  uf.u &= 0x7FFFFF ;        // keep lower 23 bits
  uf.u |= (127 << 23) ;     // [1.0 , 2.0) range
  return (uf.f - 1.0f) ;    // [0.0 , 1.0) range
}
