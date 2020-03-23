
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.txt"
}

data =  args[1]
path =  args[2] 


source ("/ddn/gs1/home/li11/ddnDrive/project2019/SEM/rscripts/helpScripts/SEM_util.R")
#source ("/ddn/gs1/home/li11/ddnDrive/project2019/SEM/shinyRelated/NewBootstrap/helpers.R")

#source ("/ddn/gs1/home/li11/project2019/SEM/rscripts/helpScripts/SEM_util.R")
#source ("/ddn/gs1/home/li11/project2019/SEM/shinyRelated/NewBootstrap/helpers.R")

load(data)
cat(path)
cat("\n")

#dim(dat)
#rownames(dat) 
#colnames(dat)
#head(dat)
#order(rownames(dat))

calculate.random.p.vals(path, dat)


