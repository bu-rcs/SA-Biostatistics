library(parallel)


summary <- function(x,y=1) {
  c( mean = mean(x, na.rm = T)/y, 
     median = median(x, na.rm =T)/y, 
     sd = sd(x, na.rm = T))/y
}


iris2<-iris[,1:4]


## - apply
## - lapply, sapply, vapply
## - mapply: apply a function to multiple list or vector arguments
## - tapply: apply a function over a ragged array
## - rapply: recursively apply a function to a list

##-----------------------
## apply
##-----------------------
res.apply <- apply( iris2, 2, summary  )
res.apply
class(res.apply)
dim(res.apply)

##-----------------------
## lapply
##-----------------------
res.lapply <- lapply( iris2, summary  )
res.lapply
class(res.lapply)


##-----------------------
## sapply
##-----------------------
res.sapply <- sapply( iris2, summary  )
res.sapply
class(res.sapply)


##-----------------------
## mapply: apply a function to multiple list of vector arguments
##         is a multivariate version of sapply
##-----------------------
res.mapply <- mapply( summary, iris2, c(1:ncol(iris2))  )
res.mapply
class(res.mapply)




## ------------------------------------
## Introduction to Parallel package 
## ------------------------------------


# detect the number of CPU cores on the current host
# This function returns the total number of cores present on the computer/node
# If you use the SCC, this function is not aware of the number of cores requested 
# for the job!
detectCores(logical = FALSE) # number of physical CPU cores
detectCores(logical = TRUE)  # number of logical (hyperthreaded) CPU cores 
# For parallelization logical = FALSE should be used

# Determine the number of cores requested by the job
( ncores <- as.numeric( Sys.getenv("NSLOTS") ) )
if ( is.na(ncores) ) ncores <- 4


# Simple parallel application
# Creates a set of copies of R running in parallel and communicating over sockets
# The workers are most often running on the same host as the main process
cl <- makeCluster( ncores )



## --------------------------------------------------------
## parLapply, parSapply, parApply, parRapply, parCapply
## --------------------------------------------------------

#----------- lapply -----------
res.lapply <- lapply(c(2:ncol(iris2)), 
               FUN = function(i) { 
                 mod <- lm(Sepal.Length ~ ., data = iris[ -i,]);
                 mod$coefficients
               } )
  

#----------- parLapply  -----------
res.cl <- parLapply ( cl,
                          X = c(2:ncol(iris2)), 
                          fun = function(i) { 
                            mod <- lm(Sepal.Length ~ ., data = iris[ -i,]);
                          mod$coefficients
                        }) 

stopCluster(cl)


#--------------------------------------

# -----parRapply and parCapply ---------
# are parallel row and column apply functions for a matrix x; 
# they may be slightly more efficient than parApply 
# but do less post-processing of the result. 

# Create a matrix with 4 columns and 10 rows
mat <- matrix(1:40, nrow=10)
val <- 80

cl <- makeCluster( ncores  )
clusterExport(cl, "val")
res <- parRapply(cl, mat, function(x) ( sum(x) < val ) )
stopCluster(cl)


## ---------------------------------------------------
## Package foreach
## ---------------------------------------------------

# using regular for loop
dat_list <- split(iris, iris$Species)
mod_list <- list()

for(i in 1:length(dat_list)) {
  mod_list[[i]] <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat_list[[i]])
}


# use foreach
library(foreach)
mod_list2 <- foreach(dat=dat_list) %do% {
  lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat)
}

# Load parallel backend
library(doParallel)
registerDoParallel(ncores)

mod_list3 <- foreach(dat=dat_list) %dopar% {
  lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat)
}

stopImplicitCluster()

# or
cl <- makeCluster(ncores) # from library(parallel)
registerDoParallel(cl)         # from library(doParallel)

mod_list3 <- foreach(dat=dat_list) %dopar% {
  lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=dat)
}
stopCluster(cl)




#---------------------------------
# doMC
#---------------------------------
library(foreach)
library(doMC)
library(doRNG)

registerDoMC(ncores)

#set seed for parallel computation
registerDoRNG()
set.seed(42)

# 10 iterations
res <- foreach(i=1:10) %dopar% {
  iris_select<-iris[sample(1:nrow(iris),100),] # randomly select 100 rows from iris dataset
  lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data=iris_select)$coefficients
}
res

