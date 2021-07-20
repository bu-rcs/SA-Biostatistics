#!/bin/bash -l
#
# Run this file using 'qsub qsub_regular.sh'
#
# All lines starting with "#$" are SGE qsub commands
#

# Specify which project
#$ -P projectname

# Specify nodes
#$ -q nodename1,nodename2

# multiple slots
#$ -pe omp 4

# Run on the current working directory
#$ -cwd

# Give this job a name
#$ -N jobname

# Join standard output and error to a single file
#$ -j y

# Send an email when job ends running or has problem
#$ -m eas

# Whom to send the email to
#$ -M buid@bu.edu

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
R --vanilla < Rcode_regular.R

echo "=========================================================="
echo "Finished on       : $(date)"
echo "=========================================================="
