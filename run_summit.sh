#!/bin/bash


 module load cuda/10.1.243

 # using llvm
 module use /sw/summit/modulefiles/ums/stf010/Core
 module load llvm/12.0.0-20210125 
 
 # using xl
 #module load xl/16.1.1-10


  export OMP_NUM_THREADS=1 
  jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU nsys profile -o profad_stat-thd1.qdrep ./bench_static_rr 256 256 16 10
    export OMP_NUM_THREADS=42
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU nsys profile -o profad_stat-thd42.qdrep ./bench_static_rr 256 256 16 10

      export OMP_NUM_THREADS=1 
  jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU nsys profile -o profad_dynad-thd1.qdrep ./bench_dynamic_ad 256 256 16 10
    export OMP_NUM_THREADS=42
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU nsys profile -o profad_dynad-thd42.qdrep ./bench_dynamic_ad 256 256 16 10


    export OMP_NUM_THREADS=1 
  jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU nsys profile -o profad_dynad2-thd1.qdrep ./bench_dynamic_ad2 256 256 16 10
    export OMP_NUM_THREADS=42
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU nsys profile -o profad_dynad2-thd42.qdrep ./bench_dynamic_ad2 256 256 16 10



 export OMP_NUM_THREADS=1 
i=0
while [ $i -le 5 ]
do
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU  ./bench_static_rr 4096 1024 1 10 >> gs1_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 4 10 >> gs4_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 16 10 >> gs16_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 64 10 >> gs64_g6c1.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 1 10 >> gs1_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 4 10 >> gs4_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 16 10 >> gs16_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 64 10 >> gs64_g6c1.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 1 10 >> gs1_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 4 10 >> gs4_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 16 10 >> gs16_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 64 10 >> gs64_g6c1.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 1 10 >> gs1_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 4 10 >> gs4_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 16 10 >> gs16_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 64 10 >> gs64_g6c1.txt
    
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 1 10 >> gs1_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 4 10 >> gs4_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 16 10 >> gs16_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 64 10 >> gs64_g6c1.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 1 10 >> gs1_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 4 10 >> gs4_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 16 10 >> gs16_g6c1.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 64 10 >> gs64_g6c1.txt
    
    i=`expr $i + 1`
done


export OMP_NUM_THREADS=42 
i=0
while [ $i -le 5 ]
do
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 1 10 >> gs1_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 4 10 >> gs4_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 16 10 >> gs16_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_static_rr 4096 1024 64 10 >> gs64_g6c42.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 1 10 >> gs1_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 4 10 >> gs4_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 16 10 >> gs16_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_random 4096 1024 64 10 >> gs64_g6c42.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 1 10 >> gs1_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 4 10 >> gs4_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 16 10 >> gs16_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ 4096 1024 64 10 >> gs64_g6c42.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 1 10 >> gs1_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 4 10 >> gs4_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 16 10 >> gs16_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_occ2 4096 1024 64 10 >> gs64_g6c42.txt
    
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 1 10 >> gs1_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 4 10 >> gs4_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 16 10 >> gs16_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad 4096 1024 64 10 >> gs64_g6c42.txt

    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 1 10 >> gs1_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 4 10 >> gs4_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 16 10 >> gs16_g6c42.txt
    jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bench_dynamic_ad2 4096 1024 64 10 >> gs64_g6c42.txt
    
    i=`expr $i + 1`
done

#export OMP_NUM_THREADS=1
# jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./t2g-rr 256 512 1 10


 
# export OMP_NUM_THREADS=42
# jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./t2g 256 512 1 10
