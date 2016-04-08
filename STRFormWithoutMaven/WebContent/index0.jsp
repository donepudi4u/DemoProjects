<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.TreeMap,java.util.Map,java.text.NumberFormat"%>
<%@ page import="java.net.URL,java.util.*"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="scripts/jquery-2.2.0.min.js"></script>
        <script src="scripts/bootstrap.min.js"></script>
        <script src="scripts/jquery.hotkeys.js"></script>
        <script src="scripts/wysiwyg.js"></script>
    </head>
    <body>
        <div>
            <% 
                TreeMap<Integer, String> attachments = new TreeMap<>();
                int attachmentCounter = 0;
                
                String richText = request.getParameter("richtext");
                String newRichText = "";
                if (richText!=null) {
                    String aBegin = "<a attachment=\"";
                    String hrefAttr = "\" href=\"";
                    String aEnd = "\">";

                    StringBuilder newText = new StringBuilder();
                    int indx, prevIndx=0;
                    while ((indx = richText.indexOf(aBegin, prevIndx))!=-1) {
                        //Append everything up to now
                        newText.append(richText.substring(prevIndx, indx));

                        //Get file name from attachment attribute
                        prevIndx = indx + aBegin.length();
                        indx = richText.indexOf(hrefAttr, prevIndx);
                        String fileName = richText.substring(prevIndx, indx);

                        //Get attachment body
                        prevIndx = indx + hrefAttr.length();
                        indx = richText.indexOf(aEnd, prevIndx);
                        String fileBody = richText.substring(prevIndx, indx);
                        prevIndx = indx + aEnd.length();

                        //Add attachment to map of attachments
                        attachments.put(attachmentCounter, fileName + " ==> " + fileBody);

                        //Rewrite the link
                        newText.append("<a href=\"");
                        newText.append(attachmentCounter++);
                        newText.append("\">");
                    }
                    newText.append(richText.substring(prevIndx));
                    newRichText = newText.toString();
                }
            %>
        </div>
        <form  method="post">
            <p>Text: <input name="text" type="text" value="<%= request.getParameter("text")!=null ? request.getParameter("text") : "" %>"></p>
            <p>Copy Text: <input name="text2" type="text" value="<%= request.getParameter("text2")!=null ? request.getParameter("text2") : "null" %>"></p>
            <p>Rich Text: <div name="richtext"  contenteditable="true" style="width: 400px;height: 300px;overflow: auto;border: 1px solid black"><%= newRichText %></div></p>
        
            <button type="submit">Submit</button>
        </form>
  
    
        

        <p>Rich Text Attachments:</p>
        
        <ul>
        <% 
            for (Map.Entry<Integer, String> entry : attachments.entrySet()) {
                out.print("<li>");
                out.print(entry.getKey());
                out.print(" ==> ");
                String fileBody = entry.getValue();
                out.println(fileBody.length()<=512 ? fileBody : fileBody.substring(0, 512) + "...[" + NumberFormat.getInstance().format(fileBody.length()-512) + " more bytes]");
                out.println("</li>");
                System.out.println("done");

            }
        %>
        </ul>
        <script>
            //Add textarea (must be textarea to allow large files) after all contenteditable fields to receive HTML during submission
            $('[contenteditable]').each(function(i,e) {
                e = $(e);
                e.after($('<textarea>').attr('name',e.attr('name')).hide()).wysiwyg();
            });
            //Have all forms copy editable content to the adjacent input before submitting
            $('form').on('submit', function() {
                $(this).find('[contenteditable]').each(function(i,e) {
                    e=$(e);
                    e.next('textarea').val(e.html());
                });
            });
        </script>
    </body>
</html>
