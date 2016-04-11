package sources;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.StringCharacterIterator;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lotus.domino.*;
//import lotus.domino.Database;
//import lotus.domino.DateTime;
//import lotus.domino.Document;
//import lotus.domino.Item;
//import lotus.domino.Session;
////import com.ibm.domino.osgi.core.context.ContextInfo;
//import lotus.domino.NotesFactory;
import static sources.BaseServlet.logger;

/**
 * This class return all or selected fields from a document as json.<br />
 * <br />
 * Input is:
 * <ul>
 * <li>unid - required</li>
 * <li>fields - optional (use ~ as separator)</li>
 * <li>jsoncallback - optional</li>
 * </ul>
 * <br />
 *
 * @author 
 * 
 */
/*
* This will NOT work for embedded documents in domino/notes db
*/
@WebServlet(urlPatterns = {"/openlotusnotes"})
public class OpenLotusNotes extends HttpServlet {

    private static final long serialVersionUID = -993328140261388062L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=utf-8");
       
        PrintWriter out = resp.getWriter();

        try {
            String unid = "SZMW012516037733";
            //String unid = req.getParameter("unid");
            String fields = req.getParameter("fields");
            String jsoncallback = req.getParameter("jsoncallback");
            String fieldarray[] = null;
            if (fields != null) {
                fieldarray = fields.split("~");
            }

            if (jsoncallback != null) {
                out.print(jsoncallback + "(");
            }
            // json start
            out.print("\n{");
           
            if (unid != null) {

                try {
      //             Database db = ContextInfo.getUserDatabase();
                    //Database db = ContextInfo.getUserDatabase();
    //                Session session = db.getParent();
                      logger.info("STR doGet before session******************************************************************");
//                     String args[] = new String[1];
//                     args[0] = "-HTTPEnableSSLSecurity";
                    String host = "jaz-da1.nb.jazzsemi.com";     
                    String ior = NotesFactory.getIOR("jaz-da1.nb.jazzsemi.com" + ":" + "63148");
                    logger.info("STR ior before session********************************whitemPnot4u2***************************************ior = " + ior );
                    Session session = NotesFactory.createSessionWithIOR(ior,"whitem", "Pnot4u2");
                    //Session session = NotesFactory.createSessionWithIOR(ior,"Marc Whitney/USA/Jazz Semiconductor", "Pnot4u2");
                    //Session session = NotesFactory.createSession(host , "Marc Whitney", "Pnot4u2");
                    //Session session = NotesFactory.createSession(host , "Marc Whitney", "Pnot4u2");
                    //Session session = NotesFactory.createSession();
                   //Database db = session.getDatabase("", "STR.nsf", false);
                     logger.info("STR doGet after session************************************whitemPnot4u2***********************");
                   Database db = session.getDatabase(host, "STR.nsf");
                    if (db == null) {
                           // return "No local address book";
                        logger.info("STR db did not connect");
                    } else {
                            //return db.getTitle();
                        logger.info("STR  title : " + db.getTitle());
                    }
                    Document doc = db.getDocumentByUNID(unid);

                    boolean firstItem = true;

                    if (doc != null) {
                        Item item ;
                        if (fieldarray != null) {
                            for (String field : fieldarray) {
                                if (doc.hasItem(field)) {
                                    item = doc.getFirstItem(field);
                                    printJsonItem(out, session, item,
                                            firstItem, null);
                                    logger.info("session is:" + session);
                                    logger.info("Items are:" + item.getValueString());
                                    if (item != null) {
                                        item.recycle();
                                    }
                                }
                                firstItem = false;
                            }
                        } else {
                            Iterator<Item> it = doc.getItems().iterator();
                            while (it.hasNext()) {
                                item = it.next();
                                printJsonItem(out, session, item, firstItem,
                                        null);
                                logger.info("iterator session is:" + session);
                                logger.info("iterator Items are:" + item.getValueString());
                                if (item != null) {
                                    item.recycle();
                                }
                                firstItem = false;
                            }
                        }
                    }
                    doc.recycle();
                    db.recycle();
                    session.recycle();
                } catch (Exception e) {
                    // Be quiet.
                }
            }
            // json end
            out.print("\n}");
            if (jsoncallback != null) {
                out.print("\n)");
            }

        } catch (Exception e) {
            // Be quiet.
        }
        out.flush();
        out.close();
    }

    private void printJsonItem(PrintWriter out, Session session, Item item,
            boolean firstItem, String format) {

        Vector<?> v = null;
        Iterator<?> it = null;
        boolean firstValue = true;

        try {
            if (item != null) {

                if (item.getType() == Item.AUTHORS
                        || item.getType() == Item.DATETIMES
                        || item.getType() == Item.NAMES
                        || item.getType() == Item.NUMBERS
                        || item.getType() == Item.READERS
                        || item.getType() == Item.RICHTEXT
                        || item.getType() == Item.TEXT) {
                    v = item.getValues();
                    if (v != null) {
                        out.print((firstItem ? "\n\t" : ",\n\t")
                                + item.getName() + ":");
                        if (v.size() > 1) {
                            out.print("[");
                            it = v.iterator();
                            while (it.hasNext()) {
                                out.print((firstValue ? "" : ",")  + "\""   + getValueString(session, it.next(),item.getType()) + "\"");

                                firstValue = false;
                            }
                            firstValue = true;
                            out.print("]");
                        } else {
                            out.print("\""
                                    + getValueString(session, v.get(0), item
                                            .getType()) + "\"");
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.info("STR doGet after session******************************************************************" + e );
        }
    }

    private String getValueString(Session session, Object obj, int type) {

        String valueString = "";

        DateTime dt = null;
        try {

            switch (type) {
                case Item.RICHTEXT:
                    valueString = obj.toString();
                    break;
                case Item.DATETIMES:
                    dt = (DateTime) obj;
                    valueString = dt.getLocalTime();
                    dt.recycle();
                    break;
                case Item.NUMBERS:
                    valueString = obj.toString();
                    break;
                case Item.TEXT:
                    valueString = obj.toString();
                    break;
                default:
                    valueString = obj.toString();
            }

            if (dt != null) {
                dt.recycle();
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Be quiet.
        }
        return addSlashes(valueString);

    }

    private static String addSlashes(String text) {
        final StringBuffer sb = new StringBuffer(text.length() * 2);
        final StringCharacterIterator iterator = new StringCharacterIterator(
                text);

        char character = iterator.current();

        while (character != StringCharacterIterator.DONE) {
            if (character == '"') {
                sb.append("\\\"");
            } else if (character == '\'') {
                sb.append("\\\'");
            } else if (character == '\\') {
                sb.append("\\\\");
            } else if (character == '\n') {
                sb.append("\\n");
            } else if (character == '{') {
                sb.append("\\{");
            } else if (character == '}') {
                sb.append("\\}");
            } else {
                sb.append(character);
            }

            character = iterator.next();
        }

        return sb.toString();
    }

}