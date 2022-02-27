#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <math.h>
#include <omp.h>
#include <limits.h>

// Input data distribution
#define RANDOM_SIZED_TASKS
//#define INCREASING_SIZED_TASKS
#define LOWERLT 128

// Application problem
#define MM
#define N 500
#define MAXWORK 10
#define MAX_LOOP 10

// Scheduling strategies, unset all to use the compact schedue
//#define SCHED_DYNAMIC
//#define SCHED_RANDOM
#define SCHED_ADAPTIVE



inline unsigned
gpu_scheduler_roundrobin(unsigned *occupancies, int taskID, int ngpus)
{
  return taskID%ngpus;
}




inline unsigned
gpu_scheduler_dynamic_ad(unsigned long *gpuLoad, int ngpus, int taskWeight)
{
  short looking = 1;
  unsigned chosen;
  while (looking) {
    unsigned occ_i;
    unsigned long load;
    unsigned long min_load = ULLONG_MAX;
    for (unsigned i = 0; i < ngpus; i++) {
      #pragma omp atomic read
      load = gpuLoad[i];
      if ( load < min_load ){
        min_load = load;
        occ_i = i;
      }
    }
        chosen = occ_i;
#pragma omp atomic
        gpuLoad[chosen] += taskWeight;
        looking = 0;
        break;
  }
  return chosen;
}



// This version avoids all CPU threads finding the same GPU greedily (and therefore overloading that GPU) 

inline unsigned
gpu_scheduler_dynamic_ad2(unsigned long *gpuLoad, int ngpus, int taskWeight)
{
  short looking = 1;
  unsigned chosen;
  while (looking) {
    unsigned long load;
    unsigned long min_load = ULLONG_MAX;
	  
 #pragma omp critical 
  {
    for (unsigned i = 0; i < ngpus; i++) {
      load = gpuLoad[i];
      if ( load < min_load ){
        min_load = load;
        chosen = i;
      }
    } 
        gpuLoad[chosen] += taskWeight;
  } 
        looking = 0;
        break;
  }
  return chosen;
}

inline unsigned
gpu_scheduler_random(unsigned *occupancies, int ngpus)
{
  const unsigned chosen = rand() % ngpus;
#pragma omp atomic
  occupancies[chosen]++;
  return chosen;
}




inline unsigned gpu_scheduler_dyn_occ2(unsigned *occupancies, int ngpus)
{
 int chosen = -1;
 while (chosen == -1) {
 for (unsigned i = 0; i < ngpus; i++)
  {
   #pragma omp critical 
    {
       if (occupancies[i] == 0) {
             occupancies[i]++;
	   chosen = i;
      }
    }
    if (chosen > -1) break;
	 
   }
  return chosen;
}

inline unsigned
gpu_scheduler_dynamic_occ(unsigned *occupancies, int ngpus)
{
  short looking = 1;
  unsigned chosen;
  while (looking) {
    for (unsigned i = 0; i < ngpus; i++) {
      // But really, this should be a single atomic compare-and-swap
      unsigned occ_i;
      #pragma omp atomic read
      occ_i = occupancies[i];
      if (occ_i == 0) {
        chosen = i;
#pragma omp atomic
        occupancies[chosen]++;
        looking = 0;
        break;
      }
    }
  }
  return chosen;
}

int main(int argc, char* argv[])
{
	
  int success[N];
  const int ndevs = omp_get_num_devices();
  assert(ndevs > 0);
  printf("There are %d GPUs\n", ndevs);
  int *devices = (int *) calloc(ndevs, sizeof(*devices));
  double start_iterations, end_iterations;
  unsigned *lastGPU = NULL;
   
  unsigned *occupancies  = (unsigned *) calloc(ndevs, sizeof(*occupancies));
  unsigned long *gpuLoad  = (unsigned long*) calloc(ndevs, sizeof(*gpuLoad));

  int timestep = 0;
  int probSize = MAXWORK; 
  int numThreads = 1;
  int numTasks = N;
  int gsz = 1;
  int numloop = MAX_LOOP;	
	
  
  srand((unsigned) time(NULL));
  if(argc <= 1) 
    {
      printf("Usage bench_works [pSize] [numTasks][gsz]  [numThreads]\n" );
      printf("Using default parameters\n" );
      probSize = MAXWORK; 
#pragma omp parallel 
      numThreads = omp_get_num_threads();
      numTasks = N;
      gsz = 1;
    }
  else
    {
      if (argc > 1)
	probSize = atoi(argv[1]);
      if (argc > 2)
	numTasks = atoi(argv[2]);
      if (argc > 3)
	gsz = atoi(argv[3]);
      if (argc > 4)
	numloop = atoi(argv[4]);
    } 
  printf("bench_works [pSize=%d] [numTasks=%d] [gsz=%d] [numThreads=%d] \n", probSize, numTasks, gsz, numThreads);
  int arrSize = probSize*probSize;
  
  float* a = (float*)malloc(arrSize*sizeof(float));
  float* b = (float*)malloc(arrSize*sizeof(float)); 
  float* c = (float*)malloc(arrSize*sizeof(float));
  
  int* taskWork = (int*)malloc(sizeof(int)*numTasks);
  int* taskWorkSquared = (int*)malloc(sizeof(int)*numTasks);
  // initialize 

  for(int i = 0; i< arrSize; i++) 
    {
      a[i] = 3.0;
      b[i] = 2.0;
      c[i] = 0.0;
    }

  int ctaskwork;
  for (int i =0 ; i < numTasks; i++)
    {
#ifdef RANDOM_SIZED_TASKS
      //ctaskwork =  LOWERLT + (rand()%(probSize-LOWERLT) -1); 
      ctaskwork =  1 + (rand()%probSize -1);
      //ctaskwork = probSize; 
#else 
#ifdef INCREASING_SIZED_TASKS
      ctaskwork =  1 + (rand()%probSize -1); 
      //ctaskwork =  LOWERLT + (rand()%(probSize-LOWERLT) -1); 
#endif
#endif 
#ifdef INCREASING_SIZED_TASKS
       int j = i-1;
      while((j>=0) && (ctaskwork < taskWork[j]))
        {
	    taskWork[j+1] = taskWork[j];
	    taskWorkSquared[j+1] = taskWorkSquared[j];
	    j--;
	}
      taskWork[j+1] = ctaskwork;
      taskWorkSquared[j+1] = ctaskwork*ctaskwork;

#else
      taskWork[i] = ctaskwork;
      taskWorkSquared[i] = ctaskwork*ctaskwork;
#endif
   }
  double cpu_time = 0.0;
  double task_time = 0.0;


#pragma omp parallel
      {
#pragma omp single
	{
	  start_iterations =  omp_get_wtime();
#pragma omp taskloop shared(success) grainsize(gsz)
	  for (int i = 0; i < numTasks; i++) {
            if(taskWork[i] > probSize) taskWork[i] = probSize;
               const int NN = taskWork[i];
               const int NNsq = NN*NN;
	       const int nl = rand()%numloop+1;
#if defined(SCHED_ADAPTIVE)
	    const int dev = gpu_scheduler_dynamic_ad(gpuLoad, ndevs, NNsq );	    
#elif defined(SCHED_RANDOM)
	    const int dev = gpu_scheduler_random(occupancies, ndevs);
#elif defined(SCHED_DYNAMIC)
	    const int dev = gpu_scheduler_dynamic_occ(occupancies, ndevs);
#else
	    const int dev = 0;
#endif

#pragma omp task depend(out: success[i])
	    {
	      success[i] = 0;
	    }
#pragma omp task depend(inout:success[i]) 
	    {
#pragma omp target device(dev) map(to: nl)\
  map(to: a[0:arrSize], b[0:arrSize], c[0:arrSize]) map(tofrom: success[i:1], devices[dev:1], taskWork[i:1]) nowait
	      {
		devices[dev]++;
		const int NN = taskWork[i];
#ifdef MM
   	       for(int l = 0; l < nl; l++)
	           for (int i = 0; i < NN; i++)
        	   for (int j = 0; j < NN; j++)
           	   for (int k = 0; k < NN; k++)
               		c[i * NN + j] += a[i * NN + k] * b[k * NN + j];
		success[i] = 1;
#endif
	      } // end target
	    } // end task 
#pragma omp task depend(in: success[i])
	    {
#pragma omp atomic
#if defined(SCHED_ADAPTIVE)
              gpuLoad[dev] -= NNsq;
#else	      
	      occupancies[dev]--; 
#endif
	    } 
	    } // end taskloop
	    } // end of single

#pragma omp master
	      {
	      int check = 0;
	      end_iterations =  omp_get_wtime(); 
	      int lastFail = 0;
	      for (int i = 0; i < numTasks; i++) {
	           check += success[i];
	           if(success[i] == 0) lastFail = i;
	      }    
	      if (check != numTasks) {
	          printf("failed! LastFailed %d \n", lastFail);
              }    
	      printf("Statistics for %d iterations:\n", numTasks);
	      printf("Loop took %f seconds\n", end_iterations - start_iterations);
	      printf("Total number of CPU threads=%d\n", omp_get_num_threads());
 	      }
	} // end parallel
	      free(a);
	      free(b); 
	      free(c);
	      free(devices);
	      return 0;
} // end main
