library(R.utils)

args <- cmdArgs()
cat("User command-line arguments used when invoking R:\n")
str(args)

# Retrieve command line argument 'n', e.g. '-chr 13' or '--chr=13'
snpnumber <- cmdArg("snpnumber", 1L)
printf("Argument SNP No.=%d\n", snpnumber)

