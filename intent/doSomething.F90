subroutine doSomething(opMode, confusedParam)
    implicit none

    integer, intent(in) :: opMode
    integer :: confusedParam
!   integer, intent(inout) :: confusedParam

    if (opMode == 1) then
        print *, confusedParam
    else
        confusedParam = 42
    end if
end subroutine
subroutine doSomething2(opMode, confusedParam)
    implicit none

    integer, intent(in) :: opMode
    integer :: confusedParam
!   integer, intent(inout) :: confusedParam

    if (opMode == 1) then
        print *, confusedParam
    else
        confusedParam = 42
    end if
end subroutine
