#!/bin/bash

set -eou pipefail

# Set-up environment
PATH="$HOME/opt/homer/bin:$PATH"

# data locations
PROJDIR="/active/taylor_s/people/jsmi26/CP-Bioinformed/kappe_s_2022.04_PF_LiverStage/"
FASTA="$PROJDIR/species_genomes/plasmoDB/PlasmoDB-58_Pfalciparum3D7_Genome.fasta"
GTF="$PROJDIR/species_genomes/plasmoDB/PlasmoDB-58_Pfalciparum3D7.gtf"

# Create Pf custom genome DBs
loadGenome.pl -force -name "PF3D7" -org null -fasta $FASTA -gtf $GTF -promoters "Pf3D7_promoters" -id custom 2> PF3D7.out

# loadGenome.pl -name alf -org null -fasta ALFgenome.fasta -gtf ALFgenes.gtf