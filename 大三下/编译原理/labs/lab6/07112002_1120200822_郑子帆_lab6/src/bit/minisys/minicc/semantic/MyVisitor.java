package bit.minisys.minicc.semantic;

import bit.minisys.minicc.parser.ast.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 符号表
class Symbol{
    public String name;  // 该标识符对应函数还是变量
    public String type;  // 该标识符的数据类型
    public List<String> params = new ArrayList<>();  // 若该标识符为函数，存储函数的参数列表
}
public class MyVisitor implements ASTVisitor {
    private Map<String, Symbol> symbolTableGlobal = new HashMap<>();
    private List<Map<String, Symbol>> symbolTableLocal = new ArrayList<>();
    private List<String> stateList = new ArrayList<>();
    private int scopeId = 0;
    private String exprType;
    private String arrayName;
    private int errorNum = 0;
    private Map<String, Boolean> labelMap = new HashMap<>();
    private List<String> gotoList = new ArrayList<>();
    private boolean funcReturn = true;

    private String outputName(String name){
        return "\"" + name + "\"";
    }
    private void output(String string, int errorId){
        if( errorNum == 0 ){
            System.out.println("Errors:");
            System.out.println("----------------------------------------------------");
        }
        System.out.println("ES" + errorId + " >> " + string);
        errorNum++;
    }
    private void outputEnd(){
        if( errorNum != 0 ){
            System.out.println("----------------------------------------------------");
        }
    }

    private boolean checkSymbolAdd(String symbolKey, Symbol symbol, Map<String, Symbol> symbolTable){
        if( symbolTable.get(symbolKey) == null ){
            symbolTable.put(symbolKey, symbol);
            return true;
        }
        output(symbol.name + ": " + outputName(symbolKey) + " is redefined.", 2);
        return false;
    }

    private void checkGotoLabel() {
        for(String gotoName: gotoList){
            if(labelMap.get(gotoName) == null) {
                output("GotoStatement: " + outputName(gotoName) + " is not defined.", 7);
            }
        }
    }

    @Override
    public void visit(ASTCompilationUnit program) throws Exception {
        for(int i = 0; i < program.items.size(); i++ ){
            ASTNode node = program.items.get(i);
            if(node instanceof ASTDeclaration) {
                this.visit((ASTDeclaration)node);
            }else if(node instanceof  ASTFunctionDefine) {
                this.visit((ASTFunctionDefine)node);
            }else {
                output("Program: global items must be declaration or function definition.", 0);
            }
        }
        outputEnd();
    }

    @Override
    public void visit(ASTDeclaration declaration) throws Exception {
        String type = getType(declaration.specifiers);
        for(ASTInitList initList : declaration.initLists) {
            this.visit(initList, type);
        }
    }

    @Override
    public void visit(ASTArrayDeclarator arrayDeclarator) throws Exception {}

    public void visit(ASTArrayDeclarator arrayDeclarator, String type) throws Exception {}

    @Override
    public void visit(ASTVariableDeclarator variableDeclarator) throws Exception {}

    public void visit(ASTVariableDeclarator variableDeclarator, String type) throws Exception {
        Symbol symbol = new Symbol();
        symbol.type = type;
        symbol.name = "Variable";
        String variableName = variableDeclarator.identifier.value;
        if(scopeId == 0){
            checkSymbolAdd(variableName, symbol, symbolTableGlobal);
        }else{
            checkSymbolAdd(variableName, symbol, symbolTableLocal.get(scopeId-1));
        }
    }

    @Override
    public void visit(ASTFunctionDeclarator functionDeclarator) throws Exception {}
    public void visit(ASTFunctionDeclarator functionDeclarator, String type) throws Exception {
        String functionName = ((ASTVariableDeclarator) functionDeclarator.declarator).identifier.value;
        if(scopeId != 0){
            output("FunctionDeclaration: " + outputName(functionName) + "  scope is not global.", 0);
            return;
        }
        Symbol symbol = new Symbol();
        symbol.type = type;
        symbol.name = "FunctionDeclaration";
        symbol.params = getParams(functionDeclarator.params);
        checkSymbolAdd(functionName, symbol, symbolTableGlobal);
    }

    @Override
    public void visit(ASTParamsDeclarator paramsDeclarator) throws Exception {

    }

    @Override
    public void visit(ASTArrayAccess arrayAccess) throws Exception {}

    private String checkBinaryOp(String type1, String type2, String op) {return "int";}

    @Override
    public void visit(ASTBinaryExpression binaryExpression) throws Exception {
        this.visit(binaryExpression.expr1);
        String type1 = exprType;
        this.visit(binaryExpression.expr2);
        String type2 = exprType;
        exprType = checkBinaryOp(type1, type2, binaryExpression.op.value);
    }

    @Override
    public void visit(ASTBreakStatement breakStat) throws Exception {
        for(int i = stateList.size()-1; i >= 0; i-- ){
            if(stateList.get(i).equals("Iteration")) return;
        }
        output("BreakStatement: \"break\" must be in a LoopStatement.", 3);
    }

    @Override
    public void visit(ASTContinueStatement continueStatement) throws Exception {}

    @Override
    public void visit(ASTCastExpression castExpression) throws Exception {
        this.visit(castExpression.expr);
    }

    @Override
    public void visit(ASTCharConstant charConst) throws Exception {exprType = "char";}

    public void visit(List<ASTNode> compoundStatBlockItems) throws Exception{
        if(compoundStatBlockItems != null) {
            for(ASTNode item : compoundStatBlockItems) {
                if(item instanceof ASTDeclaration) {
                    this.visit((ASTDeclaration) item);
                } else if(item instanceof ASTStatement) {
                    this.visit((ASTStatement) item);
                }
            }
        }
    }
    @Override
    public void visit(ASTCompoundStatement compoundStat) throws Exception {
        Map<String, Symbol> symbolTable = new HashMap<>();
        symbolTableLocal.add(symbolTable);
        scopeId++;
        this.visit(compoundStat.blockItems);
        scopeId--;
        symbolTableLocal.remove(scopeId);
    }
    public void visit(ASTCompoundStatement compoundStat, List<ASTParamsDeclarator> functionParams) throws Exception {
        Map<String, Symbol> symbolTable = new HashMap<>();
        symbolTableLocal.add(symbolTable);
        scopeId++;
        if(functionParams != null){
            for(ASTParamsDeclarator functionParam : functionParams){
                Symbol new_symbol = new Symbol();
                new_symbol.name = "Variable";
                new_symbol.type = getType(functionParam.specfiers);
                String variableName = ((ASTVariableDeclarator)functionParam.declarator).identifier.value;
                symbolTable.put(variableName, new_symbol);
            }
        }
        this.visit(compoundStat.blockItems);
        scopeId--;
        symbolTableLocal.remove(scopeId);
    }

    @Override
    public void visit(ASTConditionExpression conditionExpression) throws Exception {}

    @Override
    public void visit(ASTExpression expression) throws Exception {
        if(expression instanceof ASTIdentifier){
            this.visit((ASTIdentifier)expression);
        }else if(expression instanceof ASTArrayAccess){
            this.visit((ASTArrayAccess)expression);
        }else if(expression instanceof ASTBinaryExpression){
            this.visit((ASTBinaryExpression)expression);
        }else if(expression instanceof ASTCastExpression){
            this.visit((ASTCastExpression)expression);
        }else if(expression instanceof ASTCharConstant){
            this.visit((ASTCharConstant)expression);
        } else if(expression instanceof ASTConditionExpression){
            this.visit((ASTConditionExpression)expression);
        }else if(expression instanceof ASTFloatConstant){
            this.visit((ASTFloatConstant)expression);
        }else if(expression instanceof ASTFunctionCall){
            this.visit((ASTFunctionCall)expression);
        }else if(expression instanceof ASTIntegerConstant){
            this.visit((ASTIntegerConstant)expression);
        }else if(expression instanceof ASTMemberAccess){
            this.visit((ASTMemberAccess)expression);
        }else if(expression instanceof ASTPostfixExpression){
            this.visit((ASTPostfixExpression)expression);
        }else if(expression instanceof ASTStringConstant){
            this.visit((ASTStringConstant)expression);
        }else if(expression instanceof ASTUnaryExpression){
            this.visit((ASTUnaryExpression)expression);
        }else if(expression instanceof ASTUnaryTypename){
            this.visit((ASTUnaryTypename)expression);
        }
    }

    @Override
    public void visit(ASTExpressionStatement expressionStat) throws Exception {
        if( expressionStat.exprs != null ){
            for(ASTExpression expression: expressionStat.exprs){
                this.visit(expression);
            }
        }
    }

    @Override
    public void visit(ASTFloatConstant floatConst) throws Exception {exprType = "double";}

    @Override
    public void visit(ASTFunctionCall funcCall) throws Exception {
        String functionName = ((ASTIdentifier)funcCall.funcname).value;
        if( symbolTableGlobal.get(functionName) == null ){
            output("FunctionCall: " + outputName(functionName) + " is not defined.", 1);
            exprType = "int";
            return;
        }
        Symbol symbol = symbolTableGlobal.get(functionName);
        exprType = symbol.type;
        if(funcCall.argList.size() != symbol.params.size()) {
            output("FunctionCall: " + outputName(functionName) + " param num is not matched.", 4);
            return;
        }
        for(int i = 0; i < symbol.params.size(); i++){
            this.visit(funcCall.argList.get(i));
            if(!exprType.equals(symbol.params.get(i))) {
                output("FunctionCall: " + outputName(functionName) + " param type is not matched.", 4);
                return;
            }
        }
        exprType = symbol.type;
    }

    @Override
    public void visit(ASTGotoStatement gotoStat) throws Exception {
        String gotoName = gotoStat.label.value;
        gotoList.add(gotoName);
    }

    @Override
    public void visit(ASTIdentifier identifier) throws Exception {
        String identifierName = identifier.value;
        Symbol symbol = null;
        boolean flag = false;
        for(int i = scopeId-1; i >= 0; i--){
            Map<String, Symbol> symbolTable = symbolTableLocal.get(i);
            if( symbolTable.get(identifierName) != null ){
                symbol = symbolTable.get(identifierName);
                flag = true;
            }
        }
        if( !flag ){
            if(symbolTableGlobal.get(identifierName) == null ){
                output("Variable: " + outputName(identifierName) + " is not defined.", 1);
                exprType = "int";
                return;
            }else{
                symbol = symbolTableGlobal.get(identifierName);
            }
        }
        if(!symbol.name.equals("Variable")){
            output("Variable: " + outputName(identifierName) + " is defined as function.", 2);
        }
        exprType = symbol.type;
    }

    @Override
    public void visit(ASTInitList initList) throws Exception {}

    public void visit(ASTInitList initList, String type) throws Exception {
        this.visit(initList.declarator, type);
        if( initList.exprs != null ){
            for(ASTExpression expr: initList.exprs){
                this.visit(expr);
                checkBinaryOp(type, exprType, "=");
            }
        }
    }

    @Override
    public void visit(ASTIntegerConstant intConst) throws Exception {
        exprType = "int";
    }
    @Override
    public void visit(ASTIterationDeclaredStatement iterationDeclaredStat) throws Exception {
        Map<String, Symbol> symbolTable = new HashMap<>();
        symbolTableLocal.add(symbolTable);
        scopeId++;
        this.visit(iterationDeclaredStat.init);
        if(iterationDeclaredStat.cond != null) {
            for (ASTExpression cond : iterationDeclaredStat.cond) {
                this.visit(cond);
            }
        }
        if(iterationDeclaredStat.step != null) {
            for (ASTExpression step : iterationDeclaredStat.step) {
                this.visit(step);
            }
        }
        stateList.add("Iteration");
        this.visit(iterationDeclaredStat.stat);
        stateList.remove(stateList.size()-1);
        scopeId--;
        symbolTableLocal.remove(scopeId);
    }

    @Override
    public void visit(ASTIterationStatement iterationStat) throws Exception {
        if(iterationStat.init != null) {
            for(ASTExpression init: iterationStat.init){
                this.visit(init);
            }
        }
        if(iterationStat.cond != null){
            for(ASTExpression cond: iterationStat.cond){
                this.visit(cond);
            }
        }
        if(iterationStat.step != null) {
            for (ASTExpression step : iterationStat.step) {
                this.visit(step);
            }
        }
        stateList.add("Iteration");
        this.visit(iterationStat.stat);
        stateList.remove(stateList.size()-1);
    }

    @Override
    public void visit(ASTLabeledStatement labeledStat) throws Exception {
        String labelName = labeledStat.label.value;
        if(labelMap.get(labelName) == null){
            labelMap.put(labelName, true);
        }else{
            output("LabeledStatement: " + outputName(labelName) + " is redefined.", 0);
        }
        this.visit(labeledStat.stat);
    }

    @Override
    public void visit(ASTMemberAccess memberAccess) throws Exception {}
    @Override
    public void visit(ASTPostfixExpression postfixExpression) throws Exception {
        this.visit(postfixExpression.expr);
    }
    @Override
    public void visit(ASTReturnStatement returnStat) throws Exception {funcReturn = true;}
    @Override
    public void visit(ASTSelectionStatement selectionStat) throws Exception {}
    @Override
    public void visit(ASTStringConstant stringConst) throws Exception {exprType = "string";}
    @Override
    public void visit(ASTTypename typename) throws Exception {}
    @Override
    public void visit(ASTUnaryExpression unaryExpression) throws Exception {}
    @Override
    public void visit(ASTUnaryTypename unaryTypename) throws Exception {}

    private String getType(List<ASTToken> specifiers) {
        StringBuilder type = new StringBuilder();
        if( specifiers != null ){
            for (ASTToken specifier : specifiers) {
                type.append(specifier.value);
            }
        }
        return type.toString();
    }

    private boolean checkFunctionDefineParams(List<ASTParamsDeclarator> functionParams, Symbol symbol) {
        if( functionParams.size() != symbol.params.size() ) return false;
        for(int i = 0; i < functionParams.size(); i++ ){
            String type1 = getType(functionParams.get(i).specfiers);
            String type2 = symbol.params.get(i);
            if(!type1.equals(type2)) return false;
        }
        return true;
    }

    private List<String> getParams(List<ASTParamsDeclarator> functionParams) {
        List<String>params = new ArrayList<>();
        if( functionParams != null ){
            for(ASTParamsDeclarator functionParam: functionParams){
                params.add(getType(functionParam.specfiers));
            }
        }
        return params;
    }

    @Override
    public void visit(ASTFunctionDefine functionDefine) throws Exception {
        String type = getType(functionDefine.specifiers);
        ASTFunctionDeclarator functionDeclarator = (ASTFunctionDeclarator)functionDefine.declarator;
        ASTVariableDeclarator variableDeclarator = (ASTVariableDeclarator)functionDeclarator.declarator;
        String functionName = variableDeclarator.identifier.value;
        List<ASTParamsDeclarator> functionParams = functionDeclarator.params;
        if(scopeId != 0) {
            output("FunctionDefine: " + outputName(functionName) + " scope is not global.", 0);
            return;
        }
        Symbol symbol;
        if(symbolTableGlobal.get(functionName) != null) {
            symbol = symbolTableGlobal.get(functionName);
            if(symbol.name.equals("FunctionDeclaration")){
                symbol.name = "FunctionDefine";
                if(!symbol.type.equals(type) || !checkFunctionDefineParams(functionParams, symbol)) {
                    output("FunctionDefine: " + outputName(functionName) + " definition and declaration not match.", 4);
                    return;
                }
            }else{
                output("FunctionDefine: " + outputName(functionName) + " is redefined.", 2);
                return;
            }
        }else{
            symbol = new Symbol();
            symbol.type = type;
            symbol.name = "FunctionDefine";
            symbol.params = getParams(functionParams);
            symbolTableGlobal.put(functionName, symbol);
        }
        stateList.add("FunctionDefine");
        funcReturn = false;
        this.visit(functionDefine.body, functionParams);
        stateList.remove(stateList.size()-1);
        symbolTableLocal.clear();
        checkGotoLabel();
        gotoList.clear();
        labelMap.clear();
    }

    @Override
    public void visit(ASTDeclarator declarator) throws Exception {}

    public void visit(ASTDeclarator declarator, String type) throws Exception {
        if(declarator instanceof ASTVariableDeclarator){
            this.visit((ASTVariableDeclarator)declarator, type);
        }else if(declarator instanceof  ASTFunctionDeclarator){
            this.visit((ASTFunctionDeclarator)declarator, type);
        }else if(declarator instanceof ASTArrayDeclarator){
            this.visit((ASTArrayDeclarator)declarator, type);
        }
    }

    @Override
    public void visit(ASTStatement statement) throws Exception {
        if(statement instanceof  ASTBreakStatement) {
            this.visit((ASTBreakStatement)statement);
        }else if(statement instanceof ASTCompoundStatement){
            this.visit((ASTCompoundStatement)statement);
        }else if(statement instanceof ASTContinueStatement){
            this.visit((ASTContinueStatement)statement);
        }else if(statement instanceof ASTExpressionStatement){
            this.visit((ASTExpressionStatement)statement);
        }else if(statement instanceof ASTGotoStatement){
            this.visit((ASTGotoStatement)statement);
        }else if(statement instanceof ASTIterationDeclaredStatement){
            this.visit((ASTIterationDeclaredStatement)statement);
        }else if(statement instanceof  ASTIterationStatement){
            this.visit(( ASTIterationStatement)statement);
        }else if(statement instanceof ASTLabeledStatement){
            this.visit((ASTLabeledStatement)statement);
        }else if(statement instanceof ASTReturnStatement){
            this.visit((ASTReturnStatement)statement);
        }else if(statement instanceof ASTSelectionStatement){
            this.visit((ASTSelectionStatement)statement);
        }
    }

    @Override
    public void visit(ASTToken token) throws Exception {}
}
