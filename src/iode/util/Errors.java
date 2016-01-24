package iode.util;

public class Errors
{
    @SuppressWarnings("unchecked")
    private static <T extends Throwable> void throwException(Throwable exception, Object dummy) throws T
    {
        throw (T) exception;
    }

    public static void throwException(Throwable exception)
    {
        Errors.<RuntimeException>throwException(exception, null);
    }
}