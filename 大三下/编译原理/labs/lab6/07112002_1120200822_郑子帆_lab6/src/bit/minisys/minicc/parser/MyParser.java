package bit.minisys.minicc.parser;

import bit.minisys.minicc.MiniCCCfg;
import bit.minisys.minicc.internal.util.MiniCCUtil;
import bit.minisys.minicc.parser.ast.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.antlr.v4.gui.TreeViewer;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

class ScannerToken{
	public String lexme;
	public String type;
	public int	  line;
	public int    column;
}

public class MyParser implements IMiniCCParser {

	private ArrayList<ScannerToken> tknList;
	private int tokenIndex;
	private ScannerToken nxtToken;

	@Override
	public String run(String iFile) throws Exception {

		String oFile = MiniCCUtil.removeAllExt(iFile) + MiniCCCfg.MINICC_PARSER_OUTPUT_EXT;
		String tFile = MiniCCUtil.removeAllExt(iFile) + MiniCCCfg.MINICC_SCANNER_OUTPUT_EXT;

		tknList = loadTokens(tFile);
		tokenIndex = 0;

		ASTNode root = program();


		String[] nonsense = new String[20];
		TreeViewer Tviewer = new TreeViewer(Arrays.asList(nonsense), root);
		Tviewer.open();

		ObjectMapper mapper = new ObjectMapper();
		mapper.writeValue(new File(oFile), root);
		System.out.println("3. Parser finished!");
		return oFile;
	}

	private ArrayList<ScannerToken> loadTokens(String tFile) {
		tknList = new ArrayList<ScannerToken>();

		ArrayList<String> tknStr = MiniCCUtil.readFile(tFile);

		for(String str: tknStr) {
			if(str.trim().length() <= 0) {
				continue;
			}

			ScannerToken st = new ScannerToken();
			//[@0,0:2='int',<'int'>,1:0]
			String[] segs;
			if(str.indexOf("<','>") > 0) {
				str = str.replace("','", "'DOT'");

				segs = str.split(",");
				segs[1] = "=','";
				segs[2] = "<','>";

			}else {
				segs = str.split(",");
			}
			st.lexme = segs[1].substring(segs[1].indexOf("=") + 2,segs[1].length() - 1);
			st.type  = segs[2].substring(segs[2].indexOf("<") + 1, segs[2].length() - 1);
			String[] lc = segs[3].split(":");
			st.line = Integer.parseInt(lc[0]);
			st.column = Integer.parseInt(lc[1].replace("]", ""));

			tknList.add(st);
			//System.out.println(st.type);
		}
		return tknList;
	}

	private ASTToken getToken() {
		ScannerToken scannertoken = tknList.get(tokenIndex);
		ASTToken token = new ASTToken(scannertoken.lexme, tokenIndex);
		tokenIndex ++;
		return token;
	}

	public void matchToken(String type) {
		if(tokenIndex < tknList.size()) {
			ScannerToken next = tknList.get(tokenIndex);
			if(!next.type.equals(type)) {
				System.out.println("[ERROR]Parser: unmatched token, expected = " + type + ", "
						+ "input = " + next.type);
			}
			else {
				tokenIndex++;
			}
		}
	}

	/* 终结符ctype1可取的值 */
	private boolean pd_ctype(String s) {
		return  s.equals("'void'")||
				s.equals("'int'")||
				s.equals("'char'");
	}

	/* 终结符operator_assign可取的值 */
	private boolean pd_operator_assign(String s) {
		return s.equals("'='")||
				s.equals("'*='")||
				s.equals("'/='")||
				s.equals("'%='")||
				s.equals("'+='")||
				s.equals("'-='");
	}

	/*
	program ->
		func_list
	 */
	public ASTNode program() {
		ASTCompilationUnit p = new ASTCompilationUnit();
		ArrayList<ASTNode> fl = funcList();
		if(fl != null) {
			p.items.addAll(fl);
		}
		p.children.addAll(p.items);
		return p;
	}

	/*
	func_list ->
	  e
	| func func_list
	 */
	public ArrayList<ASTNode> funcList() {
		ArrayList<ASTNode> fl = new ArrayList<ASTNode>();

		nxtToken = tknList.get(tokenIndex);
		if(nxtToken.type.equals("EOF")) {
			return null;
		}
		else {
			ASTNode f = func();
			fl.add(f);
			ArrayList<ASTNode> fl2 = funcList();
			if(fl2 != null) {
				fl.addAll(fl2);
			}
			return fl;
		}
	}

	/*
	func ->
	  ctype declarator '(' args ')' code_block
	 */
	public ASTNode func() {
		ASTFunctionDefine fdef = new ASTFunctionDefine();
		List<ASTToken> s = ctype();

		ASTDeclarator dec = declarator();
		ASTFunctionDeclarator fdec = new ASTFunctionDeclarator();
		fdec.declarator = dec;
		fdec.children.add(dec);

		matchToken("'('");
		ArrayList<ASTParamsDeclarator> func_args = args();
		matchToken("')'");
		if(func_args != null) {	// args对应的AST节点挂载到ASTFunctionDeclarator节点上
			fdec.params.addAll(func_args);
			fdec.children.addAll(func_args);
		}

		ASTCompoundStatement cb = code_block();

		fdef.specifiers = s;
		fdef.children.addAll(s);
		fdef.declarator = fdec;
		fdef.children.add(fdec);
		fdef.body = cb;
		fdef.children.add(cb);
		return fdef;
	}

	/*
	ctype ->
	  e
	| cytpe1 ctype
	 */
	public List<ASTToken> ctype(){
		ArrayList<ASTToken> al1 = new ArrayList<ASTToken>();

		ASTToken ts = ctype1();
		al1.add(ts);

		nxtToken = tknList.get(tokenIndex);
		if(pd_ctype(nxtToken.type)) {
			List<ASTToken> al2 = ctype();
			al1.addAll(al2);
		}

		return al1;
	}

	/*
	args ->
      e
	| arg_list
	 */
	public ArrayList<ASTParamsDeclarator> args() {
		nxtToken = tknList.get(tokenIndex);
		if(nxtToken.type.equals("')'")) { // 说明参数都扫完了
			return null;
		}
		else {
			ArrayList<ASTParamsDeclarator> al = argList();
			return al;
		}
	}

	/*
	arg_list ->
	  arg ',' arg_list
	| arg
	 */
	public ArrayList<ASTParamsDeclarator> argList() {
		ArrayList<ASTParamsDeclarator> pdl = new ArrayList<ASTParamsDeclarator>();
		ASTParamsDeclarator pd = arg();
		pdl.add(pd);

		nxtToken = tknList.get(tokenIndex);
		if(nxtToken.type.equals("','")) { // 如果后面还有参数
			matchToken("','");
			ArrayList<ASTParamsDeclarator> pdl2 = argList();
			pdl.addAll(pdl2);
		}

		return pdl;
	}

	/*
	arg ->
	  ctype declarator
	 */
	public ASTParamsDeclarator arg() {
		ASTParamsDeclarator pd = new ASTParamsDeclarator();
		List<ASTToken> ss = ctype();
		pd.specfiers = ss;
		pd.children.addAll(ss);

		ASTDeclarator vd = declarator();
		pd.declarator = vd;
		pd.children.add(vd);

		return pd;
	}

	/*
	code_block ->
	  '{' states '}'
	 */
	public ASTCompoundStatement code_block() {
		matchToken("'{'");
		ASTCompoundStatement cs = new ASTCompoundStatement();
		ArrayList<ASTNode> ss = stmts();
		cs.blockItems = ss;
		if(ss != null)
			cs.children.addAll(ss);
		matchToken("'}'");

		return cs;
	}

	/*
	stmts ->
      e
	| stmt stmts
	| decl stmts
	 */
	public ArrayList<ASTNode> stmts() {
		ArrayList<ASTNode> sl = new ArrayList<ASTNode>();
		nxtToken = tknList.get(tokenIndex);
		//System.out.println(nextToken.type);
		if(nxtToken.type.equals("'}'")) { // code_block结束
			return null;
		}
		else {
			if(pd_ctype(nxtToken.type)) {
				ASTDeclaration s = decl();	// 声明类语句
				sl.add(s);
			}
			else {
				ASTStatement s = stmt();	// 普通语句
				sl.add(s);
			}

			ArrayList<ASTNode> sl2 = stmts();
			if(sl2 != null) {
				sl.addAll(sl2);
			}
			return sl;
		}
	}

	/*
	decl ->
	  ctype init_declarator_list ';'
	 */
	public ASTDeclaration decl() {
		ASTDeclaration d = new ASTDeclaration();
		ArrayList<ASTToken> ss = new ArrayList<>();
		ss.addAll(ctype());
		ArrayList<ASTInitList> initlist = init_declarator_list();
		matchToken("';'");

		d.specifiers = ss;
		d.initLists = initlist;
		d.children.addAll(ss);
		d.children.addAll(initlist);

		return d;
	}

	/*
	init_declarator_list ->
	  init_declarator
	| init_declarator ',' init_declarator_list
	 */
	public ArrayList<ASTInitList> init_declarator_list(){
		ArrayList<ASTInitList> il = new ArrayList<ASTInitList>();
		ASTInitList idec = init_declarator();
		il.add(idec);

		nxtToken = tknList.get(tokenIndex);
		if(nxtToken.type.equals("','")) {
			matchToken("','");
			ArrayList<ASTInitList> il2 = init_declarator_list();
			il.addAll(il2);
		}

		return il;
	}

	/*
	init_declarator ->
	  declarator
	| declarator '=' exp_assign
	 */
	public ASTInitList init_declarator() {
		ASTInitList idec = new ASTInitList();
		idec.declarator = declarator();
		idec.children.add(idec.declarator);
		idec.exprs = new ArrayList<ASTExpression>();
		if(tknList.get(tokenIndex).type.equals("'='")) {
			matchToken("'='");
			ASTExpression ea=exp_assign();
			idec.children.add(ea);
		}
		return idec;
	}

	/*
	declarator ->
	  identifier post_declarator
	 */
	public ASTDeclarator declarator() {
		ASTIdentifier id = new ASTIdentifier();
		id.tokenId = tokenIndex;
		id.value = tknList.get(tokenIndex).lexme;
		matchToken("Identifier");
		ASTVariableDeclarator vd = new ASTVariableDeclarator();
		vd.identifier = id;
		vd.children.add(id);

		return post_declarator(vd);
	}

	/*
	post_declarator ->
	  e
	| '[' ']'	post_declarator
	| '[' exp_assign ']' post_declarator
	 */
	public ASTDeclarator post_declarator(ASTDeclarator vd) {
		if(tknList.get(tokenIndex).type.equals("'['")) {
			matchToken("'['");
			ASTArrayDeclarator ad = new ASTArrayDeclarator();
			ad.declarator = vd;
			ad.children.add(vd);
			ASTExpression ea = exp_assign();
			ad.expr = ea;
			ad.children.add(ea);
			matchToken("']'");
			return post_declarator(ad);
		}
		else {
			return vd;
		}
	}

	/*
	stmt ->
	  code_block
	| select_stmt
	| iteration_stmt
	| return_stmt
	| exp_stmt
	 */
	public ASTStatement stmt() {
		nxtToken = tknList.get(tokenIndex);

		if(nxtToken.type.equals("'{'")) {
			return code_block();
		}
		else if(nxtToken.type.equals("'if'")) {
			return select_stmt();
		}
		else if(nxtToken.type.equals("'for'")) {
			return iteration_stmt();
		}
		else if(nxtToken.type.equals("'return'")) {
			return return_stmt();
		}
		else{
			return exp_stmt();
		}
	}

	/*
	select_stmt ->
	  'if' '(' exp ')' stmt
	 */
	public ASTSelectionStatement select_stmt() {
		ASTSelectionStatement ss = new ASTSelectionStatement();
		matchToken("'if'");
		matchToken("'('");
		LinkedList<ASTExpression> cond = new LinkedList<>(exp());
		matchToken("')'");
		ASTStatement then1 = stmt();
		ss.cond = cond;
		ss.then = then1;
		ss.children.addAll(cond);
		ss.children.add(then1);
		return ss;
	}

	/*
	iteration_stmt ->
	  'for' '(' exp ';' exp ';' exp ')' stmt
	| 'for' '(' decl ';' exp ';' exp ')' stmt
	 */
	public ASTStatement iteration_stmt() {
		matchToken("'for'");
		matchToken("'('");

		if(pd_ctype(tknList.get(tokenIndex).type)) {	// 走decl
			ASTIterationDeclaredStatement is = new ASTIterationDeclaredStatement();
			ASTDeclaration id = decl();
			LinkedList<ASTExpression> iter2;
			LinkedList<ASTExpression> iter3;

			iter2 = new LinkedList<>(exp());
			matchToken("';'");
			iter3 = new LinkedList<>(exp());
			matchToken("')'");
			ASTStatement s = stmt();

			is.init = id;
			is.cond = iter2;
			is.step = iter3;
			is.stat = s;
			is.children.add(id);
			is.children.addAll(iter2);
			is.children.addAll(iter3);
			is.children.add(s);

			return is;
		}
		else {
			ASTIterationStatement is = new ASTIterationStatement();
			LinkedList<ASTExpression> ie;
			LinkedList<ASTExpression> iter2;
			LinkedList<ASTExpression> iter3;

			ie = new LinkedList<>(exp());
			matchToken("';'");
			iter2 = new LinkedList<>(exp());
			matchToken("';'");
			iter3 = new LinkedList<>(exp());
			matchToken("')'");
			ASTStatement s = stmt();

			is.init = ie;
			is.cond = iter2;
			is.step = iter3;
			is.stat = s;
			is.children.addAll(ie);
			is.children.addAll(iter2);
			is.children.addAll(iter3);
			is.children.add(s);

			return is;
		}
	}

	/*
	return_stmt ->
	  'return' exp_assign ';'
	| 'return' ';'
	 */
	public ASTReturnStatement return_stmt() {
		matchToken("'return'");
		ASTReturnStatement rs = new ASTReturnStatement();
		if(!tknList.get(tokenIndex).type.equals("';'")) {
			ASTExpression e = exp_assign();
			rs.expr.add(e);
			rs.children.add(e);
		}
		else {
			rs.expr = null;
		}
		matchToken("';'");
		return rs;
	}

	/*
	exp_stmt ->
	  exp ';'
	| ';'
	 */
	public ASTExpressionStatement exp_stmt() {
		ASTExpressionStatement es = new ASTExpressionStatement();
		if(!tknList.get(tokenIndex).type.equals("';'")) {
			ArrayList<ASTExpression> e = exp();
			es.exprs = e;
			es.children.addAll(e);
		}
		matchToken("';'");
		return es;
	}

	/*
	exp ->
	  exp_assign ',' exp
	| exp_assign
	 */
	public ArrayList<ASTExpression> exp(){
		ArrayList<ASTExpression> ealist = new ArrayList<ASTExpression>();
		ASTExpression ea = exp_assign();
		ealist.add(ea);

		nxtToken = tknList.get(tokenIndex);
		if(nxtToken.type.equals("','")) {
			matchToken("','");
			ArrayList<ASTExpression> ealist2 = exp();
			ealist.addAll(ealist2);
		}

		return ealist;
	}

	/*
	exp_assign ->
	  exp_compare
	| exp_postfix operator_assign exp_assign
	 */
	public ASTExpression exp_assign() {
		int pos = 0;
		int cnt_small = 0;
		int cnt_middle = 0;
		int cnt_big = 0;//System.out.println(tknList.get(tokenIndex).type);
		while(tknList.size() > pos + tokenIndex &&
				!tknList.get(pos + tokenIndex).type.equals("','") &&
				!tknList.get(pos + tokenIndex).type.equals("';'")) { // 不能扫到, ;不然影响文法识别
			if(pd_operator_assign(tknList.get(pos + tokenIndex).type)) {
				ASTBinaryExpression be = new ASTBinaryExpression();
				ASTExpression exp1 = exp_postfix();
				ASTToken op = operator_assign();
				ASTExpression exp2 = exp_assign();
				be.expr1 = exp1;
				be.op = op;
				be.expr2 = exp2;
				be.children.add(exp1);
				be.children.add(exp2);
				be.children.add(op);
				return be;
			}
			else if(tknList.get(tokenIndex + pos).type.equals("'('")) {
				cnt_small ++;
			}
			else if(tknList.get(tokenIndex + pos).type.equals("'['")) {
				cnt_middle ++;
			}
			else if(tknList.get(tokenIndex + pos).type.equals("'{'")) {
				cnt_big ++;
			}
			else if(tknList.get(tokenIndex + pos).type.equals("')'")) {
				cnt_small --;
			}
			else if(tknList.get(tokenIndex + pos).type.equals("']'")) {
				cnt_middle --;
			}
			else if(tknList.get(tokenIndex + pos).type.equals("'}'")) {
				cnt_big --;
			}
			if(cnt_small < 0 || cnt_middle < 0 || cnt_big < 0) {// 括号不匹配说明已经超前查多了
				break;
			}
			pos ++;
		}
		return exp_compare();
	}

	/*
	exp_compare ->
	  exp_addsub
	| exp_addsub '<' exp_compare
	| exp_addsub '>' exp_compare
	| exp_addsub '<=' exp_compare
	| exp_addsub '>=' exp_compare
	 */
	public ASTExpression exp_compare() {
		ASTExpression es = exp_addsub();
		if(tknList.get(tokenIndex).type.equals("'<'") ||
				tknList.get(tokenIndex).type.equals("'>'") ||
				tknList.get(tokenIndex).type.equals("'<='") ||
				tknList.get(tokenIndex).type.equals("'>='")) {
			ASTToken op = getToken();
			ASTBinaryExpression er = new ASTBinaryExpression();
			ASTExpression er2 = exp_compare();
			er.expr1 = es;
			er.expr2 = er2;
			er.op = op;
			er.children.add(es);
			er.children.add(er2);
			er.children.add(op);
			return er;

		}else {
			return es;
		}
	}

	/*
	exp_addsub ->
	  exp_muldiv
	| exp_muldiv '+' exp_addsub
	| exp_muldiv '-' exp_addsub
	 */
	public ASTExpression exp_addsub() {
		ASTExpression em = exp_muldiv();
		if(tknList.get(tokenIndex).type.equals("'+'") ||
				tknList.get(tokenIndex).type.equals("'-'")) {
			ASTToken op = getToken();
			//System.out.println(op.value);
			ASTBinaryExpression ea = new ASTBinaryExpression();
			ASTExpression ea2 = exp_addsub();
			ea.expr1 = em;
			ea.expr2 = ea2;
			ea.op = op;
			ea.children.add(em);
			ea.children.add(ea2);
			ea.children.add(op);
			return ea;
		}
		else {
			return em;
		}
	}

	/*
	exp_muldiv ->
	  exp_postfix
	| exp_postfix '*' exp_muldiv
	| exp_postfix '/' exp_muldiv
	| exp_postfix '%' exp_muldiv
	 */
	public ASTExpression exp_muldiv() {
		ASTExpression ec = exp_postfix();
		if(tknList.get(tokenIndex).type.equals("'*'") ||
				tknList.get(tokenIndex).type.equals("'/'") ||
				tknList.get(tokenIndex).type.equals("'%'")) {
			ASTToken op = getToken();
			ASTBinaryExpression em = new ASTBinaryExpression();
			ASTExpression em2 = exp_muldiv();
			em.expr1 = ec;
			em.expr2 = em2;
			em.op = op;
			em.children.add(ec);
			em.children.add(em2);
			em.children.add(op);
			return em;
		}
		else {
			return ec;
		}
	}

	/*
	exp_postfix ->
	  exp_unit exp_postfix1
	 */
	public ASTExpression exp_postfix() {
		ASTExpression epri = exp_unit();
		ASTExpression node = epri;
		ASTExpression ep = exp_postfix1(node);
		return ep;
	}

	/*
	exp_postfix1 ->
	  e
    | '[' exp ']' exp_postfix1
	| '(' exp ')' exp_postfix1
	| '(' ')' exp_postfix1
	| '++' exp_postfix1
	| '--' exp_postfix1
	 */
	public ASTExpression exp_postfix1(ASTExpression node) {
		if(tknList.get(tokenIndex).type.equals("'['")) {
			ASTArrayAccess aa = new ASTArrayAccess();
			ASTExpression arrayName = node;
			List<ASTExpression> elements = new ArrayList<ASTExpression>();

			matchToken("'['");
			elements = exp();
			matchToken("']'");

			aa.arrayName = arrayName;
			aa.elements = elements;
			aa.children.add(arrayName);
			aa.children.addAll(elements);

			return exp_postfix1(aa);
		}
		else if(tknList.get(tokenIndex).type.equals("'('")) {
			ASTFunctionCall fc = new ASTFunctionCall();
			ASTExpression funcname = node;
			List<ASTExpression> argList = new ArrayList<ASTExpression>();

			matchToken("'('");
			if(!tknList.get(tokenIndex).type.equals("')'")) {
				argList = exp();
			}

			matchToken("')'");

			fc.funcname = funcname;
			fc.argList = argList;
			fc.children.add(funcname);
			if(argList != null)
				fc.children.addAll(argList);

			return exp_postfix1(fc);
		}
		else if(tknList.get(tokenIndex).type.equals("'++'") ||
				tknList.get(tokenIndex).type.equals("'--'")) {
			ASTPostfixExpression pe = new ASTPostfixExpression();
			ASTExpression expr = node;
			ASTToken op = getToken();

			pe.expr = expr;
			pe.op = op;
			pe.children.add(expr);
			pe.children.add(op);

			return exp_postfix1(pe);
		}
		else {
			return node;
		}
	}


	/*
	exp_unit ->
      e
    | identifier
	| IntegerConstant
	| StringLiteral
	| '(' exp_assign ')'
	 */
	public ASTExpression exp_unit() {
		nxtToken = tknList.get(tokenIndex);
		if(nxtToken.type.equals("Identifier")) {
			ASTIdentifier id = new ASTIdentifier();
			id.tokenId = tokenIndex;
			id.value = nxtToken.lexme;
			matchToken("Identifier");
			return id;
		}
		else if(nxtToken.type.equals("IntegerConstant")) {
			ASTIntegerConstant ic = new ASTIntegerConstant();
			ic.tokenId = tokenIndex;
			ic.value = Integer.parseInt(nxtToken.lexme);
			matchToken("IntegerConstant");
			return ic;
		}
		else if(nxtToken.type.equals("StringLiteral")) {
			ASTStringConstant sl = new ASTStringConstant();
			sl.tokenId = tokenIndex;
			sl.value = nxtToken.lexme;
			matchToken("StringLiteral");
			return sl;
		}
		else {
			return null;
		}
	}

	public ASTToken ctype1() {
		ScannerToken st = tknList.get(tokenIndex);
		// 取出Token进行比较
		ASTToken t = new ASTToken();
		if(pd_ctype(st.type)) {
			t.tokenId = tokenIndex;
			t.value = st.lexme;
			tokenIndex ++;
		}
		return t;
	}

	public ASTToken operator_assign() {
		ScannerToken st = tknList.get(tokenIndex);

		ASTToken t = new ASTToken();
		if(pd_operator_assign(st.type)) {
			t.tokenId = tokenIndex;
			t.value = st.lexme;
			tokenIndex++;
		}
		return t;
	}
}