#!/bin/bash
#PBS -q default
#PBS -j oe
#PBS -l nodes=1:ppn=0,walltime=00:00:00
#PBS -N DEM
#PBS -o path/${PBS_JOBNAME}_output.txt

cd ~/
find */src/lmp_auto -exec cp {} path \;
cd path

mpirun -np 0 lmp_auto < in.Lift100
