package org.sbsvm;

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
    public native void test(); 
}
