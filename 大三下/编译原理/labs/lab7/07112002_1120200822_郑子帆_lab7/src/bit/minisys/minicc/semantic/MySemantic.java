package bit.minisys.minicc.semantic;

import bit.minisys.minicc.parser.ast.ASTCompilationUnit;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;

public class MySemantic implements IMiniCCSemantic {

    @Override
    public String run(String iFile) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        File f = new File(iFile);
        ASTCompilationUnit pro = mapper.readValue(f, ASTCompilationUnit.class);
        MyVisitor visitor = new MyVisitor();
        pro.accept(visitor);
        System.out.println("Semantic Finished!");
        return null;
    }
}
