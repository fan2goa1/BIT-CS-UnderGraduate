package bit.minisys.minicc.icgen;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import bit.minisys.minicc.parser.ast.*;

// ����Example��д
public class MyICBuilder implements ASTVisitor{

	private Map<ASTNode, ASTNode> map;				// ʹ��map�洢�ӽڵ�ķ���ֵ��key��Ӧ�ӽڵ㣬value��Ӧ����ֵ��valueĿǰ������ASTIdentifier,ASTIntegerConstant,TemportaryValue...
	private List<Quat> quats;						// ���ɵ���Ԫʽ�б�
	private Integer tmpId;							// ��ʱ�������
	private Map<String, String>	funcRetType;					// ���ڼ�¼ÿ�������ķ�������
	private Map<String, ASTNode> labelTable;					// ��¼ֱ����ת��Label�ı��
	private Map<String, LinkedList<Integer> > arrayLimit;			// ��¼��Ӧ���������ĸ�ά��С����
	public Integer ForId;		// Forѭ�����
	public Integer jmpId;		// ֱ����ת�ı��
	public Integer IfId;		// If�ı��
	public boolean isLeft;		// 1��ʾ��ǰ�ǵȺ����
	public Quat leftarr;
	public MyICBuilder() {
		map = new HashMap<ASTNode, ASTNode>();		// �洢AST�ڵ�֮��Ĺ�ϵ<a, b> aΪb��child
		quats = new LinkedList<Quat>();
		funcRetType = new HashMap<String, String>();
		labelTable = new HashMap<String, ASTNode>();
		arrayLimit = new HashMap<String, LinkedList<Integer> >();

		isLeft = false;
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

	�������Ǵ����������壬��Ҫ����������������������
	*/
	@Override
	public void visit(ASTDeclaration declaration) throws Exception {
		String typeSpecifiers = declaration.specifiers.get(0).value;

		for (ASTInitList initDeclarator : declaration.initLists) {
//			this.visit(initDeclarator);

			String name = initDeclarator.declarator.getName();
			ASTDeclarator declarator = initDeclarator.declarator;
			// ��������
			if (declarator instanceof ASTVariableDeclarator) {
				// (Var, �������� type, , ������ varName)
				Quat quat = new Quat("Var", declarator, declaration.specifiers.get(0), null);
				quats.add(quat);

				// �г�ʼֵ��(=, ��ʼֵ initValue, , varName)
				if (!initDeclarator.exprs.isEmpty()) {
					String op = "=";
					ASTNode opnd1 = null;
					ASTNode opnd2 = null;

					ASTExpression expr = initDeclarator.exprs.get(0);

					// ����������������ֵ
					if (expr instanceof ASTIdentifier || expr instanceof ASTIntegerConstant || expr instanceof ASTFloatConstant || expr instanceof ASTCharConstant || expr instanceof ASTStringConstant) {
						opnd1 = expr;
					}
					// ˫Ŀ���㸳ֵ����������Ȼ��ֵ
					else if (expr instanceof ASTBinaryExpression) {
						ASTBinaryExpression binaryexpr = (ASTBinaryExpression) expr;
						op = binaryexpr.op.value;
						this.visit(binaryexpr.expr1);
						this.visit(binaryexpr.expr2);
						opnd1 = map.get(binaryexpr.expr1);
						opnd2 = map.get(binaryexpr.expr2);
					}
					// ��Ŀ���� ���� �������÷���ֵ��ֵ ��������ֵ
					else if (expr instanceof ASTPostfixExpression || expr instanceof ASTUnaryExpression || expr instanceof ASTFunctionCall || expr instanceof  ASTArrayAccess) {
						this.visit(expr);
						opnd1 = map.get(expr);
					}
					Quat quat1 = new Quat(op, declarator, opnd1, opnd2);
					quats.add(quat1);
					map.put(initDeclarator, declarator);
				}
			}
			// ��������
			else if (declarator instanceof ASTArrayDeclarator) {
				ASTDeclarator arrayDeclarator = ((ASTArrayDeclarator) declarator).declarator;
				ASTExpression expr = ((ASTArrayDeclarator) declarator).expr;

				LinkedList<Integer> arrayMem = new LinkedList<Integer>();
				// ȡ�������ά���ޣ��ϳ�arrType
				int memSize = ((ASTIntegerConstant) expr).value;
				arrayMem.addFirst(memSize);

				while(arrayDeclarator instanceof  ASTArrayDeclarator) {
					expr = ((ASTArrayDeclarator) arrayDeclarator).expr;
					arrayDeclarator = ((ASTArrayDeclarator) arrayDeclarator).declarator;

					memSize = ((ASTIntegerConstant) expr).value;
					arrayMem.addFirst(memSize);
				}

				// ���ɸ��������������
				for (int memLimit : arrayMem) {
					typeSpecifiers += "[" + memLimit + "]";
				}
				TagLabel arrType = new TagLabel(typeSpecifiers);
				// (Arr, �������� type, , ������arrName)
				arrayLimit.put(name, arrayMem);
				Quat quat = new Quat("Arr", arrayDeclarator, arrType, null);
				quats.add(quat);
			}
		}
	}

	@Override
	public void visit(ASTArrayDeclarator arrayDeclarator) throws Exception {
		// TODO Auto-generated method stub
	}

	@Override
	public void visit(ASTVariableDeclarator variableDeclarator) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ASTFunctionDeclarator functionDeclarator) throws Exception {
		// TODO Auto-generated method stub
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

		// ѭ���õ�ÿһά�����±�
		LinkedList<ASTNode> index = new LinkedList<>();

		this.visit(acsIndex);
		ASTNode rest = map.get(acsIndex);
		index.addFirst(rest);

		while (compoundArrayName instanceof ASTArrayAccess) {
			acsIndex = ((ASTArrayAccess) compoundArrayName).elements.get(0);
			compoundArrayName = ((ASTArrayAccess) compoundArrayName).arrayName;

			this.visit(acsIndex);
			rest = map.get(acsIndex);
			index.addFirst(rest);
		}

		String arrayName = ((ASTIdentifier) compoundArrayName).value;
		// ����ÿһά������
		LinkedList<Integer> arraySize = arrayLimit.get(arrayName);

		// ��¼����ĸ�ά�����ޣ���a[3][4][5]����record = [20, 5]
		int num = 1;
		LinkedList<Integer> record = new LinkedList<>();
		for (int i = arraySize.size() - 1; i > 0; i--) {
			num *= arraySize.get(i);
			record.addFirst(num);
		}

		ASTNode t1 = new TemporaryValue(++ tmpId);
		ASTNode t2 = new TemporaryValue(++ tmpId);

		// ������
		TagLabel zeroValue = new TagLabel("0");
		Quat quat = new Quat("=", t2, zeroValue, null);
		quats.add(quat);
		// ��������Ƕ�׼����С����Ԫʽ
		for (int i = 0; i < arraySize.size() - 1; i++) {
			ASTIntegerConstant temp = new ASTIntegerConstant((Integer) record.get(i), -1);
			Quat quat1 = new Quat("*", t1, (ASTNode) index.get(i), temp);
			quats.add(quat1);
			Quat quat2 = new Quat("+", t2, t1, t2);
			quats.add(quat2);
		}
		Quat quat3 = new Quat("+", t2, t2, (ASTNode) index.get(index.size() - 1));
		quats.add(quat3);

		ASTNode t3 = new TemporaryValue(++ tmpId);
		// ����
		Quat quat4 = new Quat("=[]", t3, t2, compoundArrayName);
		quats.add(quat4);
		map.put(arrayAccess, t3);

		// ��¼��ǰ�Ƿ��ǵ�ʽ���
		if(isLeft){
			leftarr = quat4;
		}
	}

	@Override
	public void visit(ASTBinaryExpression binaryExpression) throws Exception {
		String op = binaryExpression.op.value;
		ASTNode res = null;
		ASTNode opnd1 = null;
		ASTNode opnd2 = null;

		if (op.equals("=")) {
			// ��ֵ����
			// ��ȡ����ֵ�Ķ���res
			isLeft = true;		// �ǵ�ʽ���
			visit(binaryExpression.expr1);
			isLeft = false; 	// ��ʽ�ұ�
			res = map.get(binaryExpression.expr1);
			// �ж�Դ����������, Ϊ�˱������a = b + c; ����������Ԫʽ��tmp1 = b + c; a = tmp1;�������Ҳ�����ñ�ķ������
			if (binaryExpression.expr2 instanceof ASTIdentifier) {
				opnd1 = binaryExpression.expr2;

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTIntegerConstant) {
				opnd1 = binaryExpression.expr2;

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTCharConstant) {
				opnd1 = binaryExpression.expr2;

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTStringConstant) {
				opnd1 = binaryExpression.expr2;

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTBinaryExpression) {	// ����Ƕ�ף��ֱ����
				ASTBinaryExpression value = (ASTBinaryExpression) binaryExpression.expr2;
				op = value.op.value;
				visit(value.expr1);
				opnd1 = map.get(value.expr1);
				visit(value.expr2);
				opnd2 = map.get(value.expr2);

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTArrayAccess) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}

			} else if (binaryExpression.expr2 instanceof ASTUnaryExpression) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTPostfixExpression) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			} else if (binaryExpression.expr2 instanceof ASTFunctionCall) {
				this.visit(binaryExpression.expr2);
				opnd1 = map.get(binaryExpression.expr2);

				// ������Ԫʽ
				Quat quat = new Quat(op, res, opnd1, opnd2);
				quats.add(quat);
				map.put(binaryExpression, res);

				if (binaryExpression.expr1 instanceof  ASTArrayAccess){	// �жϵȺ�����Ƿ�������
					Quat quat1 = new Quat("[]=", leftarr.getOpnd2(), leftarr.getRes(), leftarr.getOpnd1());
					quats.add(quat1);
				}
			}
		}
		// ����ֱ�Ӹ�ֵ��˫Ŀ�����������洢����ʱ����
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

			// ������Ԫʽ
			Quat quat = new Quat(op, res, opnd1, opnd2);
			quats.add(quat);
			map.put(binaryExpression, res);

		}
		// ��ֱ�Ӹ�ֵ��˫Ŀ�����������洢����ʱ����
		else if (op.equals("+=") || op.equals("-=") || op.equals("*=") ||
				op.equals("/=") || op.equals("%=")) {
			this.visit(binaryExpression.expr1);
			opnd1 = map.get(binaryExpression.expr1);
			this.visit(binaryExpression.expr2);
			opnd2 = map.get(binaryExpression.expr2);
			res = opnd1;
			// ������Ԫʽ
			Quat quat = new Quat(op, res, opnd1, opnd2);
			quats.add(quat);
			map.put(binaryExpression, res);
		}

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
		// �޷��ص�����
		if (returnType == null) {	// ˵����Mars_PrintStr Mars_PrintInt Mars_GetInt
			if (functionName.equals("Mars_PrintStr") || functionName.equals("Mars_PrintInt")) { // ûʲô�仯
				Quat quat = new Quat("Call", null, funcCall.funcname, null);
				quats.add(quat);
			}
			else if (functionName.equals("Mars_GetInt")) {	// ��Ҫ����������浽һ����ʱ������
				ASTNode tmp = new TemporaryValue(++ tmpId);
				Quat quat = new Quat("Call", tmp, funcCall.funcname, null);
				quats.add(quat);
				map.put(funcCall, tmp);
			}
			else {
				Quat quat = new Quat("Call", null, funcCall.funcname, null);
				quats.add(quat);
			}
		}
		else if (returnType.equals("void")) {    // �Զ����޷���ֵ
			Quat quat = new Quat("Call", null, funcCall.funcname, null);
			quats.add(quat);
		}
		// �з��ص�����
		else {
			ASTNode temp = new TemporaryValue(++ tmpId);
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
		// ���Ͽ�ʼ���
		String ForBegin = "@For" + ++ this.ForId;
		TagLabel BeginLabel = new TagLabel(ForBegin);
		Quat quat = new Quat("Label", BeginLabel, null, null);
		quats.add(quat);

		if (iterationDeclaredStat.init != null) {
			this.visit(iterationDeclaredStat.init);
		}
		// �����ڵ��Label
		String condstr = "@CondFor" + this.ForId;
		TagLabel condLabel = new TagLabel(condstr, this.quats.size());
		Quat quat1 = new Quat("Label", condLabel, null, null);
		quats.add(quat1);

		if (iterationDeclaredStat.cond != null) {
			for (ASTExpression cond : iterationDeclaredStat.cond)
				this.visit(cond);
		}

		// ��������㣬��������
		String Endstr = "@EndFor" + this.ForId;
		TagLabel EndLabel = new TagLabel(Endstr);
		ASTNode condval = map.get(iterationDeclaredStat.cond.get(0));
		Quat quat2 = new Quat("Jnt", EndLabel, condval, null);
		quats.add(quat2);

		this.visit(iterationDeclaredStat.stat);

		if (iterationDeclaredStat.step != null) {
			for (ASTExpression step : iterationDeclaredStat.step)
				this.visit(step);
		}
		// ����������cond��ѭ��
		Quat quat3 = new Quat("Jmp", condLabel, null, null);
		quats.add(quat3);
		//�������
		Quat quat4 = new Quat("Label", EndLabel, null, null);
		quats.add(quat4);
	}

	@Override
	public void visit(ASTIterationStatement iterationStat) throws Exception {
		// TODO Auto-generated method stub
		if (iterationStat == null) {
			return;
		}
		// ���Ͽ�ʼ���
		String ForBegin = "@For" + ++ this.ForId;
		TagLabel BeginLabel = new TagLabel(ForBegin);
		Quat quat = new Quat("Label", BeginLabel, null, null);
		quats.add(quat);

		if (iterationStat.init != null) {
			for (ASTExpression init : iterationStat.init)
				this.visit(init);
		}
		// �����ڵ��Label
		String condstr = "@CondFor" + this.ForId;
		TagLabel condLabel = new TagLabel(condstr, this.quats.size());
		Quat quat1 = new Quat("Label", condLabel, null, null);
		quats.add(quat1);

		if (iterationStat.cond != null) {
			for (ASTExpression cond : iterationStat.cond)
				this.visit(cond);
		}
		// ��������㣬��������
		String Endstr = "@EndFor" + this.ForId;
		TagLabel EndLabel = new TagLabel(Endstr);

		ASTNode condVal = map.get(iterationStat.cond.get(0));
		Quat quat2 = new Quat("Jnt", EndLabel, condVal, null);
		quats.add(quat2);

		this.visit(iterationStat.stat);	// ִ������������

		if (iterationStat.step != null) {
			for (ASTExpression step : iterationStat.step)
				this.visit(step);
		}
		// ����������cond��ѭ��
		Quat quat3 = new Quat("Jmp", condLabel, null, null);
		quats.add(quat3);
		//�������
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
		ASTNode temp = new TemporaryValue(++ tmpId);

		String name = ((TemporaryValue) temp).name();

		Quat quat = new Quat("=", temp, postfixExpression.expr, null);
		quats.add(quat);
		Quat quat1 = new Quat(op, postfixExpression.expr, null, null);
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
		// ȡ��cond���ʽ�Ľ���������Ϊtrue����ת��IfNCond
		ASTNode condValue = map.get(selectionStat.cond.get(0));
		String label1 = "IfNCond" + this.jmpId ++;
		TagLabel ifCondFalseLabel = new TagLabel(label1);
		Quat quat = new Quat("Jnt", ifCondFalseLabel, condValue, null);
		quats.add(quat);

		this.visit(selectionStat.then);
		// ִ����if�е����ݣ���������
		String label2 = "@Endif" + this.IfId ++;
		TagLabel gotoEndLabel = new TagLabel(label2);
		Quat quat1 = new Quat("Jmp", gotoEndLabel, null, null);
		quats.add(quat1);

		ifCondFalseLabel.dest = this.quats.size();
		Quat quat2 = new Quat("Label", ifCondFalseLabel, null, null);
		quats.add(quat2);

		if (selectionStat.otherwise != null) {
			this.visit(selectionStat.otherwise);
		}
		// ������ǩ
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

			ASTNode res = new TemporaryValue(++ tmpId);
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
	// ("Param", type, , argName)
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
			Quat quat1 = new Quat("Param", paramLabel, paramTypeSpecifier, null);
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