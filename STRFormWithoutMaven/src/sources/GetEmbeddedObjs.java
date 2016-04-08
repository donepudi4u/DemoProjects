/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.Mongo;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;

//import.javax.servlet.RequestDispatcher;
//@WebServlet(urlPatterns = {"/GetEmbeddedObjs"})
//@MultipartConfig
public class GetEmbeddedObjs extends HttpServlet {

	private static final long serialVersionUID = 1L;

    // location to store file uploaded
    private static final String UPLOAD_DIRECTORY = "image_upload";
    // upload settings
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	PrintWriter writer = response.getWriter();
    	writer.write("In Get Method");
    	
    	//List<FileItem> items;

        // items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request); //content coming from client
        Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
        DB db1 = mongo.getDB("cimapps");
        //DBCollection collection1 = db1.getCollection("strdocs3");
        // for filling the response with data 
        //Map<String, String> scrapeList = new HashMap<>();
        String embeddedFile = request.getParameter("content");
        if (embeddedFile == null || embeddedFile.equals("")) {
            //throw new ServletException("File Name can't be null or empty");
           // Logger.getLogger(GetEmbeddedObjs.class.getName()).warning("File Name can't be null or empty");
        } else {

            StringBuilder ObjName = new StringBuilder();
            ObjName.append(embeddedFile);

            GridFS gfscimapps = new GridFS(db1, "cimappsSTR");
            BasicDBObject query = new BasicDBObject("filename", ObjName.toString());
            GridFSDBFile imageForOutput = gfscimapps.findOne(query);
            // Logger.getLogger(STRsave.class.getName()).info(  "***************query into GRIDFS*********" + query  );
            //String totalLine = "";
            if (imageForOutput != null) {
            //Logger.getLogger(STRsave.class.getName()).info("***************inside getEmbeddedObjs image for output was found in GRIDFS*********" + imageForOutput);
                //InputStream stream = imageForOutput.getInputStream();
                //BufferedReader br;
                // br = new BufferedReader(new InputStreamReader(stream, "UTF-8"));

                //String line = null;
                response.setContentType("application");
                response.setHeader("Content-disposition", "attachment; filename=" + embeddedFile);
            //response.sendRedirect("index.jsp");
                // This should send the file to browser
                OutputStream out = response.getOutputStream();
                imageForOutput.writeTo(out);

                //out.flush();
                out.close();

            }
        }
        mongo.close();
        writer.write("No issues");
        writer.close();
        
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	PrintWriter writer = response.getWriter();
    	writer.write("In Post Method");
    	writer.close();
    }
    
    
}
