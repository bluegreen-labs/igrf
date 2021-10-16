#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <Rmath.h>
#include <R_ext/Rdynload.h>

// Fortran code
void F77_NAME(igrf13)(
    int *isv,
    double *date,
    int *itype,
    double *alt,
    double *colat,
    double *elong,
    double *out
  );

// C wrapper
extern SEXP c_igrf13_f(
    SEXP isv,
    SEXP date,
    SEXP itype,
    SEXP alt,
    SEXP colat,
    SEXP elong
  ){

  // output
  //SEXP x = PROTECT(allocVector(REALSXP, 1));
  //SEXP y = PROTECT(allocVector(REALSXP, 1));
  //SEXP z = PROTECT(allocVector(REALSXP, 1));
  //SEXP f = PROTECT(allocVector(REALSXP, 1));

  SEXP out = PROTECT( allocMatrix(REALSXP, 1, 4) );

  // Fortran call
  F77_CALL(igrf13)(
     INTEGER(isv),
     REAL(date),
     INTEGER(itype),
     REAL(alt),
     REAL(colat),
     REAL(elong),
     REAL(out)
    );

  // output list
  //SEXP out_list = PROTECT(allocVector(VECSXP, 4));
  //SET_VECTOR_ELT(out, 0, x);
  //SET_VECTOR_ELT(out, 1, y);
  //SET_VECTOR_ELT(out, 2, z);
  //SET_VECTOR_ELT(out, 3, f);

  // Output the data
  UNPROTECT(1);
  return(out);
}

static const R_CallMethodDef CallEntries[] = {
  {"c_igrf13_f",   (DL_FUNC) &c_igrf13_f,   6},
  {NULL,         NULL,                0}
};

void R_init_swiftr(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_RegisterCCallable("igrf", "c_igrf13_f",  (DL_FUNC) &c_igrf13_f);
}
