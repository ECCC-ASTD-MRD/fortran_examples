program viv
    implicit none
    integer ni,j
    real, dimension(:), allocatable :: px
    ni = 10
    allocate(px(ni))
    px(ni) = 10.055
    do j=1,ni
       px(ni-j)= px(ni-j+1) - 0.002
    enddo
    call ez_nw(px,ni)
    stop
end program viv
subroutine ez_nw(ax,ni)
    implicit none
    integer ni,i
    real, dimension(:):: ax(ni)
    real, dimension(:,:) :: cx(ni,6)
    real, dimension(:):: bx(ni)
    print *,'ni=',ni
    do i=1,ni
       print *,'i=',i,'ax=',ax(i)
    enddo
    do i=2,ni-2
      print *,'sub(ax(i  ) - ax(i-1))=',(ax(i  ) - ax(i-1))
      print *,'sub(ax(i+1) - ax(i-1))=',(ax(i+1) - ax(i-1))
      print *,'sub(ax(i+1) - ax(i  ))=',(ax(i+1) - ax(i  ))
      print *,'sub(ax(i+2) - ax(i-1))=',(ax(i+2) - ax(i-1))
      print *,'sub(ax(i+2) - ax(i  ))=',(ax(i+2) - ax(i  ))
      print *,'sub(ax(i+2) - ax(i+1))=',(ax(i+2) - ax(i+1))
    enddo
    do i=2,ni-2
      cx(i,1) = 1. / (ax(i  ) - ax(i-1))
      cx(i,2) = 1. / (ax(i+1) - ax(i-1))
      cx(i,3) = 1. / (ax(i+1) - ax(i  ))
      cx(i,4) = 1. / (ax(i+2) - ax(i-1))
      cx(i,5) = 1. / (ax(i+2) - ax(i  ))
      cx(i,6) = 1. / (ax(i+2) - ax(i+1))
    enddo
    return
end subroutine ez_nw
