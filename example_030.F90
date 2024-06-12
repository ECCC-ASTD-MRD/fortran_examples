! example of Fortran code using intrinsic functions in argument declaration
!
!  expected output :
!  dim_max   : first dimension =           5 f(1,2) =           6
!  dim_max   : first dimension =           5 f(1,2) =           6
!  dim_merge : first dimension =           3 f(1,2) =           4
!  dim_merge : first dimension =           2 f(1,2) =           3
!  dim_mod   : first dimension =           4 f(1,2) =           5
!  dim_ior   : first dimension =           5 f(1,2) =           6

subroutine dim_max(f, ni, nj)
integer, intent(IN) :: ni, nj
integer, dimension(max(ni,nj),5) :: f
print *,'dim_max   : first dimension =',size(f,1),'f(1,2) =', f(1,2)
return
end

subroutine dim_merge(f, ni, nj, k)
integer, intent(IN) :: ni, nj, k
integer, dimension(merge(ni,nj,k>0),5) :: f
print *,'dim_merge : first dimension =',size(f,1),'f(1,2) =', f(1,2)
return
end

subroutine dim_mod(f, ni, nj)
integer, intent(IN) :: ni, nj
integer, dimension(mod(ni,nj),5) :: f
print *,'dim_mod   : first dimension =',size(f,1),'f(1,2) =', f(1,2)
return
end

subroutine dim_ior(f, ni, nj)
integer, intent(IN) :: ni, nj
integer, dimension(ior(ni,nj),5) :: f
print *,'dim_ior   : first dimension =',size(f,1),'f(1,2) =', f(1,2)
return
end

program test_dimension

call dim_max([1,2,3,4,5,6,7,8,9,10], 4, 5)       ! first dimension should be 5
call dim_max([1,2,3,4,5,6,7,8,9,10], 5, 4)       ! first dimension should be 5

call dim_merge([1,2,3,4,5,6,7,8,9,10], 2, 3, 0)  ! first dimension should be 3
call dim_merge([1,2,3,4,5,6,7,8,9,10], 2, 3, 1)  ! first dimension should be 2

call dim_mod([1,2,3,4,5,6,7,8,9,10], 9, 5)       ! first dimension should be 4

call dim_ior([1,2,3,4,5,6,7,8,9,10], 1, 4)       ! first dimension should be 5
end
