run_DESeq2 <- function(counts, meta, model, contrast, key) {
  
  DESeq2 <- lapply(model, function(design) {
    
    dds <- DESeqDataSetFromMatrix(countData = counts,
                                  colData = meta,
                                  design = design)
    
    dds <- dds[rowSums(counts(dds)) >= 10, ]
    dds <- DESeq(dds)
    dds <- results(dds, filterFun = ihw, contrast = contrast)
    dds <- as.data.frame(dds) |>
      rownames_to_column(var = "gene_id") |>
      left_join(key) |>
      relocate(gene_name, .after = gene_id) |>
      as_tibble() |>
      arrange(padj)
    
  })
  
names(DESeq2) <- unlist(model)
return(DESeq2)
}