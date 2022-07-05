PAS_design<-function(x, PAS = PAS, anno = anno){
  dds<-DESeqDataSetFromMatrix(countData = PAS, 
                              colData = anno, 
                              design = x)
  keep<-rowSums(counts(dds)) >=10
  dds<-dds[keep,]
  
  return(dds)
}