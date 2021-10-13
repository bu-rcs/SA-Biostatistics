#!/bin/bash -l
#
# Run this file using 'qsub qsub_arrayjob.sh'
#
# All lines starting with "#$" are SGE qsub commands
#
# If you want to omit some of the qsub commands, just remove "$" so that this line becomes a comment

# Specify which project
#$ -P projectname

# To use buy-in nodes of the project
#$ -l buyin

# Submit an array job
#$ -t 1-5

# Give this job a name
#$ -N jobname

# Join standard output and error to a single file
#$ -j y

# Send an email when job ends running or has problem
#$ -m eas

# Whom to send the email to, by default the email will be sent to person who submitted this job, specifing email below will overwrite the default
#$ -M aaa@bu.edu

#Request 24 hours for the job, by default this will be 12 hours. Request more hours only if you need more hours, because the longer time you specify, the less nodes will be available for you.
#$ -l h_rt=24:00:00


# Now let's keep track of some information just in case anything goes wrong

echo "=========================================================="
echo "Starting on       : $(date)"
echo "Running on node   : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID    : $JOB_ID"
echo "Current job name  : $JOB_NAME"
echo "Task index number : $TASK_ID"
echo "=========================================================="

# We recommend specify R version here, since the default R version will change.
module load R/4.0.5

# Here SGE_TASK_ID refers to the arrays you specified at line 7, which will be from 1 to 5, so this job will have 5 array jobs submitted simultaneously
R --vanilla --i=${SGE_TASK_ID} < Rcode_arrayjob.R

echo "=========================================================="
echo "Finished on       : $(date)"
echo "=========================================================="
