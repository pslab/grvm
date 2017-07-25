
OUT = test

CXXFLAGS = -std=c++11 -O2
CUFLAGS = -gencode arch=compute_52,code=sm_52 --relocatable-device-code=true

CUSRC = main.cu cpupointer.cu memcpy.cu 
INCLUDES = memcpy.h cpupointer.h cptr.h

all : $(OUT)

debug : CXXFLAGS += -DDEBUG -g -lineinfo
debug : $(OUT)

$(OUT) : $(CUSRC) $(INCLUDES)
	nvcc $(CUFLAGS) $(CXXFLAGS) -o $@ $(CUSRC)

clean :
	rm $(OUT)
