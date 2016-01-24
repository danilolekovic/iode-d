package iode.exceptions;

@SuppressWarnings("serial")
public class ParserException extends Exception {
    public ParserException(String message, int line) {
        super(message + " on line #" + line);
    }
    
    public ParserException(String message) {
        super(message);
    }
}