#include <iostream>
#include <algorithm>
#include <numeric>
#include <vector>
#include <stdlib.h>

extern "C"
{
  void mean_impl (double *mean, const double * const data, size_t n);
  void std_impl (double *std, const double *mean, const double * const data, size_t n);
}

std::pair<double, double>
mean_std (const double *rng, const size_t n)
{
  std::pair<double, double> result;
  mean_impl (&result.first, rng, n);
  std_impl (&result.second, &result.first, rng, n);
  return result;
}

#define ASSERT(__pred)                             \
  if (!(__pred))                                   \
  {                                                \
    throw std::runtime_error (#__pred " failed");  \
  }

int main ()
{
  constexpr size_t n = 0x100;
  auto *p = static_cast<double *> (aligned_alloc (32, n * sizeof (double)));
  ASSERT (((uintptr_t)p & 0x1f) == 0);
  std::iota (p, p + n, 0.0);
  const auto pair = mean_std (p, n);

  std::cout << double(n) << " " << pair.first << " " << pair.second << std::endl;
}
