! expected output
!  --------------------------  array   -----------------------
! 1  'line 1                          '
! 2  'line 2                          '
! 3  'line 3                          '
! 4  'line 4                          '
! 5  'line 5                          '
! 6  '                                '
! 7  'empty                           '
! 8  'empty                           '
!  --------------------------  as is   -----------------------
! 'line 1
! line 2
! line 3
! line 4
! line 5                              '
!  --------------------------   trim   -----------------------
! 'line 1
! line 2
! line 3
! line 4
! line 5'
!  -------------------------- adjustr  -----------------------
! '                              line 1
! line 2
! line 3
! line 4
! line 5'
!
! with some compilers : (/ after last item written is ignored)
!  --------------------------  array   -----------------------
! 1  'line 1                          '
! 2  'line 2                          '
! 3  'line 3                          '
! 4  'line 4                          '
! 5  'line 5                          '
! 6  'empty                           '
! 7  'empty                           '
! 8  'empty                           '


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
  character(len=64)                :: long_string
  character(len=32), dimension(8)  :: array_string
  integer :: i

! dynamic concatenation test, auto reallocation of string
  string = ''
  do i = 1, size(cplatm_cvot_S)
    if(i > 1) string = string // ','
    string = string // cplatm_cvot_S(i)
  enddo
  print '(A,I4)', 'length of string =', len(string)
  print 1, string
  if(len(string) == (2*cplatm_n_fldou -1))then
    print '(A)', "SUCCESS"
  else
    print '(A)', "FAILED"
    stop
  endif

! multi line write into a string
  long_string = ' '
  array_string = 'empty'
  write(array_string,2) 'line 1', 'line 2', 'line 3', 'line 4', 'line 5'
  print '(A)', '--------------------------  array   -----------------------'
  do i=1,size(array_string)
    print 3, i, "'" // array_string(i) // "'"
  enddo

  long_string = 'line 1' // new_line(' ') // 'line 2' // new_line(' ') // 'line 3' // new_line(' ') // &
                'line 4' // new_line(' ') // 'line 5'
  print '(A)', '--------------------------  as is   -----------------------'
  print '(A)', "'" // long_string // "'"
  print '(A)', '--------------------------   trim   -----------------------'
  print '(A)', "'" // trim(long_string) // "'"
  print '(A)', '-------------------------- adjustr  -----------------------'
  print '(A)', "'" // adjustr(long_string) // "'"

1 format("string = '",A,"'")
2 format(8(A,/))
3 format(I1,2X,A)
end

