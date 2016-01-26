package iode.exceptions;

@SuppressWarnings("serial")
public class ParserException extends Exception {
    public ParserException(String message, int line) {
        super(message + " on line #" + line + ".");
    }
    
    public ParserException(String message, String got, int line) {
        super(message + " on line #" + line + ", got '" + got + "'.");
    }
    
    public ParserException(String message, int line, String expected) {
        super(message + " on line #" + line + ". Expected " + expected + ".");
    }
    
    public ParserException(String message) {
        super(message);
    }
}