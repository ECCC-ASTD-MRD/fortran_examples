! data assignment character(C_CHAR), dimension(nc1) to/from character(len=nc2)
program example_015
use ISO_C_BINDING
implicit none
character(len=10) :: c10
character(C_CHAR), dimension(15) :: a10
c10 = '0123456789'
a10 = 'X'

! transfer c10 into the beginning of a10
a10(1:len(c10)) = transfer(c10, a10)
print 1, "a10 = '", a10,"'"
1 format(A,20A1)

c10 = '__________'
print 2,"c10 = '"//c10//"'"
! transfer 5 charaacters from aray a10 into first 5 characters of c10
c10(1:5) = transfer(a10(1:5), c10)
print 2,"c10 = '"//c10//"'"
2 format(A)
end
