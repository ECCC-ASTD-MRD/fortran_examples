program example_032
    implicit none
    integer ni,j
    real, dimension(:), allocatable :: px
    ni = 10
    allocate(px(ni))
    px(ni) = 10.055
    do j=1,ni-1
       px(ni-j)= px(ni-j+1) - 0.002
    enddo
    call demo(px,ni)
    stop
end program example_032
subroutine demo(ax,ni)
    implicit none
    integer ni,i,ni1
    real, dimension(ni):: ax
    real, dimension(ni,6) :: cx
    print '(10F8.3)',ax
    ni1 = ni-8
    print *,'ni=',ni,'ni1=',ni1
    do i=2,ni1
      cx(i,1) = 1. / (ax(i  ) - ax(i-1))
      cx(i,2) = 1. / (ax(i+1) - ax(i-1))
    enddo
    return
end subroutine demo
