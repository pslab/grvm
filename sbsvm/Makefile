
OUT = libsbsvm.so

CXXFLAGS = -std=c++11 -O2
CUFLAGS = --machine 32 -D_FORCE_INLINES -gencode arch=compute_35,code=sm_35 -gencode arch=compute_52,code=sm_52 --relocatable-device-code=true

CUSRC = cpupointer.cu memcpy.cu 
INCLUDES = memcpy.h cpupointer.h cptr.h

all : $(OUT)

debug : CXXFLAGS += -DDEBUG -g -lineinfo
debug : $(OUT)
debug : example	

Sbsvm.class : org/sbsvm/Sbsvm.java
	javac -source 6 -target 6 $<

org_sbsvm_Sbsvm.h : Sbsvm.class
	javah -jni org.sbsvm.Sbsvm

$(OUT) : $(CUSRC) $(INCLUDES) Sbsvm.cu org_sbsvm_Sbsvm.h
	nvcc --shared --compiler-options '-fPIC' $(CUFLAGS) $(CXXFLAGS) -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -o $@ $(CUSRC) Sbsvm.cu

clean :
	rm $(OUT) example org/sbsvm/Sbsvm.class org_sbsvm_Sbsvm.h Test.class

example : example.cu $(CUSRC) $(INCLUDES)
	nvcc $(CUFLAGS) $(CXXFLAGS) -o $@ example.cu $(CUSRC)

Test.class: Test.java
	javac -source 6 -target 6 $<

test : example Test.class
	./example
	rvm Test
