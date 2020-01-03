#!/bin/bash

# #SBATCH --array=1-22
# #SBATCH --array=1-16
# #SBATCH --array=1-69

# #SBATCH --array=21-69
#SBATCH --array=37-90

#SBATCH -o logs/gillespietau-gamma_%A_%a.out
# #SBATCH -o logs/gillespietau-gamma_${gamma}_%A_%a.out
# #SBATCH -p donia
# #SBATCH --nodelist tiger-d003
#SBATCH -N 1 # node count
#SBATCH -c 1
#SBATCH -t 60:00:00
#SBATCH --mem=32000
#SBATCH --mail-type=end
#SBATCH --mail-user=aerez@princeton.edu
#SBATCH -D /tigress/DONIA/aerez/CellMagnet


qseq=$(sed -n "$SLURM_ARRAY_TASK_ID"p all_ncs3.txt)

echo SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID sample: $qseq
# ScalingTwocellSchloglCommandline_diff_params(theta_x, theta_y, g_x, g_y, h_x, h_y, log10nc_x, log10nc_y)
matlab -r "ScalingTwocellSchloglCommandline_diff_params(0,0,1,1,) ; quit();"
