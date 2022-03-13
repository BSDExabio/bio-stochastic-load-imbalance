 
 module use /sw/summit/modulefiles/ums/stf010/Core
 module load llvm/14.0.0-latest cuda

tsz=4096
nt=1024
nc=10

 export OMP_NUM_THREADS=1
i=0
while [ $i -le 5 ]
do
    gs=1
    while [ $gs -le 64 ]
    do
        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU  ./bin/bench_static_rr ${tsz} ${nt} ${gs} ${nc} >> ./res/static_rr_gs${gs}_g6c1.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_random ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_random_gs${gs}_g6c1.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_occ ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_occ_gs${gs}_g6c1.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_occ2 ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_occ2_gs${gs}_g6c1.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_ad ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_ad_gs${gs}_g6c1.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 1 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_ad2 ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_ad2_gs${gs}_g6c1.txt
    gs=`expr $gs \* 4`
    done
    i=`expr $i + 1`
done


export OMP_NUM_THREADS=42
i=0
while [ $i -le 5 ]
do
    gs=1
    while [ $gs -le 64 ]
    do
        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU  ./bin/bench_static_rr ${tsz} ${nt} ${gs} ${nc} >> ./res/static_rr_gs${gs}_g6c42.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_random ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_random_gs${gs}_g6c42.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_occ ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_occ_gs${gs}_g6c42.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_occ2 ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_occ2_gs${gs}_g6c42.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_ad ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_ad_gs${gs}_g6c42.txt

        jsrun --smpiargs="-disable_gpu_hooks" -n 1 -r 1 -a 1 -g 6 -c 42 -d packed -b rs -l CPU-CPU ./bin/bench_dynamic_ad2 ${tsz} ${nt} ${gs} ${nc} >> ./res/dynamic_ad2_gs${gs}_g6c42.txt
    gs=`expr $gs \* 4`
    done

    i=`expr $i + 1`
done
