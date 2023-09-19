module metamorphe
  use ISO_C_BINDING
  implicit none
  interface choix
    subroutine choix1(machin, expected)
      import :: C_INTPTR_T, C_PTR, C_INT32_t
      implicit none
      integer(C_INTPTR_T), intent(IN) :: machin
      character(len=*), intent(IN) :: expected
    end
    subroutine choix2(machin, expected)
      import :: C_INTPTR_T, C_PTR, C_INT32_t
      implicit none
      type(C_PTR), intent(IN) :: machin
      character(len=*), intent(IN) :: expected
    end
    subroutine choix3(machin, expected)
      import :: C_INTPTR_T, C_PTR, C_INT32_t
      implicit none
      integer(C_INT32_t), intent(IN) :: machin
      character(len=*), intent(IN) :: expected
    end
  end interface
end
program example_026
  use metamorphe
  implicit none
  type(C_PTR) :: cptr
  integer(C_INTPTR_T), target :: intptr
  integer(C_INT64_T) :: int64
  call choix(intptr       , 'choix1')  ! 64 bit integer
  call choix(int64        , 'choix1')  ! 64 bit integer
  call choix(LOC(intptr)  , 'choix1')  ! 64 bit integer
  call choix(transfer(cptr,int64), 'choix1')
  call choix(cptr         , 'choix2')  ! C pointer
#if ! defined(NO_PTR_TRANSFER)
  call choix(transfer(int64,cptr), 'choix2')
#endif
  call choix(C_LOC(intptr), 'choix2')  ! C_LOC() result
  call choix(123          , 'choix3')  ! 32 bit integer
end
subroutine choix1(machin, expected)
  use ISO_C_BINDING
  implicit none
  integer(C_INTPTR_T), intent(IN) :: machin
  character(len=*), intent(IN) :: expected
  print '(A,A)', 'choix1 called, expected = ', trim(expected)
  if(trim(expected) .ne. 'choix1') print '(A)', '  ERROR: wrong procedure selected'
end
subroutine choix2(machin, expected)
  use ISO_C_BINDING
  implicit none
  type(C_PTR), intent(IN) :: machin
  character(len=*), intent(IN) :: expected
  print '(A,A)', 'choix2 called, expected = ', trim(expected)
  if(trim(expected) .ne. 'choix2') print '(A)', '  ERROR: wrong procedure selected'
end
subroutine choix3(machin, expected)
  use ISO_C_BINDING
  implicit none
  integer(C_INT32_t), intent(IN) :: machin
  character(len=*), intent(IN) :: expected
  print '(A,A)', 'choix3 called, expected = ', trim(expected)
  if(trim(expected) .ne. 'choix3') print '(A)', '  ERROR: wrong procedure selected'
end
