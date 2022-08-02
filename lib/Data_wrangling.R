#-------------Useful commands for data wrangling dplyr---------
#This doc includes useful commands for data wrangling using dplyr

#-------------Params-------------------------------------------
#In yaml od Rmarkdown specify thee params to the folders
params:
  data: "../data"
results: "../res"
lib: "../lib"

#Example: file = file.path(params$rds, "dds_mixeddesign.rds"))

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

##--select
#* select(): select the columns
#* select(everything()): selects all the columns
#* select(last_col()): select last column
#* select(!last_col()): select everything but last column
#### "!" is always used for exclusion 

##--starts_with, ends_with and contains
#* select(starts_with("m")): selecting all columns that start with "m"
#* select(contains("m)): select columns that contain "m"

##--selecting columns of specific type
#select(where(is.character))

##--combining selection
#*select(where(is.character) & contains("l")) : & meet both requirements
#*select(where(is.character) | contains("l")) :| meet one of the requirements

## Renaming
#* rename(): renaming column name

#* filter(): select the rows
#* mutate(): modify data, add column
#* group_by(): group one or more variable
#* ungroup(): removes the grouping
#* summarise(): 
#* bind_rows(): binding multiple data frames by row
#* bind_cols():
#* inner_join(x,y, by= "key"): 
PAS <- PAS |> 
  mutate(gene_id = gsub("\\.[1-9]*$", "", gene_id)) |> 
  select(-gene_name) |>
  mutate_at(vars(-("gene_id")), ceiling) |> #rounding the counts
  rename_with(~str_replace(., pattern = "AK19_", replacement = "")) |>
  column_to_rownames(var = "gene_id")

#------------Removing NA from rows----------------------------

df %>% filter(!is.na(col1)) 
# or 
PAS_immune <- PAS_immune |>
  drop_na()