git clone https://github.com/PurpleCrumpets/DEcalioc.git

git checkout RotDrumFromHypnos_Submission

qsub -N testDEcalioc1 -q long -l nodes=1:ppn=1 -l walltime=1000:00:00 -I



qselect -u $USER | xargs qdel
