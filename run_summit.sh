#!/bin/bash


 modddule load cuda/10.1.243

 # using llvm
 module use /sw/summit/modulefiles/ums/stf010/Core
 module load llvm/12.0.0-20210125 
 
 # using xl
 #module load xl/16.1.1-10

 jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./t2g 256 512 1 1 10 

