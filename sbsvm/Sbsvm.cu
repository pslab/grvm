#include "org_sbsvm_Sbsvm.h"

#include "cptr.h"

#define MAT_SIZE (1*1024ul)

__global__ void gpu_client(float (*A)[MAT_SIZE], float (*B)[MAT_SIZE], float (*C)[MAT_SIZE])
{
  const int j = blockIdx.x * blockDim.x + threadIdx.x;
  const int i = blockIdx.y * blockDim.y + threadIdx.y;

  CPtr<float> a = A[i];
  CPtr<float> b = &B[0][j];
  CPtr<float> c = &C[i][j];

  if (i<MAT_SIZE && j<MAT_SIZE) {
    float result = 0;
    for (size_t x=0; x<MAT_SIZE; ++x) {
      float fa = a.read();
      float fb = b.read();
      result += fa * fb;
      ++a;
      B+=MAT_SIZE;
    }
    c.write(result);
  }
}

extern "C" {

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    init
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_init
  (JNIEnv *, jclass)
{
  cpu_pointer::initialize();
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    clear
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_clear
  (JNIEnv *, jclass)
{
  cpu_pointer::clear_cache();
}


/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    fin
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_fin
  (JNIEnv *, jclass)
{
  cpu_pointer::finalize();
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    run
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_run
  (JNIEnv *, jclass)
{
  cpu_pointer::run_handler();
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    test
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_test
  (JNIEnv *, jclass)
{
  float (*A)[MAT_SIZE] = new float[MAT_SIZE][MAT_SIZE];
  float (*B)[MAT_SIZE] = new float[MAT_SIZE][MAT_SIZE];
  float (*C)[MAT_SIZE] = new float[MAT_SIZE][MAT_SIZE];
  dim3 block(32, 8);
  dim3 grid(MAT_SIZE/block.x+(MAT_SIZE%block.x!=0), MAT_SIZE/block.y+(MAT_SIZE%block.y!=0));
  gpu_client<<<grid, block>>>(A, B, C);
}

} // extern "C"
