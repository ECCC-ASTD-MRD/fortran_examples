// Fortran routine to be called (same interface as C_passthru
void F_passthru(void *ptr, int low, int high);

// the sole purpose of this C function is to make a "ricochet" call to F_passthru
// when called by Fortran code
void C_passthru(void *ptr, int low, int high){
  F_passthru(ptr, low, high) ;
}
