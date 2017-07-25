/*
 * JITPTX Project.
 * 
 * @author Byeongcheol Lee
 */
package org.ptx.dispatch;

import java.io.*;

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
		return os.toByteArray();
	}

	public void dumpPTXAssembly() {
		printf("PTX Assembly of %s\n", method.toString());
		System.out.write(ptxAssemblyCode, 0, ptxAssemblyCode.length-1);
	}

	public void invoke(Object...args) {
		Util._assert(false, "TBI");
	}
}
