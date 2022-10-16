
CC = gcc
CFLAGS =
FC = gfortran
FFLAGS =
DEFINES =

example_001:	example_001.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe

example_002:	example_002.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_003:	example_003.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

clean:
	rm -f *.o *.mod *.exe a.out
