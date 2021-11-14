#!/bin/bash
#SBATCH --nodes 8
#SBATCH --ntasks-per-node 1
#SBATCH -t 00:01:00

mpirun ./a.out
