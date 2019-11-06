#!/bin/bash
#PBS -q default
#PBS -j oe
#PBS -l nodes=1:ppn=4,walltime=200:00:00
#PBS -N 0001fvz_35572
#PBS -o ~/calibration/20191105_084617/Lift100/0001fvz_35572/${PBS_JOBNAME}_output.txt

cd ~/
find */src/lmp_auto -exec cp {} ~/calibration/20191105_084617/Lift100/0001fvz_35572 \;
cd ~/calibration/20191105_084617/Lift100/0001fvz_35572

mpirun -np 4 lmp_auto < in.Lift100