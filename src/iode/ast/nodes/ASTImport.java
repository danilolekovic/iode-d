package iode.ast.nodes;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

import iode.ast.Node;
import iode.generator.IodeGenerator;
import iode.util.Errors;

public class ASTImport extends Node {

	private String module;
	private boolean cImport = false;
	
	public ASTImport(String module, boolean cImport) {
		this.module = module;
		this.cImport = cImport;
	}

	@Override
	public String generate() {
		if (!cImport) {
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

	public boolean iscImport() {
		return cImport;
	}

	public void setcImport(boolean cImport) {
		this.cImport = cImport;
	}
}
