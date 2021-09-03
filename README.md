# bio-stochastic-load-imbalance
Benchmarking script for multi-GPU, task-to-gpu(task2gpu) scheduling strategies applicable for bio-stochastic load imbalacing applications. It includes 3 different task2gpu scheduling approaches,
* dynamic_rand - An asynchronous method, it choses GPU randomly.
* dynamic_occ - A synchronous method works based on the occupancy of the GPU. 
* dynamic_ad - An asynchronous method works based on the load of the GPU. 

## Build
Can use the sample script compile_summit.sh if you are using SUMMIT, using llvm clang or IBM xl compiler. 
```zsh
# using llvm
module use /sw/summit/modulefiles/ums/stf010/Core
module load cuda llvm/12.0.0-20210125
clang++ -Ofast -std=c++17 -fopenmp  -fopenmp-targets=nvptx64-nvida-cuda --cuda-path=${OLCF_CUDA_ROOT} task2gpu_bench.cpp -o t2g  
``` 
## Run
Can use the sample script run_summit.sh in the ineractive mode if you are using SUMMIT.
```zsh 
# using llvm
jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./t2g 256 512 1 1 10  
``` 
