#!/bin/bash
## 10000 jobs
#SBATCH --array=1-1000
#SBATCH -o logs6/randparams_%A_%a.out
# #SBATCH -p donia
#SBATCH -N 1 # node count
#SBATCH -c 1
# #SBATCH -t 23:00:00
#SBATCH -t 10:59:00
#SBATCH --mem=16000
# #SBATCH --mem=32000
#SBATCH --mail-type=end
#SBATCH --mail-user=aerez@princeton.edu

OFFSET=2900
LINE_NUM=$(echo "$SLURM_ARRAY_TASK_ID + $OFFSET" | bc)

outdir='randparams0_1-nc_3000-schlogl'
mkdir -p $outdir
line=$(sed -n "$LINE_NUM"p $outdir/scan.txt)
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
