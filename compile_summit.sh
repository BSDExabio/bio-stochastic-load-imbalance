#!/bin/bash


 module load cuda/10.1.243

 # using llvm
 module use /sw/summit/modulefiles/ums/stf010/Core
 module load llvm/12.0.0-20210125 
 clang++ -Ofast -std=c++14 -fopenmp  -fopenmp-targets=nvptx64-nvida-cuda --cuda-path=${OLCF_CUDA_ROOT} ./task2gpu_bench.cpp -o t2g
 
 # using xl
 #module load xl/16.1.1-10
 #xlc -std=c++17 -qsmp=omp -qoffload ./task2gpu_bench.cpp -o t2g


