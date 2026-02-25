program test_strings
  implicit none

  integer, PARAMETER :: cplatm_n_fldou=38

  character(len=1), dimension(cplatm_n_fldou) :: cplatm_cvot_S
  data cplatm_cvot_S /'A'  ,'S'  ,'S'  ,'S',  'S'  ,  &
                      'S'  ,'S'  ,'S'  ,'S'  ,        &
                      'U'  ,'V'  ,'U'  ,'V'  ,        &
                      'S'  ,'S'  ,'U'  ,'V'  ,        &
                      'S'  ,'S'  ,'U'  ,'V'  ,        &
                      'S'  ,'S'  ,'S'  ,'S'  ,        &
                      'U'  ,'V'  ,'S'  ,'U'  ,'V',    &
                      'S'  ,'S'  ,'S'  ,'S'  ,        &
                      'S'  ,'S'  ,'S'  ,'Z'  /

  character(len=:), allocatable :: string
  integer :: i

! dynamic concatenation test, auto reallocation of string
  string = ''
  do i = 1, size(cplatm_cvot_S)
    if(i > 1) string = string // ','
    string = string // cplatm_cvot_S(i)
  enddo
  print *,'length of string =', len(string)
  print 1, string
  if(len(string) == (2*cplatm_n_fldou -1))then
    print *,"SUCCESS"
  else
    print *,"FAILED"
    stop
  endif
1 format("string = '",A,"'")
end

