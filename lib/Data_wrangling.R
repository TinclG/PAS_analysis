#-------------Useful commands for data wrangling dplyr---------
#-------------Params-------------------------------------------
params:
  data: "../data"
results: "../res"
lib: "../lib"

params$data 
### example paste0(params$data,"/metadata_PASeq.csv")

#-------------Importing the file-------------------------------
#csv 
anno <- read.csv2(paste0(params$data,"/metadata_PASeq.csv"),
                  sep= ";")
#tables
PAS<-read_tsv(paste0(params$data, "/PAS_counts.tsv"))

#-------------Useful dplyr functions with examples-------------
PAS <- PAS |> 
  mutate(gene_id = gsub("\\.[1-9]*$", "", gene_id)) |> 
  select(-gene_name) |>
  mutate_at(vars(-("gene_id")), ceiling) |> #rounding the counts
  rename_with(~str_replace(., pattern = "AK19_", replacement = "")) |>
  column_to_rownames(var = "gene_id") |>
  select(-columnname) #removing a column


#------------Removing duplicated features----------------------

mat <- mat[!duplicated(mat$gene_name),] 