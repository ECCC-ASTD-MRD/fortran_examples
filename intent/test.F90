program test
    implicit none

    external :: doSomething

    call doSomething(1, 21)
end program