#include <sys/time.h>
#include <sys/resource.h>
#include <stdint.h>

int64_t get_rss(){
  struct rusage rsrc ;
  int status = getrusage(RUSAGE_SELF, &rsrc) ;
  return rsrc.ru_maxrss ;
}
