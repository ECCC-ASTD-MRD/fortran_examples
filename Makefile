
CC = gcc
CFLAGS =
ifeq (${FC},f77)
ifeq (${FTN},)
FC = gfortran
else
FC = ${FTN}
endif
endif
FFLAGS = ${FFLAGS_EXTRA}
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

example_004:	example_004.F90 example_004_c.c
	$(CC) -c example_004_c.c
	${FC} ${FFLAGS} ${DEF} $< example_004_c.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_005:	example_005.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_006:	example_006.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_007:	example_007.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_008:	example_008.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_009:	example_009.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_010:	example_010.fpp
	bin/fypp -F example_010.fpp example_010.F90
	${FC} ${FFLAGS} ${DEF} example_010.F90 -o example_010.exe && ./$@.exe
	rm -f $@.exe *.mod example_010.F90

example_011:	example_011.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_012:	example_012.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_013:	example_013.F90 example_013_c.c
	${CC} -c example_013_c.c
	${FC} ${FFLAGS} ${DEF} example_013.F90 example_013_c.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

clean:
	rm -f *.o *.mod *.exe a.out
