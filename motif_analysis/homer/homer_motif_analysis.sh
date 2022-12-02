#!/bin/bash


# Set-up environment
ml homer
#PATH="$HOME/opt/homer/bin:$PATH"
PROJDIR="/active/taylor_s/people/jsmi26/RSC/kappe_s_2022.04_PF_LiverStage/homer"
FILES=$(find $PROJDIR -type f -name "*.csv")

# Data Locations
# genes_csv="/active/taylor_s/people/jsmi26/RSC/kappe_s_2022.04_PF_LiverStage/homer/day2/Day2_Heps_Pf_vs_sporozorite_combat-seq_corrected_upregulated.csv"
# genes_csv=$(echo "$FILES" | sed -n "$PBS_ARRAY_INDEX"p)
genes_csv=$1
results_dir=$(basename $(dirname "$genes_csv"))
outdir="$PROJDIR/$results_dir"

# output standard out as log files
log=$(basename $genes_csv)
log=${log%.csv}

# Run HOMER motif analysis with built-in database and JASPAR motifs
echo "Finding Motifs for $genes_csv"
mkdir -p "$outdir/results_homer_db"

findMotifs.pl $genes_csv Pf3D7_promoters "$outdir/results_homer_db" -start -1000 -end 0 -p 4 2> ${log}_homer_db.out

echo "complete"
