#!/bin/bash
#SBATCH --array=1-2000
# #SBATCH --array=1-1000
# #SBATCH --array=1-1
#SBATCH -o logs2/randparams_%A_%a.out
# #SBATCH -p donia
#SBATCH -N 1 # node count
#SBATCH -c 1
# #SBATCH -t 23:00:00
#SBATCH -t 23:59:00
#SBATCH --mem=16000
# #SBATCH --mem=32000
#SBATCH --mail-type=end
#SBATCH --mail-user=aerez@princeton.edu

OFFSET=2000
LINE_NUM=$(echo "$SLURM_ARRAY_TASK_ID + $OFFSET" | bc)

outdir='symmetric_h_theta_nc3000'
mkdir -p $outdir
line=$(sed -n "$LINE_NUM"p $outdir/symmetric_h_theta.txt)
echo "Offset $OFFSET ; Line $LINE_NUM"

theta_x=$(echo "$line" | cut -d "," -f 1)
theta_y=$(echo "$line" | cut -d "," -f 2)
h_x=$(echo "$line" | cut -d "," -f 3)
h_y=$(echo "$line" | cut -d "," -f 4)
log10nc_x=$(echo "$line" | cut -d "," -f 5)
log10nc_y=$(echo "$line" | cut -d "," -f 6)
g_x=1
g_y=1

matlab -r "ScalingTwocellSchloglCommandline_diff_params('$outdir', $theta_x, $theta_y, $g_x, $g_y, $h_x, $h_y, $log10nc_x, $log10nc_y) ; quit();"
#HillH=3
#matlab -r "ScalingTwocellHillCommandline_diff_params('$outdir', $theta_x, $theta_y, $g_x, $g_y, $h_x, $h_y, $log10nc_x, $log10nc_y, $HillH) ; quit();"
