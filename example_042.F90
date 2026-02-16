! writing into strings using / format element
program example_042
  implicit none
  character(len=128), dimension(5) :: string
  character(len=256) :: string2
  integer :: i
  string(1:5) = "rien"
  write(string, 1) '0123456789', '012345678', '01234567'
1 format(3(A,/),A)
  do i=1,5
    print *, len(trim(string(i))), trim(string(i))
  enddo
  print *
  write(string2,'(A)') '0123456789'//new_line('a')//' 012345678'//new_line('a')//' 01234567'//new_line('a')//''//new_line('a')//' rien'
  print *, len(trim(string2)), ' characters in string2'
  print *, trim(string2)
stop
end
