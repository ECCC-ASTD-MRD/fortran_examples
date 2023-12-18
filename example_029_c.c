// share a threadprivate variable with Fortran

void Set_sharedvar(int v) ;   // get the threadprivate variable
int Get_sharedvar() ;         // set the threadprivate variable

// with some compilers, the variable can be shared directly with Fortran
// extern int the_variable_name
// #pragma omp threadprivate(the_variable_name)

void C_thread(int *the_var){
  *the_var = Get_sharedvar() ;
}
