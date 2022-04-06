#!/bin/bash -l
#
# Run this file using 'qsub qsub_regular.sh'
#
# All lines starting with "#$" are SGE qsub commands
#
# If you want to omit some of the qsub commands, just remove "$" so that this line becomes a comment


# Specify which project
#$ -P projectname

# To use buy-in nodes of the project
#$ -l buyin

# Request multiple cores (if needed by the job).
# The extra ### comments out this line so this job will
# default to 1 core
### #$ -pe omp 4

# Give this job a name
#$ -N jobname

# Join standard output and error to a single file
#$ -j y

# Send an email when job ends running or has problem
#$ -m eas

# Whom to send the email to, by default the email will be sent to person who submitted this job, specifing email below will overwrite the default
#$ -M aaa@bu.edu

# As an example of setting the time for the job set this job to 12 hours. This is the default
# amount of time. Request more hours only if you need more hours as jobs >12 hours will wait longer
# in the queue.
#$ -l h_rt=12:00:00

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

R --vanilla < Rcode_regular.R

echo "=========================================================="
echo "Finished on       : $(date)"
echo "=========================================================="
