#!/bin/bash

destination="/active/kappe_s/kappe/Gigliola/2022.04_jsmi26_PF_LiverStage/"

rsync -av --exclude .DS_Store figures $destination 
rsync -av --exclude .DS_Store samples $destination 
rsync -av --exclude .DS_Store presentations $destination 
rsync -av --exclude .DS_Store *.Rmd $destination/src

rsync -av --exclude .DS_Store raw_counts $destination
rsync -av --exclude .DS_Store qc_data $destination 
rsync -av --exclude .DS_Store results $destination
rsync -av --exclude .DS_Store resources $destination 

