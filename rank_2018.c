#include <stdio.h>
#include <stdint.h>
#include <ISO_Fortran_binding.h>
int rank_2018(CFI_cdesc_t *this){
//   fprintf(stderr,"CFI test : version = %8.8x, rank = %ld, element length = %ld\n",
//           this->version, (uint64_t)this->rank, this->elem_len) ;
  return this->rank ;
}
int elem_len_2018(CFI_cdesc_t *this){
  return this->elem_len ;
}
int elem_type_2018(CFI_cdesc_t *this){
  return this->type ;
}
