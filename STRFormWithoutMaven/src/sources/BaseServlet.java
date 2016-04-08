package sources;

import i18n.I18N;
import i18n.slf4j.I18NLogger;
import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.LoggerFactory;
import org.slf4j.Marker;
import org.slf4j.MarkerFactory;

/**
 * Base servlet that provides error handling functionality.
 * 
 * @author Kenneth Gendron
 */
public abstract class BaseServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Logger to use when logging statements.
     */
    protected static final I18NLogger logger = new I18NLogger(LoggerFactory.getLogger(BaseServlet.class), new I18N());
    
    private static final String LOGGER_MARKER = BaseServlet.class.getName();
    /**
     * Logger marker used to color logging statements, equal to <code>BaseServlet.class.getName()</code>.
     * 
     * @see I18NLogger#error(Marker, String)
     */
    protected static final Marker marker = MarkerFactory.getMarker(LOGGER_MARKER);
    
    /**
     * Does the actual work of the GET request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doGetImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method GET is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the HEAD request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doHeadImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method HEAD is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the POST request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doPostImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method POST is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the PUT request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doPutImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method PUT is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the DELETE request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doDeleteImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method DELETE is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the OPTIONS request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doOptionsImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method OPTIONS is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the TRACE request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doTraceImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        throw new ServletExceptionStatus("HTTP method TRACE is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Perform a GET request by delegating that responsibility to {@link #doGetImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doGet(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doGetImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    /**
     * Perform a HEAD request by delegating that responsibility to {@link #doHeadImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doHead(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doHeadImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    /**
     * Perform a POST request by delegating that responsibility to {@link #doPostImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doPostImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    /**
     * Perform a PUT request by delegating that responsibility to {@link #doPutImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doPut(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doPutImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    /**
     * Perform a DELETE request by delegating that responsibility to {@link #doDeleteImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doDelete(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doDeleteImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    /**
     * Perform a OPTIONS request by delegating that responsibility to {@link #doOptionsImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doOptions(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doOptionsImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    /**
     * Perform a TRACE request by delegating that responsibility to {@link #doTraceImpl(HttpServletRequest, HttpServletResponse)}.
     * <p>
     * If an exception is thrown, the {@link Throwable#getMessage() message} of the exception will
     * be sent to the client, with an error status of {@link HttpServletResponse#SC_INTERNAL_SERVER_ERROR 500}.
     * </p>
     * 
     * @param req request
     * @param resp response
     */
    @Override
    protected final void doTrace(HttpServletRequest req, HttpServletResponse resp) {
        try {
            doTraceImpl(req, resp);
        } catch (Throwable t) {
            handleError(resp, t);
        }
    }
    
    private static void handleError(HttpServletResponse resp, Throwable t) {
        logger.error(marker, "Servlet threw error.", t);
        try {
            resp.getWriter().append(t.getMessage());
        } catch (IOException e) {
        }
        resp.setStatus(t instanceof ServletExceptionStatus ? ((ServletExceptionStatus)t).getStatus() : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
    
}
