##==================================================================================
##  SEM_util.R
##  Author: Jianying Li
##  Comment: it was originally designed for handling SEM downstream analysis
##==================================================================================

##============================
##  SEM related functions
##============================


#		gettingPval (mod, dt, varOfInterest = 2)
  #				mod - a SEM model set up
  #				dt  -	of course a dataset 
  #       default varOfInterest = 2
  # extracting the p-value from an SEM model




##=========================
##  util functions here
##=========================

gettingPval <- function (mod, dt, varOfInterest = 2)
{
  require(lavaan)
  mod.fit <- sem (mod, data = dt)
  z.test <- mod.fit@ParTable$est[varOfInterest]/mod.fit@ParTable$se[varOfInterest]
  return (2*(1-pnorm(abs(z.test))))
}


plotPvalText <- function (pvalResults, title)
{
  color = rep ("green", length(pvalResults[,2]))
  color[which( pvalResults[,1] %in%  head(pvalResults[ order(as.numeric(pvalResults[,2])),1],10))] = "red" 
  color [(which(as.numeric(pvalResults[,2]) > 0.05))] = "black"
  
  plot(-log(as.numeric(pvalResults[,2])), ylab  = "Negative LogPvalue", 
       main = title, type = 'n')
  text(-log(as.numeric(pvalResults[,2])), pvalResults[,1], cex = 0.7, col = color)
}

plotPvalTextDown <- function (pvalResults, title)
{
  pvalResults = SEM.improvment
  title = "GATA2 activity significance in SEM model"
  
}
  

runBootstrap <- function (dt, dat)
{
  require(lavaan)
  require(doParallel)
  number.of.workers <- detectCores() 
  
  ##==================================
  ##    Getting mean for each gene
  ##==================================
  cl <- makeCluster(number.of.workers - 1)
  registerDoParallel(cl)
  collapsedArrays <- NULL
  collapsedArrays <- foreach (i = 1: dim(dt)[1],
                              .combine = 'rbind' , .export ="sem") %dopar% {
                                temp.dat <- cbind(dat[,3], t(dt[i,]),dat[,14])
                                colnames(temp.dat) <- c("SOX17", "GATA2_act", "PGR_act")
                                mod <- 'SOX17 ~ GATA2_act + PGR_act'
                                mod.fit <- sem (mod, data=temp.dat )
                                z.test <- mod.fit@ParTable$est[1]/mod.fit@ParTable$se[1]
                                p.gata2 <- 2*(1-pnorm(abs(z.test)))
                                z.test <- mod.fit@ParTable$est[2]/mod.fit@ParTable$se[2]
                                p.pgr <- 2*(1-pnorm(abs(z.test)))
                                c(p.gata2,p.pgr)
                              }
  stopCluster(cl)
  return (collapsedArrays)
}



#calculate.p.vals <- function (filePath, dat)
#{
#  random.files <- list.files(path = filePath, pattern = "Random_")
#  for (f in random.files)
#  {
#    name = gsub (" ", "_", gsub ("Random_", "", gsub(".csv", "", f)))
#    out.file = paste (filePath, name, "_random_pvalues.txt", sep="")
#    in.file = paste (filePath, f, sep="")
#    dt <- read.csv(in.file)[,-1]
#    neg.pvalues <- runBootstrap (dt, dat)
#    colnames(neg.pvalues ) <- c("GATA2", "PGR")
#    write.table(neg.pvalues, file = out.file, sep="\t", col.names=NA)
#  }
#}

##==================================================
##  Functions to test significance
##==================================================


##=========================================================================
##  First, calculate random p-values from bootstrap with/without replacement
##=========================================================================
calculate.random.p.vals <- function (filePath, dat)
{
  random.files <- list.files(path = filePath, pattern = "Random_")
  for (f in random.files)
  {
    name = gsub (" ", "_", gsub ("Random_", "", gsub(".csv", "", f)))
    ##  replacing a space with an underscore
    ##  for a cleaner file name!!
    
    out.file = paste (filePath, name, "_random_pvalues.txt", sep="")
    in.file = paste (filePath, f, sep="")
    dt <- read.csv(in.file)[,-1]
    neg.pvalues <- runBootstrap (dt, dat)
    colnames(neg.pvalues ) <- c("GATA2", "PGR")
    write.table(neg.pvalues, file = out.file, sep="\t", col.names=NA)
  }
}

##===========================================================
##  Secondly, calculate actual p-values from the shrunked gene list
##===========================================================
calculate.p.vals <- function (filePath, dat)

{
  random.files <-list.files(path = filePath, pattern = "Random_*")
  for (f in random.files)
  {
    name1 = gsub("Random_", "", gsub(".csv", "", f))
    root = sapply(strsplit(name1,"_"), `[`, 1)
    name = gsub (" ", "_", gsub ("Random_", "", gsub(".csv", "", f)))
    
    out.file = paste (filePath, name, "_pval.txt", sep="")
    dt <- read.csv(paste(filePath, root, ".csv", sep=""))
    temp.dat <- cbind(dat[,3], t(dt),dat[,14])
    colnames(temp.dat) <- c("SOX17", "GATA2_act", "PGR_act")
    mod <- 'SOX17 ~ GATA2_act + PGR_act'
    mod.fit <- sem (mod, data=temp.dat )
    z.test <- mod.fit@ParTable$est[1]/mod.fit@ParTable$se[1]
    p.gata2 <- 2*(1-pnorm(abs(z.test)))
    z.test <- mod.fit@ParTable$est[2]/mod.fit@ParTable$se[2]
    p.pgr <- 2*(1-pnorm(abs(z.test)))
    neg.pvalues <- as.data.frame(cbind(p.gata2,p.pgr))
    colnames(neg.pvalues ) <- c("GATA2", "PGR")
    write.table(neg.pvalues, file = out.file, sep="\t", col.names=NA)
  }
}


##======================================
##  In the end, calculate the index
##======================================


calculate.index <- function (p.val.path , withReplacement.random.p.path , withoutReplacement.random.p.path, dat )
  
{
  #p.val.path <-  "X:/project2019/SEM/shinyRelated/testNewBootstrapResults/EliminationWithoutReplacement/"
  #withReplacement.random.p.path <- "X:/project2019/SEM/shinyRelated/testNewBootstrapResults/EliminationWithReplacement/"
  #withoutReplacement.random.p.path <- "X:/project2019/SEM/shinyRelated/testNewBootstrapResults/EliminationWithoutReplacement/"
  
  index.results <- c()
  f.in <- list.files(pattern = "_pval.txt", path = p.val.path )
  for (f in f.in)
  {
    name = gsub("_pval.txt", "", f)
    root = strsplit (name, "_")[[1]][1]
    cnt  = strsplit (name, "_")[[1]][2]
    actualPval  = paste (p.val.path , name, "_pval.txt", sep="")
    oldBoostrap = paste (withoutReplacement.random.p.path, name,  "_random_pvalues.txt", sep="")
    newBoostrap = paste (withReplacement.random.p.path , name,  "_random_pvalues.txt", sep="")
    actualP = read.table (actualPval, header=TRUE)[,-1][1]
    oldPs   = read.table (oldBoostrap , header=TRUE)[,-1][1]
    newPs   = read.table (newBoostrap , header=TRUE)[,-1][1]
    pval.dt <- cbind (newPs, oldPs)
    colnames(pval.dt) = c("WithReplacement", "WithoutReplacement")
    non.param.test <- non.parametric.test(pval.dt, actualP)
    temp = cbind(root, non.param.test, cnt, actualP, mean(oldPs$GATA2), mean(newPs$GATA2))
    colnames(temp) = c("Molecule", "Index", "OverlapGene", "GATA2_pval", "mean_wo_replacement_pvals", "mean_w_replacement_pvals")
    index.results = rbind (index.results, temp)
  }
  return (index.results)
}


non.parametric.test <- function (dat, actualP, originalP = 0.0271)
{
  count = 0
  denominator = 0 
  if (actualP  >  originalP)
  {
    for (i in dat[which(dat[,1] < as.numeric(actualP)), 1])
    {
      if (i < originalP){
        count = count + 1
      }
    }
    denominator = length(which(dat[,2] < originalP))
  }else{
    for (i in dat[which(dat[,1] > as.numeric(actualP)), 1])
    {
      if (i > originalP){
        
        count = count + 1
      }
    }
    denominator = length(which(dat[,2] > originalP))
  }
  return(min(count/denominator, 1))
}



