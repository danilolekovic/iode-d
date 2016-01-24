package iode.scanning;

public interface ILexer {
	Token peekToken();
	Token peekSpecific(int i);
	Token nextToken();
	void tokenize();
}
