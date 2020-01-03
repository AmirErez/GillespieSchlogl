#!/bin/bash
#SBATCH --array=1-124
# #SBATCH --array=1-248
#SBATCH -o logs/onecell_quench_%A_%a.out
# #SBATCH -p donia
#SBATCH -N 1 # node count
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH --mem=3000
#SBATCH --mail-type=end
#SBATCH --mail-user=aerez@princeton.edu

#outdir='quench_1cell'
#outdir='quench_NS'
#outdir='quench_all_h_v2'
#outdir='only_one_dir'
#outdir='only_one_dir_v2'
#outdir='only_one_dir_nc3600_v2'
outdir='only_one_dir_nc10K'

mkdir -p $outdir

#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p quenches.txt)
#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p quenches_all_h_v2.txt)
#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p only_one_dir.txt)
#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p only_theta.txt)
#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p only_h.txt)
#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p both_th_h.txt)
#line=$(sed -n "$SLURM_ARRAY_TASK_ID"p diag_corr.txt)
line=$(sed -n "$SLURM_ARRAY_TASK_ID"p diag_anticorr.txt)


theta_i=$(echo "$line" | cut -d " " -f 1)
theta_f=$(echo "$line" | cut -d " " -f 2)
h_i=$(echo "$line" | cut -d " " -f 3)
h_f=$(echo "$line" | cut -d " " -f 4)
outfile="thi=${theta_i}__thf=${theta_f}__hi=${h_i}__hf=${h_f}.mat"
outfile="$outdir/$outfile"

matlab -r "GenerateQuenchData1cell($theta_i, $theta_f, $h_i, $h_f, '$outfile') ; quit();"
