package iode.ast.nodes;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import iode.ast.Node;
import iode.generator.IodeGenerator;
import iode.parsing.IVisitor;
import iode.util.Errors;

public class ASTImport extends Node {

	private String module;
	
	public ASTImport(String module) {
		this.module = module;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		if (!module.startsWith("c")) { // TODO: Change this
			if (Files.exists(Paths.get(IodeGenerator.currentPath + File.separator + module + ".iode"))) {
				IodeGenerator.SilentCompile(Paths.get(IodeGenerator.currentPath + File.separator + module + ".iode").toString());
				return "#include \"" + module + ".c\"\n";
			} else {
				Errors.throwException(new Exception("Undefined module: " + module));
			}
		}
		
		return "#include <" + module.substring(1, module.length()) + ".h>\n";
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}
}
