#!/bin/bash
#PBS -q long
#PBS -j oe
#PBS -l nodes=1:ppn=1,walltime=1200:00:00
#PBS -N CalibrationDrum
#PBS -o ${PBS_JOBNAME}_output.txt

cd ~/calibration/DEcalioc_OG/DEcalioc/

octave DEcalioc.m > log.octave
