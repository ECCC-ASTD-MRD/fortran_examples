! writing into strings using / format element
program example_042
  implicit none
  character(len=128), dimension(5) :: string
  integer :: i
  string(1:5) = "rien"
  write(string, 1) '0123456789', '012345678', '01234567'
1 format(3(A,/),A)
  do i=1,5
    print *, len(trim(string(i))), trim(string(i))
  enddo
stop
end
