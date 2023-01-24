#!/usr/bin/env RScript
library(dplyr)
library(UniProt.ws)

orthoGroups_species <- readRDS("orthogroups_pf_to_all_species.RDS")
taxons <- orthoGroups_species %>% 
  pull(taxon_clean) %>% 
  unique()

lookups <- function(hits, cols){
  keys_to_try <- c("Ensembl","UniProtKB", "Gene_Name")
  lookupres <- lapply(keys_to_try, function(key_type){
    try(suppressWarnings(AnnotationDbi::select(con,
                                               keytype = key_type,
                                               keys = hits$gene_id,
                                               columns = cols$cols_to_sel)),
        FALSE, outFile = "annotdbi_errors.txt")
  })
  idx <- sapply(lookupres, length) > 0
  
  if(any(idx)){
    print(glue::glue("Completed finding UniprotIDs for {taxon} {taxid}"))
    lookupres <- lookupres[idx] %>% 
      bind_rows()
    return(lookupres)
  }
}

#write.csv(taxons,"taxons_list.csv", row.names = FALSE)

for(taxon in taxons){
  print(taxon)
  hits <- orthoGroups_species %>% 
    filter(taxon_clean == taxon)
  avail <- availableUniprotSpecies(pattern=taxon)
  if(!nrow(avail) == 0){
    n <- nrow(avail)
    for (i in 1:n){
      found_name <- avail[i,"Official (scientific) name"]
      print(glue::glue("Supported Organisms {found_name}"))
      taxid <- avail[i,"Taxon Node"]
      print(paste0("The taxid is: ", taxid))
      
      con <- NULL
      try(con <- UniProt.ws(taxId=taxid), FALSE, outFile = "uniprot_errors.txt")
      con
      if(!is.null(con)){
        cols <- data.frame(cols_to_sel=columns(con)) %>%
          filter(grepl("UniProtKB|accession|gene_names|gene_synonym|xref_geneid|ortho|VEu|organism_name|organism_id",
                       cols_to_sel, ignore.case=TRUE))
        print(glue::glue("The number of genes searched: { nrow(hits) }"))
  
        if(nrow(hits) > 1e5){
          subsets <- unique(hits$taxon_name)
          lookupres <- lapply(subsets, function(subset){
            hits_subset <- hits %>% 
              filter(taxon_name == subset)
            ids <- lookups(hits_subset,cols)
            return(ids)
          }) %>% 
            bind_rows()
        }else{
          lookupres <- lookups(hits,cols)
        }
        # idx <- sapply(lookupres, length) > 0
        # if(any(idx)){
        #   print(glue::glue("Completed finding UniprotIDs for {taxon} {taxid}"))
        #   lookupres <- lookupres[idx] %>% 
        #     bind_rows()
        name <- paste(taxon,taxid,sep="-") %>%
          gsub("\\s","_", .)
        saveRDS(lookupres, file=paste0(name,"_uniprotIDs.RDS"))
        # }
      }
    }
  } else {
    print(glue::glue("The {taxon} is not found"))
  }
}