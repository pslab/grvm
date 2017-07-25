.PHONY: all clean test

JSRC = $(shell find ptxcmp/src -name *.java)
JSRC += $(shell find examples -name *.java)
CPS= lib/jikesrvm3.1.4.jar

NINC= sbsvm/memcpy.h sbsvm/cpupointer.h sbsvm/cptr.h
NSRC=sbsvm/memcpy.cu sbsvm/cpupointer.cu sbsvm/main.cu
CFLAGS = -std=c++11 -O2
CFLAGS += -Isbsvm
CFLAGS += -gencode arch=compute_52,code=sm_52
CFLAGS += --relocatable-device-code=true
CFLAGS += --compiler-options -fPIC

all: bin/jitptx.jar bin/libgrvm.so

bin/jitptx.jar: $(JSRC) Makefile
	mkdir -p classes bin
	javac $(JFLAGS) -d classes -classpath $(CPS) -sourcepath ptxcmp/src:examples $(JSRC)
	jar cf $@ -C bin .

bin/libgrvm.so: $(NSRC) $(NINC) Makefile
	mkdir -p bin
	nvcc -shared $(CFLAGS) -o $@ $(NSRC)

clean:
	rm -rf bin/jitptx.jar classes

test:
	PTXJIT_VERBOSE=1 rvm -Djava.library.path=lib -classpath bin/jitptx.jar DMMStream

