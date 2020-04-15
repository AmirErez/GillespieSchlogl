#!/bin/bash
# #SBATCH --array=1-2000
#SBATCH --array=1-1000
# #SBATCH --array=1-1
#SBATCH -o logs/twocell_scan_hx_hy_theta_offset_%A_%a.out
# #SBATCH -p donia
#SBATCH -N 1 # node count
#SBATCH -c 1
# #SBATCH -t 23:00:00
#SBATCH -t 4:00:00
#SBATCH --mem=16000
# #SBATCH --mem=32000
#SBATCH --mail-type=end
#SBATCH --mail-user=aerez@princeton.edu

OFFSET=22000
LINE_NUM=$(echo "$SLURM_ARRAY_TASK_ID + $OFFSET" | bc)
# line=$(sed -n "$LINE_NUM"p scan_hx_hy_theta_offset.txt)
# line=$(sed -n "$LINE_NUM"p scan_hx_hy_theta_offset_part3.txt)
line=$(sed -n "$LINE_NUM"p scan_hx_hy_theta_offset_part4.txt)

echo "Offset $OFFSET ; Line $LINE_NUM"

outdir='scan_hx_hy_theta_offset-schlogl'
#outdir='scan_hx_hy_theta_offset-hill'
mkdir -p $outdir


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
