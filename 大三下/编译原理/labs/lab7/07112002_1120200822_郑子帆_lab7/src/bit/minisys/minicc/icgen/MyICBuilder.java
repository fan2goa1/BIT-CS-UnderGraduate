package bit.minisys.minicc.icgen;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import bit.minisys.minicc.parser.ast.*;

// 根据Example扩写
public class MyICBuilder implements ASTVisitor{

	private Map<ASTNode, ASTNode> map;				// 使用map存储子节点的返回值，key对应子节点，value对应返回值，value目前类别包括ASTIdentifier,ASTIntegerConstant,TemportaryValue...
	private List<Quat> quats;						// 生成的四元式列表
	private Integer tmpId;							// 临时变量编号
	private Map<String, String>	funcRetType;					// 用于记录每个函数的返回类型
	private Map<String, ASTNode> labelTable;					// 记录直接跳转的Label的编号
	public Integer ForId;		// For循环编号
	public Integer jmpId;		// 直接跳转的编号
	public Integer IfId;		// If的编号
	public MyICBuilder() {
		map = new HashMap<ASTNode, ASTNode>();		// 存储AST节点之间的关系<a, b> a为b的child
		quats = new LinkedList<Quat>();
		funcRetType = new HashMap<String, String>();
		labelTable = new HashMap<String, ASTNode>();
		tmpId = 0;
		ForId = 0;
		IfId = 0;
		jmpId = 0;
	}
	public List<Quat> getQuats() {
		return quats;
	}

	@Override
	public void visit(ASTCompilationUnit program) throws Exception {
		for (ASTNode node : program.items) {
			if(node instanceof ASTFunctionDefine)
				visit((ASTFunctionDefine)node);
			else if (node instanceof ASTDeclaration) {
				this.visit((ASTDeclaration) node);
			}
		}
	}

	/*
	declaration -> typeSpecifiers initDeclaratorList ';'
	initDeclaratorList -> initDeclarator | initDeclarator ',' initDeclaratorList
	initDeclarator -> declarator | declarator '=' initializer
	declarator -> identifier postDeclarator
	postDeclarator -> '[' assignmentExpression ']' postDeclarator | '[' ']' postDeclarator | e
	initializer -> assignmentExpression | '{' expression '}'

	这里我们处理声明定义，主要包括变量声明、数组声明
	*/
	@Override
	public void visit(ASTDeclaration declaration) throws Exception {
		String typeSpecifiers = declaration.specifiers.get(0).value;

		for (ASTInitList initDeclarator : declaration.initLists) {
			this.visit(initDeclarator);

			String name = initDeclarator.declarator.getName();
			ASTDeclarator declarator = initDeclarator.declarator;
			// 声明变量
			if (declarator instanceof ASTVariableDeclarator) {
				// (Var, 变量类型 type, , 变量名 varName)
				Quat quat = new Quat("Var", declarator, declaration.specifiers.get(0), null);
				quats.add(quat);

				// 有初始值，(=, 初始值 initValue, , varName)
				if (!initDeclarator.exprs.isEmpty()) {
					String op = "=";
					ASTNode opnd1 = null;
					ASTNode opnd2 = null;

					ASTExpression expr = initDeclarator.exprs.get(0);

					// 用其他变量或常量赋值
					if (expr instanceof ASTIdentifier || expr instanceof ASTIntegerConstant || expr instanceof ASTFloatConstant || expr instanceof ASTCharConstant || expr instanceof ASTStringConstant) {
						opnd1 = expr;
					}
					// 双目运算赋值，先运算完然后赋值
					else if (expr instanceof ASTBinaryExpression) {
						ASTBinaryExpression binaryexpr = (ASTBinaryExpression) expr;
						op = binaryexpr.op.value;
						this.visit(binaryexpr.expr1);
						this.visit(binaryexpr.expr2);
						opnd1 = map.get(binaryexpr.expr1);
						opnd2 = map.get(binaryexpr.expr2);
					}
					// 单目运算 或者 函数调用返回值赋值
					else if (expr instanceof ASTPostfixExpression || expr instanceof ASTUnaryExpression || expr instanceof ASTFunctionCall) {
						this.visit(expr);
						opnd1 = map.get(expr);
					}
					Quat quat1 = new Quat(op, declarator, opnd1, opnd2);
					quats.add(quat1);
					map.put(initDeclarator, declarator);
				}
			}
			// 声明数组
			else if (declarator instanceof ASTArrayDeclarator) {
				ASTDeclarator arrayDeclarator = ((ASTArrayDeclarator) declarator).declarator;
				ASTExpression expr = ((ASTArrayDeclarator) declarator).expr;

				LinkedList<Integer> arrayMem = new LinkedList<Integer>();
				// 取出数组各维上限，合成arrType
				while (true) {
					int memSize = ((ASTIntegerConstant) expr).value;
					arrayMem.addFirst(memSize);

					if (arrayDeclarator instanceof ASTArrayDeclarator) {
						expr = ((ASTArrayDeclarator) arrayDeclarator).expr;
						arrayDeclarator = ((ASTArrayDeclarator) arrayDeclarator).declarator;
					} else {
						break;
					}
				}

				// 生成复合数组变量类型
				for (int memSize : arrayMem) {
					typeSpecifiers += "[" + memSize + "]";
				}
				TagLabel arrType = new TagLabel(typeSpecifiers);
				// (Arr, 数组类型 type, , 数组名arrName)
				Quat quat = new Quat("Arr", arrayDeclarator, arrType, null);
				quats.add(quat);
			}
		}
	}

	@Override
	public void visit(ASTArrayDeclarator arrayDeclarator) throws Exception {
		// TODO Auto-generated method stub
		this.visit(arrayDeclarator.declarator);
		this.visit(arrayDeclarator.expr);
	}

	@Override
	public void visit(ASTVariableDeclarator variableDeclarator) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTFunctionDeclarator functionDeclarator) throws Exception {
		// TODO Auto-generated method stub
		this.visit(functionDeclarator.declarator);
	}

	@Override
	public void visit(ASTParamsDeclarator paramsDeclarator) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTArrayAccess arrayAccess) throws Exception {
		// TODO Auto-generated method stub
		ASTExpression compoundArrayName = arrayAccess.arrayName;
		ASTExpression acsIndex = arrayAccess.elements.get(0);

		// 循环得到每一维数组下标
		LinkedList<ASTNode> index = new LinkedList<>();
		while (compoundArrayName instanceof ASTArrayAccess) {
			this.visit(acsIndex);
			ASTNode rest = map.get(acsIndex);
			index.addFirst(rest);
			acsIndex = ((ASTArrayAccess) compoundArrayName).elements.get(0);
			compoundArrayName = ((ASTArrayAccess) compoundArrayName).arrayName;
		}

		// 数组每一维的上限
		LinkedList<Integer> size = null;

		// 记录倒序的各维的上限，例a[3][4][5]则有record = [20, 5]
		int num = 1;
		LinkedList<Integer> record = new LinkedList<>();
		for (int i = size.size() - 1; i > 0; i--) {
			num *= size.get(i);
			record.addFirst(num);
		}

		ASTNode t1 = new TemporaryValue(++ tmpId);
		ASTNode t2 = new TemporaryValue(++ tmpId);

		// 生成数组嵌套计算大小的四元式
		for (int i = 0; i < size.size() - 1; i++) {
			ASTIntegerConstant temp = new ASTIntegerConstant((Integer) record.get(i), -1);
			Quat quat1 = new Quat("*", t1, (ASTNode) index.get(i), temp);
			quats.add(quat1);
			Quat quat2 = new Quat("+", t2, t1, t2);
			quats.add(quat2);
		}
		Quat quat3 = new Quat("+", t2, t2, (ASTNode) index.get(index.size() - 1));
		quats.add(quat3);

		ASTNode t3 = new TemporaryValue(++ tmpId);
		// 访问
		Quat quat4 = new Quat("=[]", t3, t2, compoundArrayName);
		quats.add(quat4);
		map.put(arrayAccess, t3);
	}

	@Override
	public void visit(ASTBinaryExpression binaryExpression) throws Exception {
		String op = binaryExpression.op.value;
		ASTNode res = null;
		ASTNode opnd1 = null;
		ASTNode opnd2 = null;

		if (op.equals("=")) {
			// 赋值操作
			// 获取被赋值的对象res
			visit(binaryExpression.expr1);
			res = map.get(binaryExpression.expr1);
			// 判断源操作数类型, 为了避免出现a = b + c; 生成两个四元式：tmp1 = b + c; a = tmp1;的情况。也可以用别的方法解决
			if (binaryExpression.expr2 instanceof ASTIdentifier) {
				opnd1 = binaryExpression.expr2;
			} else if (binaryExpression.expr2 instanceof ASTIntegerConstant) {
				opnd1 = binaryExpression.expr2;
			} else if (binaryExpression.expr2 instanceof ASTCharConstant) {
				opnd1 = binaryExpression.expr2;
			} else if (binaryExpression.expr2 instanceof ASTStringConstant) {
				opnd1 = binaryExpression.expr2;
			} else if (binaryExpression.expr2 instanceof ASTBinaryExpression) {	// 多重嵌套，分别计算
				ASTBinaryExpression value = (ASTBinaryExpression) binaryExpression.expr2;
				op = value.op.value;
				visit(value.expr1);
				opnd1 = map.get(value.expr1);
				visit(value.expr2);
				opnd2 = map.get(value.expr2);
			} else if (binaryExpression.expr2 instanceof ASTArrayAccess) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);
			} else if (binaryExpression.expr2 instanceof ASTUnaryExpression) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);
			} else if (binaryExpression.expr2 instanceof ASTPostfixExpression) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);
			} else if (binaryExpression.expr2 instanceof ASTFunctionCall) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);
			}
		}
		// 不能直接赋值的双目运算符，结果存储到临时变量
		else if (op.equals("+") || op.equals("-") ||
				op.equals("*") || op.equals("/") ||
				op.equals("%") || op.equals(">=") ||
				op.equals("<=") || op.equals(">") ||
				op.equals("<") || op.equals("==") ||
				op.equals("!=") || op.equals("&&") ||
				op.equals("||")) {
			res = new TemporaryValue(++ tmpId);
			visit(binaryExpression.expr1);
			opnd1 = map.get(binaryExpression.expr1);
			visit(binaryExpression.expr2);
			opnd2 = map.get(binaryExpression.expr2);

			String name = ((TemporaryValue) res).name();
			String type = "char";

		}
		// 能直接赋值的双目运算符，结果存储到临时变量
		else if (op.equals("+=") || op.equals("-=") || op.equals("*=") ||
				op.equals("/=") || op.equals("%=")) {
			this.visit(binaryExpression.expr1);
			opnd1 = map.get(binaryExpression.expr1);
			this.visit(binaryExpression.expr2);
			opnd2 = map.get(binaryExpression.expr2);
			res = opnd1;
		}

		// 生成四元式
		Quat quat = new Quat(op, res, opnd1, opnd2);
		quats.add(quat);
		map.put(binaryExpression, res);

	}

	@Override
	public void visit(ASTBreakStatement breakStat) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTContinueStatement continueStatement) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTCastExpression castExpression) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTCharConstant charConst) throws Exception {
		// TODO Auto-generated method stub
		map.put(charConst, charConst);
	}

	@Override
	public void visit(ASTCompoundStatement compoundStat) throws Exception {
		for (ASTNode node : compoundStat.blockItems) {
			if (node instanceof ASTDeclaration) {
				this.visit((ASTDeclaration) node);
			} else if (node instanceof ASTStatement) {
				this.visit((ASTStatement) node);
			}
		}
		
	}

	@Override
	public void visit(ASTConditionExpression conditionExpression) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTExpression expression) throws Exception {
		if(expression instanceof ASTArrayAccess) {
			visit((ASTArrayAccess)expression);
		}else if(expression instanceof ASTBinaryExpression) {
			visit((ASTBinaryExpression)expression);
		}else if(expression instanceof ASTCastExpression) {
			visit((ASTCastExpression)expression);
		}else if(expression instanceof ASTCharConstant) {
			visit((ASTCharConstant)expression);
		}else if(expression instanceof ASTConditionExpression) {
			visit((ASTConditionExpression)expression);
		}else if(expression instanceof ASTFloatConstant) {
			visit((ASTFloatConstant)expression);
		}else if(expression instanceof ASTFunctionCall) {
			visit((ASTFunctionCall)expression);
		}else if(expression instanceof ASTIdentifier) {
			visit((ASTIdentifier)expression);
		}else if(expression instanceof ASTIntegerConstant) {
			visit((ASTIntegerConstant)expression);
		}else if(expression instanceof ASTMemberAccess) {
			visit((ASTMemberAccess)expression);
		}else if(expression instanceof ASTPostfixExpression) {
			visit((ASTPostfixExpression)expression);
		}else if(expression instanceof ASTStringConstant) {
			visit((ASTStringConstant)expression);
		}else if(expression instanceof ASTUnaryExpression) {
			visit((ASTUnaryExpression)expression);
		}else if(expression instanceof ASTUnaryTypename){
			visit((ASTUnaryTypename)expression);
		}
	}

	@Override
	public void visit(ASTExpressionStatement expressionStat) throws Exception {
		for (ASTExpression node : expressionStat.exprs) {
			visit((ASTExpression)node);
		}
	}

	@Override
	public void visit(ASTFloatConstant floatConst) throws Exception {
		// TODO Auto-generated method stub
		map.put(floatConst, floatConst);
	}

	@Override
	public void visit(ASTFunctionCall funcCall) throws Exception {
		// TODO Auto-generated method stub
		String functionName = ((ASTIdentifier) funcCall.funcname).value;
		TagLabel functionLabel = new TagLabel(functionName);

		String returnType = funcRetType.get(functionName);

		for (ASTExpression expr : funcCall.argList) {
			this.visit(expr);
			ASTNode arg = map.get(expr);

			Quat quat = new Quat("Arg", arg, functionLabel, null);
			quats.add(quat);
		}
		// 无返回的类型
		if (returnType == null || returnType.equals("void")) {
			Quat quat = new Quat("Call", null, funcCall.funcname, null);
			quats.add(quat);
		}
		// 有返回的类型
		else {
			ASTNode temp = new TemporaryValue(++tmpId);
			String name = ((TemporaryValue) temp).name();
			Quat quat = new Quat("Call", temp, funcCall.funcname, null);
			quats.add(quat);
			map.put(funcCall, temp);
		}
	}

	@Override
	public void visit(ASTGotoStatement gotoStat) throws Exception {
		// TODO Auto-generated method stub
		String labelName = gotoStat.label.value;
		ASTNode label = labelTable.get(labelName);
		Quat quat = new Quat("Jmp", label, null, null);
		quats.add(quat);
	}
	@Override
	public void visit(ASTIdentifier identifier) throws Exception {
		map.put(identifier, identifier);
	}

	@Override
	public void visit(ASTInitList initList) throws Exception {
		// TODO Auto-generated method stub
		if (initList.declarator instanceof ASTVariableDeclarator) {
			this.visit((ASTVariableDeclarator) initList.declarator);
			for (ASTExpression expr : initList.exprs) {
				this.visit(expr);
			}
		} else if (initList.declarator instanceof ASTArrayDeclarator) {
			this.visit((ASTArrayDeclarator) initList.declarator);
		} else if (initList.declarator instanceof ASTFunctionDeclarator) {
			this.visit((ASTFunctionDeclarator) initList.declarator);
		}
	}

	@Override
	public void visit(ASTIntegerConstant intConst) throws Exception {
		map.put(intConst, intConst);
	}

	@Override
	public void visit(ASTIterationDeclaredStatement iterationDeclaredStat) throws Exception {
		// TODO Auto-generated method stub
		if (iterationDeclaredStat == null) {
			return;
		}
		// 打上开始标记
		String ForBegin = "@For" + this.ForId++;
		TagLabel BeginLabel = new TagLabel(ForBegin);
		Quat quat = new Quat("Label", BeginLabel, null, null);
		quats.add(quat);

		if (iterationDeclaredStat.init != null) {
			this.visit(iterationDeclaredStat.init);
		}
		// 条件节点的Label
		String condstr = "@CondFor" + this.ForId;
		TagLabel condLabel = new TagLabel(condstr, this.quats.size());
		Quat quat1 = new Quat("Label", condLabel, null, null);
		quats.add(quat1);

		if (iterationDeclaredStat.cond != null) {
			for (ASTExpression cond : iterationDeclaredStat.cond)
				this.visit(cond);
		}
		this.visit(iterationDeclaredStat.stat);
		// 如果不满足，跳到结束
		String Endstr = "@EndFor" + this.ForId;
		TagLabel EndLabel = new TagLabel(Endstr);

		Quat quat2 = new Quat("Jnt", EndLabel, null, null);
		quats.add(quat2);

		if (iterationDeclaredStat.step != null) {
			for (ASTExpression step : iterationDeclaredStat.step)
				this.visit(step);
		}
		// 无条件跳回cond，循环
		Quat quat3 = new Quat("Jmp", condLabel, null, null);
		quats.add(quat3);
		//结束标记
		Quat quat4 = new Quat("Label", EndLabel, null, null);
		quats.add(quat4);
	}

	@Override
	public void visit(ASTIterationStatement iterationStat) throws Exception {
		// TODO Auto-generated method stub
		if (iterationStat == null) {
			return;
		}
		// 打上开始标记
		String ForBegin = "@For" + this.ForId++;
		TagLabel BeginLabel = new TagLabel(ForBegin);
		Quat quat = new Quat("Label", BeginLabel, null, null);
		quats.add(quat);

		if (iterationStat.init != null) {
			for (ASTExpression init : iterationStat.init)
				this.visit(init);
		}
		// 条件节点的Label
		String condstr = "@CondFor" + this.ForId;
		TagLabel condLabel = new TagLabel(condstr, this.quats.size());
		Quat quat1 = new Quat("Label", condLabel, null, null);
		quats.add(quat1);

		if (iterationStat.cond != null) {
			for (ASTExpression cond : iterationStat.cond)
				this.visit(cond);
		}
		this.visit(iterationStat.stat);
		// 如果不满足，跳到结束
		String Endstr = "@EndFor" + this.ForId;
		TagLabel EndLabel = new TagLabel(Endstr);

		Quat quat2 = new Quat("Jnt", EndLabel, null, null);
		quats.add(quat2);

		if (iterationStat.step != null) {
			for (ASTExpression step : iterationStat.step)
				this.visit(step);
		}
		// 无条件跳回cond，循环
		Quat quat3 = new Quat("Jmp", condLabel, null, null);
		quats.add(quat3);
		//结束标记
		Quat quat4 = new Quat("Label", EndLabel, null, null);
		quats.add(quat4);
	}

	@Override
	public void visit(ASTLabeledStatement labeledStat) throws Exception {
		// TODO Auto-generated method stub
		String label = labeledStat.label.value;
		TagLabel inLabel = new TagLabel(label, this.quats.size());
		Quat quat = new Quat("Label", inLabel, null, null);
		quats.add(quat);
		this.labelTable.put(label, inLabel);

		this.visit(labeledStat.stat);

	}

	@Override
	public void visit(ASTMemberAccess memberAccess) throws Exception {
		// TODO Auto-generated method stub
		
	}

	// a++, a++, a., a->
	// ("=", expr, , temp)
	// ("op", temp, , expr)
	@Override
	public void visit(ASTPostfixExpression postfixExpression) throws Exception {
		// TODO Auto-generated method stub
		String op = postfixExpression.op.value;
		ASTNode temp = new TemporaryValue(++tmpId);

		String name = ((TemporaryValue) temp).name();

		Quat quat = new Quat("=", temp, postfixExpression.expr, null);
		quats.add(quat);
		Quat quat1 = new Quat(op, postfixExpression, temp, null);
		quats.add(quat1);

		map.put(postfixExpression, temp);

	}

	// ("ret", , , ) ("ret", , , returnValue)
	@Override
	public void visit(ASTReturnStatement returnStat) throws Exception {
		// TODO Auto-generated method stub
		// return ;
		if (returnStat.expr == null) {
			Quat quat = new Quat("ret", null, null, null);
			quats.add(quat);
		} else {
			for (ASTExpression expr : returnStat.expr) {
				this.visit(expr);
			}
			ASTNode ret = map.get(returnStat.expr.get(0));
			Quat quat = new Quat("ret", ret, null, null);
			quats.add(quat);
		}

	}

	@Override
	public void visit(ASTSelectionStatement selectionStat) throws Exception {
		// TODO Auto-generated method stub

		for (ASTExpression cond : selectionStat.cond) {
			this.visit(cond);
		}

		ASTNode res = map.get(selectionStat.cond.get(0));
		String label1 = "IfCond" + this.jmpId ++;
		TagLabel ifCondFalseLabel = new TagLabel(label1);
		Quat quat = new Quat("Jnt", res, ifCondFalseLabel, null);
		quats.add(quat);

		this.visit(selectionStat.then);

		String label2 = "@Endif" + this.jmpId ++;
		TagLabel gotoEndLabel = new TagLabel(label2);
		Quat quat1 = new Quat("Jmp", gotoEndLabel, null, null);
		quats.add(quat1);

		ifCondFalseLabel.dest = this.quats.size();
		Quat quat2 = new Quat("Label", ifCondFalseLabel, null, null);
		quats.add(quat2);

		if (selectionStat.otherwise != null) {
			this.visit(selectionStat.otherwise);
		}

		gotoEndLabel.dest = this.quats.size();
		Quat quat3 = new Quat("Label", gotoEndLabel, null, null);
		quats.add(quat3);

	}

	@Override
	public void visit(ASTStringConstant stringConst) throws Exception {
		// TODO Auto-generated method stub
		map.put(stringConst, stringConst);
	}

	@Override
	public void visit(ASTTypename typename) throws Exception {
		// TODO Auto-generated method stub

	}

	// ++a, --a: (op, a, , a)
	// &a, *a, +a, -a, !a, sizeof(a): (op, a, , temp)
	@Override
	public void visit(ASTUnaryExpression unaryExpression) throws Exception {
		// TODO Auto-generated method stub
		String op = unaryExpression.op.value;
		if (op.equals("++") || op.equals("--")) {
			this.visit(unaryExpression.expr);

			// (op, a, , a)
			ASTNode res = map.get(unaryExpression.expr);
			Quat quat = new Quat(op, res, res, null);
			quats.add(quat);
			map.put(unaryExpression, res);
		} else {
			this.visit(unaryExpression.expr);

			ASTNode res = new TemporaryValue(++tmpId);
			String name = ((TemporaryValue) res).name();

			// (op, a, , temp)
			ASTNode expr = map.get(unaryExpression.expr);
			Quat quat = new Quat(op, res, expr, null);
			quats.add(quat);
			map.put(unaryExpression, res);
		}

	}

	@Override
	public void visit(ASTUnaryTypename unaryTypename) throws Exception {
		// TODO Auto-generated method stub

	}

	// ("func", returnType, argNum, funcName)
	// ("param", type, , argName)
	@Override
	public void visit(ASTFunctionDefine functionDefine) throws Exception {
		ASTToken typeSpecifier = functionDefine.specifiers.get(0);

		String funcname = functionDefine.declarator.getName();
		funcRetType.put(funcname, typeSpecifier.value);
		TagLabel funcLabel = new TagLabel(funcname);
		ASTIntegerConstant paramNum = new ASTIntegerConstant(((ASTFunctionDeclarator) functionDefine.declarator).params.size(), -1);
		Quat quat = new Quat("Proc", typeSpecifier, paramNum, funcLabel);
		quats.add(quat);

		ASTFunctionDeclarator astFunctionDeclarator = (ASTFunctionDeclarator) functionDefine.declarator;
		LinkedList<ASTNode> params = new LinkedList<>();
		for (ASTParamsDeclarator param : astFunctionDeclarator.params) {
			ASTToken paramTypeSpecifier = param.specfiers.get(0);

			String paramName = param.declarator.getName();
			params.add(param);

			TagLabel paramLabel = new TagLabel(paramName);
			Quat quat1 = new Quat("param", paramLabel, paramTypeSpecifier, null);
			quats.add(quat1);
		}

		this.visit(functionDefine.declarator);
		this.visit(functionDefine.body);

		Quat quat1 = new Quat("Endp", functionDefine.declarator, null, null);
		quats.add(quat1);
	}

	@Override
	public void visit(ASTDeclarator declarator) throws Exception {
		// TODO Auto-generated method stub
		if (declarator instanceof ASTVariableDeclarator) {
			visit((ASTVariableDeclarator) declarator);
		} else if (declarator instanceof ASTArrayDeclarator) {
			visit((ASTArrayDeclarator) declarator);
		} else if (declarator instanceof ASTFunctionDeclarator) {
			visit((ASTFunctionDeclarator) declarator);
		}
	}

	@Override
	public void visit(ASTStatement statement) throws Exception {
		if (statement instanceof ASTIterationDeclaredStatement) {
			visit((ASTIterationDeclaredStatement) statement);
		} else if (statement instanceof ASTIterationStatement) {
			visit((ASTIterationStatement) statement);
		} else if (statement instanceof ASTCompoundStatement) {
			visit((ASTCompoundStatement) statement);
		} else if (statement instanceof ASTSelectionStatement) {
			visit((ASTSelectionStatement) statement);
		} else if (statement instanceof ASTExpressionStatement) {
			visit((ASTExpressionStatement) statement);
		} else if (statement instanceof ASTBreakStatement) {
			visit((ASTBreakStatement) statement);
		} else if (statement instanceof ASTContinueStatement) {
			visit((ASTContinueStatement) statement);
		} else if (statement instanceof ASTReturnStatement) {
			visit((ASTReturnStatement) statement);
		} else if (statement instanceof ASTGotoStatement) {
			visit((ASTGotoStatement) statement);
		} else if (statement instanceof ASTLabeledStatement) {
			visit((ASTLabeledStatement) statement);
		}
	}

	@Override
	public void visit(ASTToken token) throws Exception {
		// TODO Auto-generated method stub

	}

}