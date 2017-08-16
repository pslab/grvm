/*
 * JITPTX Project.
 * 
 * @author Byeongcheol Lee
 */
package org.ptx.dispatch;

import org.sbsvm.Sbsvm;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;

import org.jikesrvm.classloader.NormalMethod;

import org.ptx.Util;
import org.ptx.ir.PIR;
import static org.ptx.Util.*;

public class PTXCompiledMethod {
	final NormalMethod method;
	final byte[] ptxAssemblyCode;
	final String entryPointName;
	
	PTXCompiledMethod(PIR pir) {
		method = pir.getMethod();
		byte[] code = null;
		try {
			code = emit(pir);
		} catch (Exception e) {
			e.printStackTrace();
		}
		ptxAssemblyCode = code;
		entryPointName = pir.getEntryPointName();
	}

	private byte[] emit(PIR pir) throws Exception {
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		PrintWriter bw = new PrintWriter(new OutputStreamWriter(os)); 
		pir.emitCode(bw);
		bw.flush();
		os.write('\0');
		os.close();
		String str = os.toString();
		final Charset ASCII_CHARSET = Charset.forName("US-ASCII");
		return str.getBytes(ASCII_CHARSET);
	}

	public void dumpPTXAssembly() {
		printf("PTX Assembly of %s\n", method.toString());
		System.out.write(ptxAssemblyCode, 0, ptxAssemblyCode.length-1);
	}

        ByteBuffer module;
        ByteBuffer func;

	public void invoke(Object...args) {
	        if(module == null) {
		    load();
		    System.out.println("module loaded");
		}
	        ByteBuffer stream = Sbsvm.getInstance().createStream();
		Sbsvm.getInstance().launchKernel(func, 1, 1, 1, 1, 1, 1, 0, stream);
		System.out.println("kernel launched");
		Sbsvm.getInstance().run();
				  
	        //Sbsvm.getInstance().test();
		//Sbsvm.getInstance().run();
		
		//Util._assert(false, "TBI");
	}

        private void load() {
	        ByteBuffer buf = ByteBuffer.allocateDirect(ptxAssemblyCode.length);
	        buf.put(ptxAssemblyCode);
	        module = Sbsvm.getInstance().loadModule(buf);
		final Charset ASCII_CHARSET = Charset.forName("US-ASCII");
		byte[] name = entryPointName.getBytes(ASCII_CHARSET);
	        buf = ByteBuffer.allocateDirect(name.length+1);
	        buf.put(name);
		func = Sbsvm.getInstance().getFunction(module, buf);
        }
}
