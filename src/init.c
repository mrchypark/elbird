// #include <R.h>
// #include <Rinternals.h>
// #include "elbird.h"
// #include <R_ext/Visibility.h>
//
// static const R_CallMethodDef CallEntries[] = {
//   {"kiwi_version_", (DL_FUNC) &kiwi_version_, 0},
//   {"kiwi_error_", (DL_FUNC) &kiwi_version_, 0},
//   {"kiwi_clear_error_", (DL_FUNC) &kiwi_version_, 0},
//   {"kiwi_init_", (DL_FUNC) &kiwi_version_, 3},
//   {"kiwi_analyze_", (DL_FUNC) &kiwi_version_, 4},
//   {NULL, NULL, 0}
// };
//
// attribute_visible void R_init_elbird(DllInfo* dll) {
//   R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
//   R_useDynamicSymbols(dll, FALSE);
//   R_forceSymbols(dll, TRUE);
// }
