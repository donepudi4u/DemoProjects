/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import java.io.IOException;
import java.util.Enumeration;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
//import org.apache.commons.codec.binary.Base64;
/**
 *
 * @author whitnem
 */
//@WebServlet(urlPatterns={"/newclass"})
////@WebServlet("/newclass")
//public class NewClass extends HttpServlet {
//  //public class NewClass extends BaseServlet {  
//    private static final long serialVersionUID = 1L;
//    
//   @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws IOException, ServletException {
@WebServlet(urlPatterns = {"/NewClass"})
//@WebServlet(name = "STRsave", urlPatterns = {"/strsave"})
public class NewClass extends BaseServlet {

    private static final long serialVersionUID = 1L;

    //private final STRsave save = new STRsave();
    //private final static Logger logger = Logger.getLogger(Constants.LOGGER_NAME);
    @Override
    protected void doPostImpl(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        //Logger.getLogger(NewClass.class.getName()).info( "************INSIDE loadDATA******************************************************");
      Enumeration allParameterNames = request.getParameterNames();
while(allParameterNames.hasMoreElements())
{
    Object object = allParameterNames.nextElement();
    String param =  (String)object;
    String value =  request.getParameter(param);
    Logger.getLogger(NewClass.class.getName()).info("Parameter Name zzzzzz is '"+param+"' and Parameter Value is '"+value+"'");
   // pw.println("Parameter Name is '"+param+"' and Parameter Value is '"+value+"'");
}    
     String STRNumber = request.getParameter("STRNumber");
      Logger.getLogger(NewClass.class.getName()).info("Parameter Name  STRNumber and Parameter Value is '"+ STRNumber +"'");          
//                 Logger.getLogger(NewClass.class.getName()).info("************before TreeMap after richText string assignment ****************************************************");
//                TreeMap<Integer, String> attachments = new TreeMap<>();
//                int attachmentCounter = 0;
//                String STR_Number =request.getParameter("STR_Number");
//                Logger.getLogger(NewClass.class.getName()).info("************before getParameter ****************************************************" + STR_Number);
//                //JsonObject rt = obj.get("richtext");
//                Logger.getLogger(NewClass.class.getName()).info("************got the richtext object ****************************************************");
               //int richTextEntries = rt.size();
                
                //Logger.getLogger(NewClass.class.getName()).info("richTextEntries=" + richTextEntries);
                //Boolean key0 = rt.containsKey("0");
                
                //Logger.getLogger(NewClass.class.getName()).info("*****does richtext contain key 0 ?" + key0 );
               // byte[] bytes =  obj.get("0");  
               // byte[] sendData = obj.getBytes("utf-8");
                //String res1 = Base64.getEncoder().encodeToString(obj.get("0").getBytes(StandardCharsets.UTF_8));
                //all chars in encoded are guaranteed to be 7-bit ASCII
                //byte[] encoded = Base64.encodeBase64(sendData);
                //String richText = new String(encoded, "US-ASCII");
                //String richText = obj.get("0").toString();
//                String richText = request.getParameter("richtext");
//                String newRichText = "";
//                Logger.getLogger(NewClass.class.getName()).info("****************************************************starting**************" );
//                if (richText != null) {
//                    String aBegin = "<a attachment=\"";
//                    String hrefAttr = "\" href=\"";
//                    String aEnd = "\">";
//                     Logger.getLogger(NewClass.class.getName()).info( "****************************************************String builder**************" );
//                    StringBuilder newText = new StringBuilder();
//                    int indx, prevIndx = 0;
//                    while ((indx = richText.indexOf(aBegin, prevIndx)) != -1) {
//                        //Append everything up to now
//                        newText.append(richText.substring(prevIndx, indx));
//                        Logger.getLogger(NewClass.class.getName()).info( "*****************************************************" +newText);
//                        //Get file name from attachment attribute
//                        prevIndx = indx + aBegin.length();
//                        indx = richText.indexOf(hrefAttr, prevIndx);
//                        Logger.getLogger(NewClass.class.getName()).info( "********************************************indx = " + indx );
//                        String fileName = richText.substring(prevIndx, indx);
//                         Logger.getLogger(NewClass.class.getName()).info( "******************************************String fileName =  " + fileName );
//                        //Get attachment body
//                        prevIndx = indx + hrefAttr.length();
//                        indx = richText.indexOf(aEnd, prevIndx);
//                        String fileBody = richText.substring(prevIndx, indx);
//                        prevIndx = indx + aEnd.length();
//                         Logger.getLogger(NewClass.class.getName()).info( "******************************************String fileBody =  =  " + fileBody );
//                        //Add attachment to map of attachments
//                        attachments.put(attachmentCounter, fileName + " ==> " + fileBody);
//
//                        //Rewrite the link
//                        newText.append("<a href=\"");
//                        newText.append(attachmentCounter++);
//                        newText.append("\">");
//                    }
//                    newText.append(richText.substring(prevIndx));
//                    newRichText = newText.toString();
//                }
//                for (Map.Entry<Integer, String> entry : attachments.entrySet()) {
//                    out.print("<li>");
//                    out.print(entry.getKey());
//                    out.print(" ==> ");
//                    String fileBody = entry.getValue();
//                    out.println(fileBody.length() <= 512 ? fileBody : fileBody.substring(0, 512) + "...[" + NumberFormat.getInstance().format(fileBody.length() - 512) + " more bytes]");
//                    out.println("</li>");
//
//                }
                resp.sendRedirect("index.jsp");
               // resp.sendRedirect("jaz-cimdev2/STRform_woutMaven/index.jsp");
                //resp.sendRedirect(request.getParameter("url"));
            }
  //      }
   // }
}
