#!/bin/bash -l

# Specify which project
#$ -P projectname

# Submit an array job
#$ -t 1-5

# Give this job a name
#$ -N jobname

# Join standard output and error to a single file
#$ -j y

# Send an email when job ends running or has problem
# -m eas

# Whom to send the email to
# -M buid@bu.edu

#Request 100 hours for the job
#$ -l h_rt=100:00:00

# Now let's keep track of some information just in case anything goes wrong

echo "=========================================================="
echo "Starting on       : $(date)"
echo "Running on node   : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID    : $JOB_ID"
echo "Current job name  : $JOB_NAME"
echo "Task index number : $TASK_ID"
echo "=========================================================="

module load R

# Here SGE_TASK_ID refers to the arrays you specified at line 7, which will be from 1 to 5, so this job will have 10 array jobs submitted simultaneously
R --vanilla --i=${SGE_TASK_ID} < Rcode_arrayjob.R

echo "=========================================================="
echo "Finished on       : $(date)"
echo "=========================================================="
