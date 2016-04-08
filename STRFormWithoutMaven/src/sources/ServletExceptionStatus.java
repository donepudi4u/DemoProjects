package sources;

import javax.servlet.ServletException;

/**
 * Servlet exception that allows the status code to throw to be included.
 *
 * @author Kenneth Gendron
 */
public class ServletExceptionStatus extends ServletException {
    
    private static final long serialVersionUID = 1L;
    
    private final int status;
    
    public ServletExceptionStatus(int status) {
        super();
        this.status = status;
    }
    
    public ServletExceptionStatus(String message, int status) {
        super(message);
        this.status = status;
    }
    
    public ServletExceptionStatus(String message, Throwable t, int status) {
        super(message, t);
        this.status = status;
    }
    
    public ServletExceptionStatus(Throwable t, int status) {
        super(t);
        this.status = status;
    }
    
    public int getStatus() {
        return status;
    }
    
}
