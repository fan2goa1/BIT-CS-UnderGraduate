package bit.minisys.minicc.icgen;

import bit.minisys.minicc.parser.ast.ASTNode;
import bit.minisys.minicc.parser.ast.ASTVisitor;

public class TagLabel extends ASTNode {

    public String name; // 标签名
    public int dest;    //
    public TagLabel() {
        super("TagLabel");
        this.name = "";
        this.dest = -1;
    }
    public TagLabel(String Name) {
        super("TagLabel");
        this.name = Name;
        this.dest = -1;
    }
    public TagLabel(String Name, int Dest) {
        super("TagLabel");
        this.name = Name;
        this.dest = Dest;
    }

    @Override
    public void accept(ASTVisitor visitor) throws Exception {
        // TODO Auto-generated method stub

    }
}