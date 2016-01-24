package iode.exceptions;

@SuppressWarnings("serial")
public class LexerException extends Exception {
    public LexerException(String message, int line) {
        super(message + " on line #" + line);
    }
    
    public LexerException(String message) {
        super(message);
    }
}