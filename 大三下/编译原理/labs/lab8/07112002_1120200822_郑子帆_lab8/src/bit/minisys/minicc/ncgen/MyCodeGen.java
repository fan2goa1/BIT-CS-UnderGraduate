package bit.minisys.minicc.ncgen;

import bit.minisys.minicc.MiniCCCfg;
import bit.minisys.minicc.internal.util.MiniCCUtil;
import bit.minisys.minicc.parser.ast.ASTNode;
import bit.minisys.minicc.pp.internal.S;
import org.python.modules._hashlib;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.channels.ConnectionPendingException;
import java.util.*;

// MyQuat类与BIT-MiniCC的Quat类的区别是MyQuat类的成员均为String类型，省略了在调用四元式过程中反复将ASTNode类型转化为Sting类型
class MyQuat {
	private String op;
	private String res;
	private String opnd1;
	private String opnd2;

	public MyQuat(String op, String res, String opnd1, String opnd2) {
		this.op = op;
		this.res = res;
		this.opnd1 = opnd1;
		this.opnd2 = opnd2;

	}
	public String getOp() {
		return op;
	}
	public String getOpnd1() {
		return opnd1;
	}
	public String getOpnd2() {
		return opnd2;
	}
	public String getRes() {
		return res;
	}
}
public class MyCodeGen implements IMiniCCCodeGen {

	public StringBuilder asmCode;
	public LinkedList<MyQuat> quatStr;    // 用于记录.ic.txt文件读入后得到的四元式
	public int scanIdx;					  // 用于记录当前扫描到的四元式的位置
	public String typeJnt;				  // 记录用于判断Jnt的类型 如jl jg等等
	public Stack<String> locVar;
	public Stack<String> argLists;
	public int nowMars_cnt;					// 记录printStr的条数
	public Map<String, String> invertIdf;	// 用于转化syntax error的变量名


	public MyCodeGen() {
		asmCode = new StringBuilder();
		quatStr = new LinkedList<>();
		scanIdx = 0;
		locVar = new Stack<>();
		argLists = new Stack<>();
		typeJnt = "";
		nowMars_cnt = 0;
		invertIdf = new HashMap<String, String>();
		invertIdf.put("c", "invc");
	}

	@Override
	public String run(String iFile, MiniCCCfg cfg) throws Exception {
		String oFile = MiniCCUtil.remove2Ext(iFile) + MiniCCCfg.MINICC_CODEGEN_OUTPUT_EXT;

		if (cfg.target.equals("mips")) {
			//TODO:
			return oFile;
		} else if (cfg.target.equals("riscv")) {
			//TODO:
			return oFile;
		}
		// 这里我们使用的是x86汇编，所以这里只实现了x86部分
		else if (cfg.target.equals("x86")) {
			// 先读入.ic.txt文件
			ArrayList<String> quatList = MiniCCUtil.readFile(iFile);
			for (String quat0 : quatList) {
//				System.out.println(quat0);
//				quat0 = quat0.substring(1, quat0.length());    // 删除四元式中的左、右括号
//				System.out.println(quat0);
				String[] elem = quat0.split(",");    // 根据","分隔开四元式的4个元素
				elem[0] = elem[0].substring(1, elem[0].length());
				elem[3] = elem[3].substring(0, elem[3].length()-1);
//				System.out.println(elem[0] +" " + elem[1] + " " + elem[2] + " " + elem[3]);

				// 同时将四元式中的%<id>换成tmp<id>
				for(int jj = 0; jj < 4; jj ++) {
					if(elem[jj].length() > 1 && elem[jj].charAt(0) == '%') {
						elem[jj] = "tmp" + elem[jj].substring(1, elem[jj].length());
 					}
					if(invertIdf.get(elem[jj]) != null) {
						elem[jj] = invertIdf.get(elem[jj]);
					}
				}
				MyQuat qquat = new MyQuat(elem[0], elem[3], elem[1], elem[2]);
				quatStr.add(qquat);
			}

			genMASMCode();
			try {
				FileWriter fileWriter = new FileWriter(new File(oFile));
				fileWriter.write(asmCode.toString());	// 创建.code.s的输出文件并将生成的asm代码写入其中
				fileWriter.close();
			} catch (IOException e) {
				e.printStackTrace();
			}

			System.out.println("7. Target code generation finished!");
			return oFile;
		}

		System.out.println("7. Target code generation finished!");

		return oFile;
	}

	// 生成masm32汇编的总控函数
	public void genMASMCode() {
		genHeader();
		System.out.println("Finished generating Header.");
		genData();
		System.out.println("Finished generating Data.");
		genOthers();
		System.out.println("Finished generating main code.");
	}

	// 用于生成masm32的头文件
	public void genHeader() {
		asmCode.append("""
			.386
			.model		flat,stdcall
			option		casemap:none
			include		windows.inc
			include		gdi32.inc
			include		masm32.inc
			include		kernel32.inc
			include		user32.inc
			include		winmm.inc
			includelib	gdi32.lib
			includelib  msvcrt.lib
			includelib	winmm.lib
			includelib	user32.lib
			includelib	kernel32.lib
			includelib	kernel32.lib
			
			scanf proto c : dword, :vararg
			printf proto c : dword, :vararg
			""");
	}

	public void genData() {
		asmCode.append("\n");
		asmCode.append("""
.data
scanFmt		db	'%d', 0
printIntFmt	db   '%d ', 0
printStrFmt db   '%s', 0
		""");

		int nowIdx = 0;	// 记录当前扫到的四元式的idx
		int Mars_cnt = 0;	// 记录输出的字符串作为全局变量的数量
		MyQuat nowQuat = quatStr.get(nowIdx);
		while(nowIdx < quatStr.size()) {
			String op = nowQuat.getOp(); String res = nowQuat.getRes();
			String opnd1 = nowQuat.getOpnd1(); String opnd2 = nowQuat.getOpnd2();

			if(op.equals("Arg") && opnd1.equals("Mars_PrintStr")) {	// 扫到用Mar_PrintStr输出字符串，存成全局变
				if(res.equals("\"\\n\"")) {	// 只有换行
					asmCode.append("Mars_PrintStr" + Mars_cnt).append(" db ").append("0ah, 0\n");
				}
				else if(res.contains("\\n")) {	// 包含换行
					res = res.replace("\\n", "");
					asmCode.append("Mars_PrintStr" + Mars_cnt).append(" db ").append(res).append(", 0ah, 0\n");
				}
				else {	// 输出内容没有换行
					asmCode.append("Mars_PrintStr" + Mars_cnt).append(" db ").append(res).append(", 0\n");
				}
				Mars_cnt ++;
			}
			nowIdx ++;
			if(nowIdx >= quatStr.size()) break;
			nowQuat = quatStr.get(nowIdx);
		}
		asmCode.append("\n");	// 换行
	}

	// 用于生成.code 部分
	public void genOthers() {
		asmCode.append(".code\n");
		scanIdx = 0;
		// 扫描函数声明，先定义临时变量
		MyQuat nowQuat = quatStr.get(scanIdx);
		while(scanIdx < quatStr.size()) {
			if (nowQuat.getOp().equals("Proc")) {    // 说明为函数声明，需要进行特殊处理
				locVar.clear();
				argLists.clear();
				genFuncCode();
			}
			scanIdx ++;
			if (scanIdx >= quatStr.size()) break;
			nowQuat = quatStr.get(scanIdx);
		}
	}

	public int calcArrSize(String opnd1) {
//		System.out.println(opnd1);
		return 1000;
	}

	public void genFuncCode() {
		// 先添加<funcname> proc <param1> ... 的函数声明语句
		MyQuat quat0 = quatStr.get(scanIdx);
		String funcName = quat0.getOpnd2();
		asmCode.append(funcName).append(" proc");

		scanIdx ++; if(scanIdx >= quatStr.size()) return;
		MyQuat quat1 = quatStr.get(scanIdx);
		while(quat1.getOp().equals("Param")) {
			String paramRes = quat1.getRes();
			asmCode.append(" ").append(paramRes).append(":dword");
			locVar.add(quat1.getRes());

			scanIdx ++; if(scanIdx >= quatStr.size()) break;
			quat1 = quatStr.get(scanIdx);
		}
		asmCode.append("\n");
		System.out.println("Function Declaration Finished.");

		// 将所有形如%id 的临时变量 或 局部变量定义成local的布局变量
		quat1 = quatStr.get(scanIdx);
		int tmpIdx = scanIdx;
		while(tmpIdx < quatStr.size()) {
			String op = quat1.getOp(); String res = quat1.getRes();
			String opnd1 = quat1.getOpnd1(); String opnd2 = quat1.getOpnd2();

			if(op.equals("Endp")) {	// 函数结束，退出
				break;
			}
			else if(res.equals("")) { // 没有新的临时变量，就继续扫
				tmpIdx ++;
				if(tmpIdx >= quatStr.size()) break;
				quat1 = quatStr.get(tmpIdx);
				continue;
			}
			else if(op.equals("Arr")) {
				if(locVar.search(res) == -1) {	// 数组没有被定义
					int totSize = calcArrSize(opnd1);
					String arrVar = res + "[" + totSize + "]";
					asmCode.append("local ").append(arrVar).append(":dword\n");
					locVar.add(arrVar);
				}
			}
			else if(op.equals("Var")
					|| (op.equals("Arg") && !opnd1.equals("Mars_PrintStr"))
					|| (res.length() >= 3 && res.substring(0, 3).equals("tmp"))) { // 相关变量定义 || tmp<id>的临时变量
				if(locVar.search(res) == -1) { // 还要特判不是数，如果是数不建local
					if(!Character.isDigit(res.charAt(0))) {
//						System.out.println(op + ", " + opnd1 + ", " + opnd2 + ", " + res);
						asmCode.append("local ").append(res).append(":dword\n");
						locVar.add(res);
					}
					else {	// 是数字
						String invertCon = "Con" + res;
						asmCode.append("local ").append(invertCon).append(":dword\n");
						locVar.add(invertCon);
						invertIdf.put(res, invertCon);
					}
				}
			}

			tmpIdx ++;
			if(tmpIdx >= quatStr.size()) break;
			quat1 = quatStr.get(tmpIdx);
		}
		System.out.println("Finished localing.");

		// 生成当前Func其他语句的汇编代码
		quat1 = quatStr.get(scanIdx);
		while(scanIdx < quatStr.size()) {
			String op = quat1.getOp(); String res = quat1.getRes();
			String opnd1 = quat1.getOpnd1(); String opnd2 = quat1.getOpnd2();

			if(op.equals("Endp")) { // 函数结束
				break;
			}

			if(op.equals("Label")) {
				asmCode.append(res).append(": \n");
			}
			else if(op.equals("Jmp")) {
				asmCode.append("Jmp ").append(res).append("\n");
			}
			else if(op.equals("Jnt")) {
				asmCode.append(typeJnt).append(" ").append(res).append("\n");
			}
			// 对于下列这些运算符，把opnd1移到eax，然后比较
			else if(op.equals(">") || op.equals("<") || op.equals(">=") ||
					op.equals("<=") || op.equals("==") || op.equals("!=")) {
				asmCode.append("mov eax, ").append(opnd1).append("\n");
				asmCode.append("cmp eax, ").append(opnd2).append("\n");

				if(op.equals(">")) typeJnt = "jle";
				else if(op.equals("<")) typeJnt = "jge";
				else if(op.equals(">=")) typeJnt = "jl";
				else if(op.equals("<=")) typeJnt = "jg";
				else if(op.equals("==")) typeJnt = "jne";
				else if(op.equals("!=")) typeJnt = "je";
			}
			else if(op.equals("ret")) {
				if(!res.equals("")) {	// 如果没有返回值则不用生成代码
					asmCode.append("mov eax, ").append(res).append("\n");
				}
			}
			else if(op.equals("+") || op.equals("-") || op.equals("*") ||
					op.equals("+=") || op.equals("-=") || op.equals("*=")) {
				asmCode.append("mov eax, ").append(opnd1).append("\n");

				if(op.equals("+") || op.equals("+=")) asmCode.append("add eax, ").append(opnd2).append("\n");
				else if(op.equals("-") || op.equals("-=")) asmCode.append("sub eax, ").append(opnd2).append("\n");
				else if(op.equals("*") ||op.equals("*=")) asmCode.append("imul eax, ").append(opnd2).append("\n");

				asmCode.append("mov ").append(res).append(", eax").append("\n");
			}
			else if(op.equals("/") || op.equals("%") || op.equals("/=") || op.equals("%=")) {
				asmCode.append("mov edx, 0\n");		// 清零
				asmCode.append("mov eax, ").append(opnd1).append("\n");
				asmCode.append("mov ebx, ").append(opnd2).append("\n");
				asmCode.append("div ebx\n");

				if(op.equals("/") || op.equals("/=")) {
					asmCode.append("mov ").append(res).append(", eax\n");
				}
				else {
					asmCode.append("mov ").append(res).append(", edx\n");
				}
			}
			else if(op.equals("++") || op.equals("--")) {
				asmCode.append("mov eax, ").append(res).append("\n");
				if(op.equals("++")) asmCode.append("inc eax\n");
				else if(op.equals("--")) asmCode.append("dec eax\n");
				asmCode.append("mov ").append(res).append(", eax\n");
			}
			else if(op.equals("=[]")) {
				asmCode.append("mov esi, ").append(opnd1).append("\n");
				asmCode.append("mov eax, ").append(opnd2).append("[4 * esi]").append("\n");
				asmCode.append("mov ").append(res).append(", eax\n");
			}
			else if(op.equals("[]=")) {
				asmCode.append("mov eax, ").append(opnd1).append("\n");
				asmCode.append("mov esi, ").append(opnd2).append("\n");
				asmCode.append("mov ").append(res).append("[4 * esi], eax\n");
			}
			else if(op.equals("=")) {
				MyQuat lastquat = quatStr.get(scanIdx - 1);
				String Lop = lastquat.getOp(), Lopnd1 = lastquat.getOpnd1();
				if(Lop.equals("Call") && Lopnd1.equals("Mars_GetInt")) { 	// 需要先通过地址取值
					asmCode.append("mov eax, ").append(opnd1).append("\n");
					asmCode.append("mov ").append(res).append(", eax\n");
				}
				else {
					asmCode.append("mov eax, ").append(opnd1).append("\n");
					asmCode.append("mov ").append(res).append(", eax\n");
				}
			}
			else if(op.equals("Arg") && !opnd1.equals("Mars_PrintStr")) {		// 非PrintStr函数调用的参数
				if(!Character.isDigit(res.charAt(0))) {	// 说明参数是一个标识符
					argLists.add(res);
				}
				else { 	// 说明参数是数字，用之前需要先把值装进去
					asmCode.append("mov ").append(invertIdf.get(res)).append(", ").append(res).append("\n");
					argLists.add(invertIdf.get(res));
				}
			}
			else if(op.equals("Call")) {	// 先特判输入输出函数，再处理一般函数
				if(opnd1.equals("Mars_GetInt")) {
					asmCode.append("invoke scanf, addr scanFmt, addr ").append(res).append("\n");
				}
				else if(opnd1.equals("Mars_PrintInt")) {
					String number = argLists.pop();
					asmCode.append("invoke printf, addr printIntFmt, ").append(number).append("\n");
				}
				else if(opnd1.equals("Mars_PrintStr")) {
					asmCode.append("invoke printf, addr Mars_PrintStr" + nowMars_cnt).append("\n");
					nowMars_cnt ++;
				}
				else {
					asmCode.append("invoke ").append(opnd1);
					while (!argLists.empty()) {
						String argu = argLists.pop();
						asmCode.append(", ").append(argu);
					}
					asmCode.append("\n");

					if (!res.equals("")) {	// 将函数得到的结果赋值过来
						asmCode.append("mov ").append(res).append(", eax\n");
					}
				}
			}

			// 取下一个四元式
			scanIdx ++;
			if(scanIdx >= quatStr.size()) break;
			quat1 = quatStr.get(scanIdx);
		}

		asmCode.append("ret\n");
		asmCode.append(funcName).append(" endp\n");
		if (funcName.equals("main")) asmCode.append("end main\n");
		asmCode.append("\n");
	}


}
