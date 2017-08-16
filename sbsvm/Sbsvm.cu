#include "org_sbsvm_Sbsvm.h"

#include <iostream>

#include <cuda.h>

#include "cptr.h"
#include "example.h"

static jclass ByteBuffer;
static jmethodID allocateDirect;

extern "C" {
/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    initialize
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_initialize
  (JNIEnv *env, jobject o)
{
  ByteBuffer = env->FindClass("java/nio/ByteBuffer");
  allocateDirect = env->GetStaticMethodID(ByteBuffer, "allocateDirect", "(I)Ljava/nio/ByteBuffer;");
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
 * Method:    loadModule
 * Signature: (Ljava/nio/ByteBuffer;)Ljava/nio/ByteBuffer;
 */
JNIEXPORT jobject JNICALL Java_org_sbsvm_Sbsvm_loadModule
  (JNIEnv *env, jobject o, jobject image)
{
  const void *pImage = env->GetDirectBufferAddress(image);
  CUmodule module;
  cuModuleLoadData(&module, pImage);
  jobject ret = env->CallStaticObjectMethod(ByteBuffer, allocateDirect, (jint)sizeof(CUmodule));
  CUmodule *pModule = reinterpret_cast<CUmodule*>(env->GetDirectBufferAddress(ret));
  *pModule = module;
  return ret;
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    getFunction
 * Signature: (Ljava/nio/ByteBuffer;Ljava/nio/ByteBuffer;)Ljava/nio/ByteBuffer;
 */
JNIEXPORT jobject JNICALL Java_org_sbsvm_Sbsvm_getFunction
  (JNIEnv *env, jobject o, jobject module, jobject name)
{
  CUmodule *pModule = reinterpret_cast<CUmodule*>(env->GetDirectBufferAddress(module));
  char *pName = reinterpret_cast<char*>(env->GetDirectBufferAddress(name));
  CUfunction func;
  std::cout << "0!!!!!!!!!!!!!!!!!" << std::endl;
  cuModuleGetFunction(&func, *pModule, pName);
  std::cout << "1!!!!!!!!!!!!!!!!!" << std::endl;
  jobject ret = env->CallStaticObjectMethod(ByteBuffer, allocateDirect, (jint)sizeof(CUfunction));
  CUfunction *pFunc = reinterpret_cast<CUfunction*>(env->GetDirectBufferAddress(ret));
  *pFunc = func;
  return ret;

}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    createStream
 * Signature: ()Ljava/nio/ByteBuffer;
 */
JNIEXPORT jobject JNICALL Java_org_sbsvm_Sbsvm_createStream
  (JNIEnv *env, jobject o)
{
  CUstream stream;
  cuStreamCreate(&stream, CU_STREAM_NON_BLOCKING);
  jobject ret = env->CallStaticObjectMethod(ByteBuffer, allocateDirect, (jint)sizeof(CUstream));
  CUstream *pStream = reinterpret_cast<CUstream*>(env->GetDirectBufferAddress(ret));
  *pStream = stream;
  return ret;
}

/*
 * Class:     org_sbsvm_Sbsvm
 * Method:    launchKernel
 * Signature: (Ljava/nio/ByteBuffer;JJJJJJJLjava/nio/ByteBuffer;)V
 */
JNIEXPORT void JNICALL Java_org_sbsvm_Sbsvm_launchKernel
  (JNIEnv *env, jobject o, jobject function, jlong gridDimX, jlong gridDimY, jlong gridDimZ, jlong blockDimX, jlong blockDimY, jlong blockDimZ, jlong sharedMemBytes, jobject stream)
{
  CUfunction *pFunc = reinterpret_cast<CUfunction*>(env->GetDirectBufferAddress(function));
  CUstream *pStream = reinterpret_cast<CUstream*>(env->GetDirectBufferAddress(stream));
  cuLaunchKernel(*pFunc, gridDimX, gridDimY, gridDimZ, blockDimX, blockDimY, blockDimZ, sharedMemBytes, *pStream, nullptr, nullptr);
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
