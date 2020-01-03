#!/bin/bash
#SBATCH --array=3-1891
# #SBATCH --array=2-2
#SBATCH -o logs/twocell_prodcons_%A_%a.out
# #SBATCH -p donia
#SBATCH -N 1 # node count
#SBATCH -c 1
# #SBATCH -t 23:00:00
#SBATCH -t 4:00:00
#SBATCH --mem=16000
# #SBATCH --mem=32000
#SBATCH --mail-type=end
#SBATCH --mail-user=aerez@princeton.edu


mkdir -p $outdir
outdir='producer-consumer'
#outdir='hhh'

line=$(sed -n "$SLURM_ARRAY_TASK_ID"p producer-consumer.txt)

theta_x=$(echo "$line" | cut -d "," -f 1)
theta_y=$(echo "$line" | cut -d "," -f 2)
h_x=$(echo "$line" | cut -d "," -f 3)
h_y=$(echo "$line" | cut -d "," -f 4)
log10nc_x=$(echo "$line" | cut -d "," -f 5)
log10nc_y=$(echo "$line" | cut -d "," -f 6)
g_x=1
g_y=1

# ScalingTwocellSchloglCommandline_diff_params(theta_x, theta_y, g_x, g_y, h_x, h_y, log10nc_x, log10nc_y)
matlab -r "ScalingTwocellSchloglCommandline_diff_params('$outdir', $theta_x, $theta_y, $g_x, $g_y, $h_x, $h_y, $log10nc_x, $log10nc_y) ; quit();"
