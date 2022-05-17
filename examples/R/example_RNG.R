library(parallel)
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


## ---------------------------------------------------
## Random numbers
## ---------------------------------------------------
# Depending on what parallel library is used one needs to be very careful 
# with generating random numbers- rnorm(), sample() and similar functions
# By default each core may generate the same set of random numbers
# mc* set of functions avoids doing this, but the results are not reproducible

# Here we use the example of calculating the value of pi

# Method 1: get a seed for each computation

estimate_pi <- function(seed){
    # set seed for reproducibility
    set.seed(seed)
    
    iterations=1000
    # generate the (x, y) points
    x <- runif(n = iterations, min = 0, max = 1)
    y <- runif(n = iterations, min = 0, max = 1)
    
    # calculate 
    sum_sq_xy <- sqrt(x^2 + y^2) 
    
    # see how many points are within circle
    index_within_circle <- which(sum_sq_xy <= 1)
    points_within_circle = length(index_within_circle)
    
    # estimate pi
    pi_est <- 4 * points_within_circle / iterations
    return(pi_est)
}

set.seed(42)
# Simple parallel application
# Creates a set of copies of R running in parallel and communicating over sockets
# The workers are most often running on the same host as the main process
cl <- makeCluster( ncores )
# Get 10 seeds. This will be a unique list.
seeds <- sample.int(n = 10)
# Or: seeds <- sample.int(100000,size=10)
y1 <- parLapply(cl, seeds, estimate_pi)
stopCluster(cl)
y1



# Method 2: Use a stream for each using L'Ecuyer-CMRG
cl <- makeCluster(ncores)
RNGkind("L'Ecuyer-CMRG")
set.seed(42)
seeds <- list(.Random.seed)
# Get parallel stream seeds for a total of 10 seeds
for (i in 2:10) 
   seeds[[i]] <- nextRNGStream(seeds[[i - 1]])

estimate_pi_v2 <- function(seed){
    # set seed for reproducibility
    .Random.seed <- seed
    
    iterations=1000
    # generate the (x, y) points
    x <- runif(n = iterations, min = 0, max = 1)
    y <- runif(n = iterations, min = 0, max = 1)
    
    # calculate 
    sum_sq_xy <- sqrt(x^2 + y^2) 
    
    # see how many points are within circle
    index_within_circle <- which(sum_sq_xy <= 1)
    points_within_circle = length(index_within_circle)
    
    # estimate pi
    pi_est <- 4 * points_within_circle / iterations
    return(pi_est)
}

y2 <- parLapply(cl, seeds, estimate_pi_v2)
stopCluster(cl)
y2


# Method 3: use the built-in function clusterSetRNGStream() to use L'Ecuyer and streams automatically.
cl <- makeCluster(4)
clusterSetRNGStream(cl, iseed = 42)
y3 <- parLapply(cl, 1:10, estimate_pi)
stopCluster(cl)
y3

