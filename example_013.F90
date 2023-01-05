! example of calling a C function with a Fortran string constant
! make  FC=my_fortran_compiler example_013
!
! output will vary with different compilers
!
! $ make FC=gfortran example_013  # gnu fortran
! gcc -c example_013_c.c
! gfortran   example_013.F90 example_013_c.o -o example_013.exe && ./example_013.exe
! C: print_string(): string : 'word 1word 2word 3word 4'
! C: print_string(): string : 'word 2word 3word 4'
! C: print_string(): string : 'word 3word 4'
! C: print_string(): string : 'word 4'
!
! make FC=ifort example_013  # Intel OneAPI
! gcc -c example_013_c.c
! ifort -march=skylake -fp-model=source  example_013.F90 example_013_c.o -o example_013.exe && ./example_013.exe
! C: print_string(): string : 'word 1'
! C: print_string(): string : 'word 2'
! C: print_string(): string : 'word 3'
! C: print_string(): string : 'word 4'
!
! make FC=flang example_013 # AMD aocc 
! gcc -c example_013_c.c
! flang   example_013.F90 example_013_c.o -o example_013.exe && ./example_013.exe
! C: print_string(): string : 'word 1'
! C: print_string(): string : 'word 2word 1'
! C: print_string(): string : 'word 3word 2word 1'
! C: print_string(): string : 'word 4word 3word 2word 1'
!
! make FC=flang-new example_013   # new Fortran compiler, llvm 15
! gcc -c example_013_c.c
! flang-new -L/opt/llvm/lib  example_013.F90 example_013_c.o -o example_013.exe && ./example_013.exe
! C: print_string(): string : 'word 1word 2word 3word 4'
! C: print_string(): string : 'word 2word 3word 4'
! C: print_string(): string : 'word 3word 4'
! C: print_string(): string : 'word 4'
!
! make FC=pgfortran example_013 )   # Nvidia / PGI compiler
! gcc -c example_013_c.c
! pgfortran   example_013.F90 example_013_c.o -o example_013.exe && ./example_013.exe
! example_013.F90:
! C: print_string(): string : 'word 1'
! C: print_string(): string : 'word 2word 1'
! C: print_string(): string : 'word 3word 2word 1'
! C: print_string(): string : 'word 4word 3word 2word 1'
!
program example_013
      use iso_c_binding
      interface
          subroutine print_string(str) bind(C, name="print_string")
              use iso_c_binding
              character(kind=C_CHAR), dimension(*), intent(in) :: str
          end subroutine
      end interface
     call print_string("word 1")
     call print_string("word 2")
     call print_string("word 3")
     call print_string("word 4")
end program

