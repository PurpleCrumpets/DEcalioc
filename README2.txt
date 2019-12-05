git clone https://github.com/PurpleCrumpets/DEcalioc.git
cd DEcalioc/
git branch -a
git checkout RotDrumFromHypnos_Submission

qsub -N testDEcalioc1 -q long -l nodes=1:ppn=1 -l walltime=1000:00:00 -I

cd calibration/DEcalioc/DEcalioc

qselect -u $USER | xargs qdel



Submit Job Script
/opt/torque/bin/qsub submitCalibration.sh
