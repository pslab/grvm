package org.sbsvm;

public class Sbsvm {
    private static Sbsvm instance = new Sbsvm();
    
    public static Sbsvm getInstance() {
	return instance;
    }

    public void dotest() {
	test();
    }

    public void dorun() {
	run();
    }

    private native static void init();
    private native static void clear();
    private native static void fin();
    private native static void run();
    private native static void test();
    
    static {
	System.loadLibrary("libsbsvm");
    }

    private Sbsvm() {
	init();
    }

    @Override
    protected void finalize() throws Throwable {
	fin();
    }
}
