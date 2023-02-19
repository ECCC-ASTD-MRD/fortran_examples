module module_017
  implicit none
  interface sub_017
    module subroutine subroutine_017(input, output)  ! interface defined here, boy will be found in a submodule
      implicit none
#if defined(WITH_VALUE)
      integer, intent(IN), value :: input      ! the value clause generates an error with some compilers (nvfortran)
#else
      integer, intent(IN) :: input
#endif
      integer, intent(OUT) :: output
    end
  end interface
end module
