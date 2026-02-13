
ifeq (${CC},)
CC = gcc
endif

ifeq (${FC},ifx)
ifeq (${TEST_FFLAGS},)
TEST_FFLAGS = -fpe0
endif
endif

CFLAGS =
ifeq (${FC},f77)
ifeq (${FTN},)
FC = gfortran
else
FC = ${FTN}
endif
endif
FFLAGS = ${FFLAGS_EXTRA} ${EXTRA_FFLAGS} ${TEST_FFLAGS}
DEFINES =

utilities.o:	utilities.c
	${CC} -c utilities.c

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

example_014:	example_014.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_015:	example_015.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_016:	example_016.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_017:	example_017_a.F90 example_017_b.F90 example_017_c.F90
	${FC} ${FFLAGS} ${DEF} example_017_a.F90 example_017_b.F90 example_017_c.F90 -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_018:	example_018.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_020:	example_020.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_022:	example_022.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_028:	example_028.F90
	${FC} ${FFLAGS} ${DEF} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_029:	example_029.F90 example_029_c.c
	${CC} -c example_029_c.c ${OMP} && ${FC} ${FFLAGS} ${DEF} ${OMP} $< example_029_c.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_030:	example_030.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_031:	example_031.F90
	mpif90 ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && mpirun -n 2 ./$@.exe
	rm -f $@.exe *.mod

example_032:	example_032.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_033:	example_033.F90 rank_2018.c
	${CC} -c rank_2018.c
	${FC} ${FFLAGS} ${DEF} ${OMP} example_033.F90 rank_2018.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod rank_2018.o

example_034:	example_034.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_035:	example_035.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_036:	example_036.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_037:	example_037.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_038:	example_038.F90 utilities.o
	${FC} ${FFLAGS} ${DEF} ${OMP} $< utilities.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_039:	example_039.F90 utilities.o
	${FC} ${FFLAGS} ${DEF} ${OMP} $< utilities.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_040:	example_040.F90 example_040_c.c
	${CC} -c example_040_c.c
	${FC} ${FFLAGS} ${DEF} ${OMP} $< example_040_c.o -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_041:	example_041.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

example_042:	example_042.F90
	${FC} ${FFLAGS} ${DEF} ${OMP} $< -o $@.exe && ./$@.exe
	rm -f $@.exe *.mod

clean:
	rm -f *.o *.mod *.exe a.out *.smod
