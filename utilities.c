#include <sys/time.h>
#include <sys/resource.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>


static uint32_t my_seed = 0xBEBEFADA ;

int64_t get_rss(){
  struct rusage rsrc ;
  int status = getrusage(RUSAGE_SELF, &rsrc) ;
  return rsrc.ru_maxrss ;
}

uint32_t my_rand_i(){
  my_seed = 1664525 * my_seed + 1013904223 ;
  return my_seed ;         // [0 , 0xFFFFFFFF] range
}

float my_rand_f(){          // linear distribution
//   union { uint32_t u ; float f ; } uf ;
//   uf.u = my_rand_i() ;
//   uf.u &= 0x7FFFFF ;        // keep lower 23 bits
//   uf.u |= (127 << 23) ;     // [1.0 , 2.0) range
//   return (uf.f - 1.0f) ;    // [0.0 , 1.0) range
  float r = drand48() ;
  return r ;
}

float my_rand_fexp(){       // exponential distribution
  union { uint32_t u ; float f ; } uf ;
  uf.u = my_rand_i() ;
  uf.u &= 0x3FFFFFFF ;      // keep lower 30 bits
  return uf.f * .5f ;       // [0.0 , 1.0) range
}
// C Program to shuffle a given array

// A utility function to swap to integers
static void swap (int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

// A utility function to print an array
// void printArray (int arr[], int n)
// {
//     for (int i = 0; i < n; i++)
//         printf("%d ", arr[i]);
//     printf("\n");
// }

// A function to generate a random permutation of arr[]
void randomize ( int arr[], int n )
{
    // Use a different seed value so that we don't get same
    // result each time we run this program
//     srand ( time(NULL) );
    srand ( 123456 );

    // Start from the last element and swap one by one. We don't
    // need to run for the first element that's why i > 0
    for (int i = n-1; i > 0; i--)
    {
        // Pick a random index from 0 to i
        int j = rand() % (i+1);

        // Swap arr[i] with the element at random index
        swap(&arr[i], &arr[j]);
    }
}

// Driver program to test above function.
// int main()
// {
//     int arr[] = {1, 2, 3, 4, 5, 6, 7, 8};
//     int n = sizeof(arr)/ sizeof(arr[0]);
//     randomize (arr, n);
//     printArray(arr, n);
// 
//     return 0;
// }
