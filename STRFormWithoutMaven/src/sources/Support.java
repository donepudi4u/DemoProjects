package sources;

import automation.config.Constants;
import com.google.common.reflect.ClassPath;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.Set;
import java.util.TreeSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import processflow.ProcessHandler;
import processflow.ProcessHandlers;
import processflow.Var;

/**
 * Support class for automation administration.
 * 
 * @author Kenneth Gendron
 * 
 * @version 1.0
 */
public class Support {
    
    private Support() {}
    
    //Version of web application
    private static final String version;

    //Find all images in web application, and create a version string
    static {
        //Find the web application directory
        String clz = Support.class.getName().replace(".", "/") + ".class";
        String loc = Support.class.getClassLoader().getResource(clz).getPath();
        File dir = new File(loc.substring(0, loc.length()-clz.length())).getParentFile().getParentFile();
        
        version = new SimpleDateFormat("yyMMddHHmm").format(new Date(dir.lastModified()));
    }
    
    /**
     * Get version of web application which is the date and time the web application was loaded to the web container.
     * 
     * @return web application version
     */
    public static String getVersion() {
        return version;
    }
    
    public static ProcessHandler getHandler() {
        return ProcessHandlers.lookup(Constants.PROCESS_HANDLER_BINDING);
    }
    
    public static SimpleDateFormat getDateFormatter() {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    }
    
    public static String getContext(HttpServletRequest req) {
        String context = req.getParameter("context");
        String subContext = req.getParameter("subcontext");
        if (subContext!=null && !subContext.isEmpty()) {
            context += ProcessHandler.HIER_DELIM + subContext;
        }
        return context;
    }
    
    /**
     * The following scan will take a few seconds when the server is initially brought up.
     * Subsequent redeployments of the admin application will be much quicker.
     */
    private static final Set<FieldVar> declaredVars;
    static {
        TreeSet<FieldVar> set = new TreeSet<FieldVar>();
        try {
            ClassPath cp = ClassPath.from(Thread.currentThread().getContextClassLoader());
            for (ClassPath.ClassInfo info : cp.getTopLevelClasses()) {
                try {
                    Class clz = info.load();
                    for (Field fld : clz.getFields()) {
                        if (fld.getDeclaringClass().equals(clz)
                                && (fld.getModifiers()&Modifier.STATIC)!=0
                                && Var.class.isAssignableFrom(fld.getType())) {
                            Var v = (Var)fld.get(null);
                            set.add(new FieldVar(fld, v));
                        }
                    }
                } catch (Throwable t) {
                }
            }
        } catch (IOException e) {
        }
        declaredVars = Collections.unmodifiableSet(set);
    }
    
    public static Set<FieldVar> getDeclaredVars() {
        return declaredVars;
    }
    
    public static DataSource getDataSource() throws SQLException {
        try {
            InitialContext ic = new InitialContext();
            Context lctx;
            try {
                lctx = (Context)ic.lookup("java:/comp/env");
            } catch (NamingException e) {
                lctx = ic;
            }
            return (DataSource)lctx.lookup(Constants.DB_DS);
        } catch (NamingException e) {
            throw new SQLException("Could not get database connection", e);
        }
    }
    
    
}
