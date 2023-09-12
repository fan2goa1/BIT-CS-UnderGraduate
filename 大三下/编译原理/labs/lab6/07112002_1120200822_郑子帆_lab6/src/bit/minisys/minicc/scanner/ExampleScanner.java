package bit.minisys.minicc.scanner;

import java.util.ArrayList;
import java.util.HashSet;

import bit.minisys.minicc.MiniCCCfg;
import bit.minisys.minicc.internal.util.MiniCCUtil;


enum DFA_STATE{
	DFA_STATE_INITIAL,
	DFA_STATE_ID_0,
	DFA_STATE_ID_1,
	DFA_STATE_KB_O,
	DFA_STATE_KB_C,
	DFA_STATE_P_O,
	DFA_STATE_P_C,
	DFA_STATE_ADD_0,
	DFA_STATE_ADD_1,
	DFA_STATE_SM,
	
	DFA_STATE_UNKNW
}

public class ExampleScanner implements IMiniCCScanner {
	
	private int lIndex = 0;
	private int cIndex = 0;
	
    private ArrayList<String> srcLines;
    
    private HashSet<String> keywordSet;
    
    public ExampleScanner(){
    	this.keywordSet = new HashSet<String>();
    	this.keywordSet.add("int");
    	this.keywordSet.add("return");
    }

	private char getNextChar() {
		char c = Character.MAX_VALUE;
		while(true) {
			if(lIndex < this.srcLines.size()) {
				String line = this.srcLines.get(lIndex);
				if(cIndex < line.length()) {
					c = line.charAt(cIndex);
					cIndex++;
					break;
				}else {
					lIndex++;
					cIndex = 0;
				}
			}else {
				break;
			}
		}
		if(c == '\u001a') {
			c = Character.MAX_VALUE;
		}
		return c;
	}

	private boolean isAlpha(char c) {
		return Character.isAlphabetic(c);
	}

	private boolean isDigit(char c) {
		return Character.isDigit(c);
	}

	private boolean isAlphaOrDigit(char c) {
		return Character.isLetterOrDigit(c);
	}
	
	private String genToken(int num, String lexme, String type) {
		return genToken(num, lexme, type, this.cIndex - 1, this.lIndex);
	}
	private String genToken2(int num, String lexme, String type) {
		return genToken(num, lexme, type, this.cIndex - 2, this.lIndex);
	}
	private String genToken(int num, String lexme, String type, int cIndex, int lIndex) {
		String strToken = "";
		
		strToken += "[@" + num + "," + (cIndex - lexme.length() + 1) + ":" + cIndex;
		strToken += "='" + lexme + "',<" + type + ">," + (lIndex + 1) + ":" + (cIndex - lexme.length() + 1) + "]\n";
		
		return strToken;
	}
	
	@Override
	public String run(String iFile) throws Exception {
		
		System.out.println("Scanning...");
		String strTokens = "";
		int iTknNum = 0;

		this.srcLines = MiniCCUtil.readFile(iFile);
        
        DFA_STATE state = DFA_STATE.DFA_STATE_INITIAL;		//FA state
		String lexme 	= "";		//token lexme
		char c 			= ' ';		//next char
		boolean keep 	= false;	//keep current char
		boolean end 	= false;
		
		while(!end) {				//scanning loop
			if(!keep) {
				c = getNextChar();
			}
			
			keep = false;

			switch(state) {
			case DFA_STATE_INITIAL:	
				lexme = "";
				
				if(isAlpha(c)) {
					state = DFA_STATE.DFA_STATE_ID_0;
					lexme = lexme + c;
				}else if(c == '+') {
					state = DFA_STATE.DFA_STATE_ADD_0;
					lexme = lexme + c;
				}else if(c == '-') {
					strTokens += genToken(iTknNum, "-", "'-'");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}else if(c == '{') {
					strTokens += genToken(iTknNum, "{", "'{'");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}else if(c == '}') {
					strTokens += genToken(iTknNum, "}", "'}'");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}else if(c == '(') {
					strTokens += genToken(iTknNum, "(", "'('");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}else if(c == ')') {
					strTokens += genToken(iTknNum, ")", "')'");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}else if(c == ';') {
					strTokens += genToken(iTknNum, ";", "';'");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}
				else if(c == ',') {
					strTokens += genToken(iTknNum, ",", "','");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
				}else if(Character.isSpace(c)) {
					
				}else if(c == Character.MAX_VALUE) {
					cIndex = 5;
					strTokens += genToken(iTknNum, "<EOF>", "EOF");
					end = true;
				}
				break;
			case DFA_STATE_ADD_0:
				if(c == '+') {
					//TODO:++
				}else {
					strTokens += genToken2(iTknNum, "+", "'+'");
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
					keep = true;
				}
				state = DFA_STATE.DFA_STATE_INITIAL;
				break;
			case DFA_STATE_ID_0:
				if(isAlphaOrDigit(c)) {
					lexme = lexme + c;
				}else {
					if(this.keywordSet.contains(lexme)) {
						strTokens += genToken2(iTknNum, lexme, "'" + lexme + "'");
					}else {
						strTokens += genToken2(iTknNum, lexme, "Identifier");
					}
					iTknNum++;
					state = DFA_STATE.DFA_STATE_INITIAL;
					keep = true;
				}
				break;
			default:
				System.out.println("[ERROR]Scanner:line " + lIndex + ", column=" + cIndex + ", unreachable state!");
				break;
			}
		}
		
	
		String oFile = MiniCCUtil.removeAllExt(iFile) + MiniCCCfg.MINICC_SCANNER_OUTPUT_EXT;
		MiniCCUtil.createAndWriteFile(oFile, strTokens);
		
		return oFile;
	}

}
