package iode.generator;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import iode.ast.Node;
import iode.parsing.Parser;
import iode.scanning.Lexer;

public class IodeGenerator {
	public static void Generate(String filename) {
		String os = System.getProperty("os.name").toLowerCase();
		Systems system = detectOS(os);
		
		List<String> lines = null;
		
		try {
			lines = Files.readAllLines(Paths.get(filename),
			        Charset.defaultCharset());
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		StringBuilder codeBuilder = new StringBuilder();
		
        for (String line : lines) {
            codeBuilder.append(line + "\n");
        }
        
        String code = codeBuilder.toString();
		
		Lexer lexer = new Lexer(code);
		lexer.tokenize();
		
		Parser parser = new Parser(lexer);
		ArrayList<Node> ast = new ArrayList<Node>();
		
		while (parser.getPos() != parser.getTotalTokens()) {
			ast.add(parser.start());
		}
		
		StringBuilder cBuilder = new StringBuilder();
		
		for (Node n : ast) {
			cBuilder.append(n.generate());
		}
		
		String cCode = cBuilder.toString();
		
		PrintWriter writer;
		
		try {
			writer = new PrintWriter(Paths.get(filename.replace(".iode", ".c")).toString(), "UTF-8");
			writer.print(cCode);
			writer.close();
		} catch (FileNotFoundException | UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		if (system == Systems.WINDOWS) {
			String windowsCompiler = "C:\\MinGW\\bin\\gcc.exe";
			
			Runtime rt = Runtime.getRuntime();
			String[] commands = { windowsCompiler, "-o", Paths.get(filename.replace(".iode", ".exe")).toString(), Paths.get(filename.replace(".iode", ".c")).toString() };
			String[] execCommands = { Paths.get(filename.replace(".iode", ".exe")).toString() };
			Process proc = null;
			
			try {
				proc = rt.exec(commands);
				proc.waitFor();
				proc = rt.exec(execCommands);
			} catch (IOException | InterruptedException e) {
				e.printStackTrace();
			}

			BufferedReader stdInput = new BufferedReader(new 
			     InputStreamReader(proc.getInputStream()));

			BufferedReader stdError = new BufferedReader(new 
			     InputStreamReader(proc.getErrorStream()));

			String s = null;
			
			try {
				while ((s = stdInput.readLine()) != null) {
				    System.out.println(s);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			try {
				while ((s = stdError.readLine()) != null) {
				    System.out.println(s);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else if (system == Systems.MAC) {
			// TODO: Mac support
		} else if (system == Systems.LINUX) {
			// TODO: Linux support
		}
	}
	
	public static Systems detectOS(String os) {
        if (isWindows(os)) {
        	return Systems.WINDOWS;
        } else if (isMac(os)) {
        	return Systems.MAC;
        } else if (isUnix(os)) {
        	return Systems.LINUX;
        } else {
        	return Systems.WINDOWS;
        }
    }

    private static boolean isWindows(String OS) {
        return (OS.indexOf("win") >= 0);
    }

    private static boolean isMac(String OS) {
        return (OS.indexOf("mac") >= 0);
    }

    private static boolean isUnix(String OS) {
        return (OS.indexOf("nux") >= 0);
    }
}
