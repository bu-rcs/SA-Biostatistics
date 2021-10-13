# get summary statistics of all columns in the iris dataset
summarystats<-summary(iris)

# write the summary statistics into a csv file
write.csv(summarystats,file="iris_summarystats.csv"),quote=F,row.names=F)
