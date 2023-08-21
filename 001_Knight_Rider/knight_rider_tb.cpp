// Based on https://github.com/DoctorWkt/ULX3S-Blinky

#include <verilatedos.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <signal.h>
#include "verilated.h"
#include "Vknight_rider.h"
#include "testb.h"

int	main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	TESTB<Vknight_rider>	*tb
		= new TESTB<Vknight_rider>;
	tb->opentrace("knight_rider.vcd");
	//tb->m_core->btn= 0;

	for (int i=0; i < 1000; i++) {
	  tb->tick();
	}

	printf("\n\nSimulation complete\n");
}
