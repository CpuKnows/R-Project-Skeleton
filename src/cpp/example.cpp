/*
 * asdf.cpp
 */
#include <Rcpp.h>
using namespace Rcpp;

#ifndef _USE_MATH_DEFINES
#define _USE_MATH_DEFINES
#endif
#include <cmath>

using namespace std;



// [[Rcpp::export]]
NumericVector foo(NumericVector abc)
{
    int n = abc.size();
    NumericVector out(n);

    for(int i=0; i < n; ++i) {
        out[i] = abc[i];
    }

    return out;
}
