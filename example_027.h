
#if defined(IN_FORTRAN_CODE)
! match the C struct
  type, BIND(C) :: demo
   integer(C_INT64_T) :: i64
   type(C_PTR)        :: p64
   integer(C_INT32_T) :: i32, j32
   character(len=1)   :: c8(8), c16(16)
  end type

#else
// match the Fortran user defined type
  typedef struct{
    int64_t i64 ;
    void *p64 ;
    int32_t i32, j32 ;
    char c8[8], c16[16] ;
  } demo ;

#endif
