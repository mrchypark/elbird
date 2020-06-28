#include <Rcpp.h>

#include "core/KiwiHeader.h"
// [[Rcpp::depends(kiwi)]]

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector row_max(NumericMatrix m) {
  int nrow = m.nrow();
  NumericVector max(nrow);
  for (int i = 0; i < nrow; i++)
    // Get row i with m(i, _).
    max[i] = Rcpp::max( m(i, _) );
  return max;
}
