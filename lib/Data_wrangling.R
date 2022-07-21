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
PAS <- read_tsv(paste0(params$data, "/PAS_counts.tsv"))

#importing several files
alldata <- lapply(list.files(pattern = '*.csv'), read.csv2)
#comment: list.files lists all the files in the current directory. 
#comment: iterate over all with read.csv2 
#result: a list with dataframes 

#binding all data frames into one big df
subject_all <- bind_rows(alldata, .id = 'columnname') 

#-------------Reshaping the df--------------------------------
#source: https://katherinemwood.github.io/post/wrangling/

#wide to long

long_df <- gather(df, 
     key = "test", 
     value = "score", control, col1, col2)
#change the control, col1, column 2 into test and score (we gathered the columns control, col1, col2 and assigned the to score)
  
#long to wide

wide_df <- spread(long_df, test, score)

#-------------Useful dplyr functions with examples------------
PAS <- PAS |> 
  mutate(gene_id = gsub("\\.[1-9]*$", "", gene_id)) |> 
  select(-gene_name) |>
  mutate_at(vars(-("gene_id")), ceiling) |> #rounding the counts
  rename_with(~str_replace(., pattern = "AK19_", replacement = "")) |>
  column_to_rownames(var = "gene_id")