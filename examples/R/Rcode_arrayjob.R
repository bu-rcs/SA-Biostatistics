library(R.utils)

args <- cmdArgs()
cat("User command-line arguments used when invoking R:\n")
str(args)

# Retrieve command line argument 'n', e.g. '-chr 13' or '--chr=13'
i <- cmdArg("i", 1L)

# Alternatively, instead of a command line arg you could
# read the task ID from the environment in R
# i <- as.integer(Sys.getenv("SGE_TASK_ID"))

# get summary statistics of the ith column of the iris dataset
summarystats<-summary(iris[,i])

# write the summary statistics of each column to a separate file, indexed by column number
write.csv(as.array(summarystats),file=paste0("iris_summarystats_",i,".csv"),quote=F,row.names=F)

