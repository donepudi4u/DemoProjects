package support;

import java.util.Collection;
import java.util.Comparator;
import java.util.TreeSet;
import javax.mail.Session;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author gendrok
 */
public class Utility {
    
    private static final Logger logger = LoggerFactory.getLogger(Utility.class);
    
    public static Session getMailSession(HttpServletRequest request) throws ServletException {
        try {
            ServletContext ctx = request.getServletContext();
            String session = ctx.getInitParameter(ContextParameters.EMAILSESSION);
            InitialContext ic = new InitialContext();
            Context lctx;
            try {
                lctx = (Context)ic.lookup("java:/comp/env");
            } catch (NamingException e) {
                lctx = ic;
            }
            try {
                return (Session)lctx.lookup(session);
            } finally {
                try {
                    lctx.close();
                } catch (Exception e) {
                }
            }
        } catch (NamingException e) {
            String msg = "Failed to create mail session.";
            logger.error(msg, e);
            throw new ServletException(msg, e);
        }
    }
    
    public static DataSource getDataSource(HttpServletRequest request) throws ServletException {
        try {
            ServletContext ctx = request.getServletContext();
            String datasource = ctx.getInitParameter(ContextParameters.DATASOURCE);
            InitialContext ic = new InitialContext();
            Context lctx;
            try {
                lctx = (Context)ic.lookup("java:/comp/env");
            } catch (NamingException e) {
                lctx = ic;
            }
            try {
                return (DataSource)lctx.lookup(datasource);
            } finally {
                try {
                    lctx.close();
                } catch (Exception e) {
                }
            }
        } catch (NamingException e) {
            String msg = "Failed to create datasource.";
            logger.error(msg, e);
            throw new ServletException(msg, e);
        }
    }
    
    /**
     * Construct an array of internet addresses from the string representations.
     * 
     * @param addresses string addresses to convert to internet addresses
     * 
     * @return array of converted internet addresses
     * 
     * @throws AddressException if unable to convert an address
     */
    public static InternetAddress[] getAddresses(Collection<String> addresses) throws AddressException {
        TreeSet<InternetAddress> set = new TreeSet<InternetAddress>(ADDRESSCOMPARATOR);
        if (addresses!=null) {
            for (String accnt : addresses) {
                set.add(new InternetAddress(accnt));
            }
        }
        return set.toArray(new InternetAddress[set.size()]);
    }
        
    /**
     * Comparator for comparing internet addresses to ensure the same address is sent to twice.
     */
    private static final Comparator<InternetAddress> ADDRESSCOMPARATOR = new Comparator<InternetAddress>() {
        @Override
        public int compare(InternetAddress v1, InternetAddress v2) {
            String a1 = v1.getAddress();
            String a2 = v2.getAddress();
            return a1.compareTo(a2);
        }
    };
    
}
