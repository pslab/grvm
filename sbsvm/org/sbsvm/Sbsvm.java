package org.sbsvm;

import java.nio.*;

public class Sbsvm {
    private static Sbsvm instance;

    static {
	System.loadLibrary("sbsvm");
	instance = new Sbsvm();
    }

    private Sbsvm() {
	initialize();
    }
    
    public static Sbsvm getInstance() {
	return instance;
    }

    private native void initialize();
    @Override
    protected native void finalize() throws Throwable;
    public native void clear();
    public native void run();
    public native ByteBuffer loadModule(ByteBuffer image);
    public native ByteBuffer getFunction(ByteBuffer module, ByteBuffer name);
    public native ByteBuffer createStream();
    public native void launchKernel(ByteBuffer function, long gridDimX, long gridDimY, long gridDimZ, long blockDimX, long blockDimY, long blockDimZ, long sharedMemBytes, ByteBuffer stream);
    public native void test(); 
}
