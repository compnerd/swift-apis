
#ifndef CTensorFlow_h
#define CTensorFlow_h

#include <stdint.h>

#include <tensorflow/c/c_api.h>
#include <tensorflow/c/eager/c_api.h>

#if defined(__cplusplus)
extern "C" {
#endif

extern void
InitTensorFlowRuntime(unsigned char enable_debug_logging, int verbose_level);

struct TF_Status;

void *
swift_tfc_CreateIntTensor(int32_t num_dims, int64_t *dims, int64_t *vals,
                          int32_t dtype, struct TF_Status *status);

void *
swift_tfc_CreateFloatTensor(int32_t num_dims, int64_t *dims, float *vals,
                            struct TF_Status *status);

void *
swift_tfc_CreateScalarStringTensor(char *val, int32_t valLen,
                                   struct TF_Status *status);

#if defined(__cplusplus)
}
#endif

#endif
