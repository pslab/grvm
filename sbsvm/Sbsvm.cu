#include "org_sbsvm_Sbsvm.h"

#include "cptr.h"
#include "example.h"

extern "C" {
/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    initialize
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_initialize
  (JNIEnv *env, jobject o)
{
  cpu_pointer::initialize();
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    finalize
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_finalize
  (JNIEnv *env, jobject o)
{
  cpu_pointer::finalize();
}


/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    clear
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_clear
  (JNIEnv *env, jobject o)
{
  cpu_pointer::clear_cache();
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    run
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_run
  (JNIEnv *env, jobject o)
{
  cpu_pointer::run_handler();
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    test
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_test
  (JNIEnv *env, jobject o)
{
  float (*A)[MAT_SIZE] = new float[MAT_SIZE][MAT_SIZE];
  float (*B)[MAT_SIZE] = new float[MAT_SIZE][MAT_SIZE];
  float (*C)[MAT_SIZE] = new float[MAT_SIZE][MAT_SIZE];
  dim3 block(32, 8);
  dim3 grid(MAT_SIZE/block.x+(MAT_SIZE%block.x!=0), MAT_SIZE/block.y+(MAT_SIZE%block.y!=0));
  gpu_client<<<grid, block>>>(A, B, C);
}

} // extern "C"
