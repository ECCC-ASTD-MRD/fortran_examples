void F_passthru(void *ptr, int low, int high);
void C_passthru(void *ptr, int low, int high){
  F_passthru(ptr, low, high) ;
}
