/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import com.jazz.str.vo.RichTextFieldVo;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
//import com.mongodb.DBCursor;
import com.mongodb.Mongo;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;

import java.awt.image.ImageFilter;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import.javax.servlet.RequestDispatcher;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;

@WebServlet(urlPatterns = {"/NewClass_multi"})
@MultipartConfig
public class NewClass_multi extends HttpServlet {

    private static final long serialVersionUID = 1L;
    // location to store file uploaded
    private static final String UPLOAD_DIRECTORY = "image_upload";
    // upload settings
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<FileItem> items;
        try {
            items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request); //content coming from client
            Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
            DB db2 = mongo.getDB("cimapps");
           // DBCollection collection1 = db2.getCollection("strdocs3");
            DBCollection collection1 = db2.getCollection("strdocs1");
            // for filling the response with data 
            Map<String, String> scrapeList = new HashMap<>();
            String STRNumber = null;
            String ScrWfrL = "";
            String lastScrWfrL = null;
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();
                    if (fieldName.contains("_id")) {
                        STRNumber = fieldValue;
                    }
                    if (fieldName.contains("ScrWfrL")) {
                        //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "Looping across all ScrWfrL********" + fieldName + " " + fieldValue);
                        if (!fieldName.equals(lastScrWfrL) && lastScrWfrL != null) {
                            // scrapeList.put(lastScrWfrL, ScrWfrL);
                            // Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "**************111111111**ScrWfrL" + lastScrWfrL + " " + fieldValue);
                            ScrWfrL = fieldValue + " ";
                        } else {
                            ScrWfrL = ScrWfrL + fieldValue + " ";
                        }
                        lastScrWfrL = fieldName;
                        scrapeList.put(lastScrWfrL, ScrWfrL);
                        // Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "****************222222ScrWfrL" + lastScrWfrL + " " + ScrWfrL);
                    } else if (ScrWfrL.length() > 1) {
                        //ScrWfrL = ScrWfrL.substring(0, ScrWfrL.length() - 1)  ;
                        scrapeList.put(lastScrWfrL, ScrWfrL);
                        //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "****************33333333ScrWfrL" + lastScrWfrL + " " + ScrWfrL);
                        ScrWfrL = "";
                    }

                    //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, fieldName + " " + fieldValue);
                    // ... (update MongoDB docs)
                } else {
                    // Process form file field (input type="file").
                    //Update MongoDB GridFS with the attachments and store attachment name (STRNumber-Section-Counter) in document BSON
                    String fieldName = item.getFieldName();
                    String fileName = FilenameUtils.getName(item.getName());
                    InputStream fileContent = item.getInputStream();
                    //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "*********GRIDFS CONTENTS:***************" + fieldName + " " + fileName);

                }
            }
            if (STRNumber.isEmpty()) {
                //this is a new retrieval get data from MongoDB
                //need to fix or reimport SNBPJR06260100521,SNPBVM07130100530
                STRNumber = "SNPBAJ11290100766";  // SNPBGE03080000018 , SNPBWA07190100537 , problem with # SNPBAJ11290100766, SNPBYK04150200934, SNPBPH04060000035
            } else {
                //setup BSON formatted date for update
                STRNumber = "SNPBAJ11290100766"; // SNPBWA07190100537
            }
            //BasicDBObject query = new BasicDBObject();
            //query.put("_id", new ObjectId(STRNumber));

            BasicDBObject whereQuery = new BasicDBObject();
            whereQuery.put("_id", STRNumber);
            DBCursor aDBCursor = collection1.find(whereQuery);
            if (aDBCursor.hasNext()) {
                DBObject aDbObject = aDBCursor.next();
                //***zero out the scrap wafer drop down lists in case they were completely deselected
                for (int jj = 1; jj < 17; jj++) {
                    aDbObject.put("ScrWfrL" + jj, "");
                    aDbObject.put("Prob" + jj, "");
                    aDbObject.put("LotCony" + jj, "");

                }
                aDbObject.put("RelTestReqDisp", "");
                aDbObject.put("CustDelivery", "");
                aDbObject.put("RelToProduction", "");
                //Integer GridFSFlag = 0;
                for (FileItem item : items) {
                    if (item.isFormField()) {
                        // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
                        String fieldName = item.getFieldName();
                        String fieldValue = item.getString();
                        if (fieldName.contains("ScrWfrL")) {

                            fieldValue = scrapeList.get(fieldName);
                            // Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "****************444444444ScrWfrL" + fieldName + " " + fieldValue);
                        }
                        //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, fieldValue);
                        //Do this for all 5 richtext fields
                        if (fieldName.contains("SCMRecord") || fieldName.contains("STR_INSTRUCTION") || fieldName.contains("Attachments") || fieldName.contains("PostCompletionComments")) {
                            //throw contents into GRIDFS 
                            //GridFSFlag = 1;
                            //COMMENT THIS ONLY FOR TESTING                          String retId = saveEmbeddedObject(fieldName, STRNumber, mongo, fieldValue);
                            //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "*****FROM FORM FIELD****GRIDFS CONTENTS:************" + fieldName + " = ***" + retId);
                            //aDbObject.put(fieldName, STRNumber + "-" + fieldName);
                            if (fieldValue != null && !fieldValue.isEmpty()) {
                                aDbObject.put(fieldName, fieldValue);
                            }
                        } else {
                            //if (GridFSFlag == 0) {
                            aDbObject.put(fieldName, fieldValue);
                        }
                    }

                }
                collection1.save(aDbObject);
                // aDbObject.put("department", aDBCursor);
                //collection1.save(aDbObject);
            }

            Map<Object, Object> replys = new LinkedHashMap<>();
            Map<Object, Object> replys1 = new LinkedHashMap<>();
            //DBCursor cursor = collection1.find(whereQuery);
            DBObject dbObject = collection1.findOne(whereQuery);
            if (dbObject != null){
            	replys = collection1.findOne(whereQuery).toMap();
            	replys1 = collection1.findOne(whereQuery).toMap();
            } else {
            	// Document  not fond in  Databse ; Should return an error;
            	RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
                rd.forward(request, response);
                return;
            }

            List<String> updatedBy = new ArrayList<>();
            List<String> revisions = new ArrayList<>();

            for (Map.Entry<Object, Object> entry : replys.entrySet()) {
                Object key = entry.getKey();
                Object value = entry.getValue();
                // replys1.put(key, value);  // this needs to be cleaned up
                replys.put(key, value);  // this needs to be cleaned up

                if ("UpdatedBy".equals(key.toString())) {
                    // Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, updatedBy.toString());
                    updatedBy = (List<String>) value;

                }
                else if ("Revisions".equals(key.toString())) {
                    // if (value.toString().contains(",")){
                    revisions = (List<String>) value;
                   // }

                    //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, revisions.get(0));
                }
                else  if ("SCMRecord".equals(key.toString()) || "STR_INSTRUCTION".equals(key.toString()) || "Attachments".equals(key.toString()) 
                		|| "Attachments_1".equals(key.toString()) || "PostCompletionComments".equals(key.toString())) {
                	/** Old Code to handle RichText Area Fields */
					//processRichtextDataFields(STRNumber, replys, key, value);
                	/**New Code to Handle RichText Area Fields*/
                	handleRichTextDataFields(STRNumber, replys,replys1, key, value);
                }
                if (value.toString().contains("\r\n") && !value.toString().contains("<br />\r\n") && !value.toString().contains("<br>") && !"UpdatedBy".equals(key.toString()) && !"Revisions".equals(key.toString())) {
                    //value =value.toString().replace("\n\r", "<br />");
                    value = value.toString().replace("\r\n", "<br />\r\n");
                    replys.put(key, value);
                    replys1.put(key, value);
                }
                if (value.toString().startsWith("[") && value.toString().endsWith("]") && !"UpdatedBy".equals(key.toString()) && !"Revisions".equals(key.toString()) && !"Attachments".equals(key.toString()) && !"Attachments_1".equals(key.toString())) {
                    String value2 = value.toString().replace("[", "").replace("]", "").replace(",", " ").replace("\"", "");
                    replys.put(key, value2);

                }

            }
            String updatedByRevisions = "";

            for (int i = 0; i < revisions.size(); i++) {
                //revDate = revisions.get(i);
                if (updatedBy.size() > i) {
                    updatedByRevisions = updatedByRevisions + updatedBy.get(i) + " : " + revisions.get(i) + "\n";
                    //  Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, updatedByRevisions);
                } else {
                    updatedByRevisions = updatedByRevisions + " " + " : " + revisions.get(i) + "\n";
                }
            }
            replys.put("updatedByRevisions", updatedByRevisions);
            // Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, revisions.toString());
            //request.setAttribute("revisionsAlt", updatedByRevisions.toString());
            // response.setContentType("text/plain");

            request.setAttribute("mongodb", replys);
            request.setAttribute("replys", replys);
            request.setAttribute("replys1", replys1);
            mongo.close();
        } catch (FileUploadException e) {
            //throw new ServletException("Cannot parse multipart request.", e);
            Logger.getLogger(NewClass_multi.class.getName()).log(Level.SEVERE, null, e);
        }
        //response.sendRedirect("index.jsp");
        //RequestDispatcher rd =  request.getRequestDispatcher("/WEB-INF/index.jsp");
        RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
        rd.forward(request, response);
        //response.sendRedirect("index.jsp");
    }

    
    /**
     * @author kudaraa
     */
	private void handleRichTextDataFields(String sTRNumber, Map<Object, Object> replys, Map<Object, Object> replys1,Object key, Object value) {
		String textVal = processRichTextJSONString(key,value,replys1);
		replys.put(key, textVal);
		
		
	}

	private String processRichTextJSONString(Object key, Object value, Map<Object, Object> replys1) {
		StringBuilder textValue = new StringBuilder();
		Gson gson = new Gson();
		JsonParser parser = new JsonParser();
		try{
			JsonElement parseElement = parser.parse(value.toString());
			if (parseElement.isNull()){
				textValue.append("");
			} else if (parseElement.isArray()){
				StringBuilder attachmentsURL = new StringBuilder();
				JsonArray jArray = parser.parse(value.toString()).asArray();
				for(JsonElement attachmentName : jArray )
				{
					String attachmentFileName = gson.fromJson( attachmentName , String.class);
					buildEmeddedPbjectDownloadURL(attachmentsURL, attachmentFileName);
				}
				replys1.put(key+"_attachments", attachmentsURL);
			} else if (parseElement.isObject()){
				
				RichTextFieldVo richTextFieldVo = gson.fromJson(value.toString(), RichTextFieldVo.class);
				if (richTextFieldVo.getTextValue()!= null ){
					textValue.append(richTextFieldVo.getTextValue());
				} 
				if (richTextFieldVo.getImageFiles() != null && richTextFieldVo.getImageFiles().size() > 0){
					StringBuilder imageFileURLs = new StringBuilder();
					for (String imgeFile : richTextFieldVo.getImageFiles()) {
						buildEmeddedPbjectDownloadURL(imageFileURLs,imgeFile);
					}
					replys1.put(key+"_imageFiles", imageFileURLs);
				} 
				if (richTextFieldVo.getAttachementFiles() != null && richTextFieldVo.getAttachementFiles().size() > 0){
					StringBuilder attachmentsURL = new StringBuilder();
					List<String> attachementFiles = richTextFieldVo.getAttachementFiles();
					for (String fileName : attachementFiles) {
						buildEmeddedPbjectDownloadURL(attachmentsURL, fileName);
					}
					replys1.put(key+"_attachments", attachmentsURL);
				}
				if (StringUtils.isNotBlank(richTextFieldVo.getSCMRecord())){
					textValue.append(richTextFieldVo.getSCMRecord());
				}
				if (StringUtils.isNotBlank(richTextFieldVo.getPostCompletionComments())){
					textValue.append(richTextFieldVo.getPostCompletionComments());
				}
				
			} else {
				if (StringUtils.equalsIgnoreCase(key.toString(), "Attachments") || StringUtils.equalsIgnoreCase(key.toString(), "Attachments_1")){
					StringBuilder attachmentsURL = new StringBuilder();
					// Attachments has only one attachment file
					buildEmeddedPbjectDownloadURL(attachmentsURL, value.toString());
					replys1.put(key+"_attachments", attachmentsURL);
				} else {
					textValue.append(value.toString());
				}
			}
			
		}catch(JsonSyntaxException e){
			textValue.append(value.toString());
		}
				
		return textValue.toString();
	}


	private void buildEmeddedPbjectDownloadURL(StringBuilder textValue, String fileName) {
		textValue.append("<a href=\"GetEmbeddedObjs?fileName="+fileName+"\">"+fileName+"</a>");
		textValue.append("<br/>");
		
	}


	private void processRichtextDataFields(String STRNumber, Map<Object, Object> replys, Object key, Object value) {
		Object value1 = value;
		//String content = STRNumber + "-" + key.toString(); //
		String content;
		if (value != null && value.toString() != "") {

		    //PARSE OUT THE ATTACHMENT NAMES
		    //format in 5 richtext areas is ["filename0.ext", ... "filenameX.ext"] and point to strNumber-section-0.ext , ...strNumber-section-X.ext in GRIDFS
		    String valueString = value.toString();
		    String fullFile = "";
		    Integer a = valueString.indexOf("[ \"");
		    Integer b = valueString.indexOf("\"]");
		    Integer counter1 = 0;
		    Integer endIndex = b;
		    List<String> contentList = new ArrayList<>();
		    if (a > -1 && b > a) {
		        fullFile = valueString.substring(a + 3, endIndex).trim();
		        Integer dot = fullFile.indexOf(".");
		        String extension = "";
		        if (dot > -1) {
		            extension = fullFile.substring(dot);
		        }
		        Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "*******inside array***********");
		        Integer nextComma = valueString.indexOf(",", a);
		        if (nextComma < 1 || nextComma > b) {
		            //parse the extension of the filename

		            content = "<a href=" + "/STRform_woutMaven/GetEmbeddedObjs?content=" + STRNumber + "-" + key.toString() + "-" + counter1.toString() + extension + ">" + valueString.substring(a + 3, endIndex).trim() + "</a>";
		            contentList.add(content);
		            //Logger.getLogger(NewClass_multi.class.getName()).log(Level.INFO, "******************content=" + content);
		        } else {
		            //there are embedded files to parse and create Href links on
		            content = "<a href=" + "/STRform_woutMaven/GetEmbeddedObjs?content=" + STRNumber + "-" + key.toString() + "-" + counter1.toString() + extension + ">" + valueString.substring(a + 3, endIndex).trim() + "</a>";
		            contentList.add(content);
		            while (nextComma < b && nextComma > 0) {
		                //endIndex = nextComma;
		                //fileNames.add(valueString.substring(a + 2, endIndex - 1));
		                a = nextComma + 1;
		                if (valueString.indexOf(",", a) < b) {
		                    nextComma = valueString.indexOf(",", a);
		                } else {
		                    nextComma = b;
		                }
		                fullFile = valueString.substring(a, nextComma).trim();
		                dot = fullFile.indexOf(".");
		                
		                if (dot > -1) {
		                    extension = fullFile.substring(dot);
		                }
		                content = "<a href=" + "/STRform_woutMaven/GetEmbeddedObjs?content=" + STRNumber + "-" + key.toString() + "-" + counter1.toString() + ">" + valueString.substring(a, nextComma).trim() + "</a>";
		                contentList.add(content);
		                counter1 += 1;
		            }
		        }
		        //String filename1 = valueString.substring(a + 2, endIndex - 1);
		        String listString = String.join(" ", contentList);
		        //remove the array portion of the value 
		        value = valueString.substring(0 , a ) + valueString.substring(b + 2);
		        value = value + listString;
		    }
		  
		}

		// Logger.getLogger(STRsave.class.getName()).info(  "return from getEmbeddedObject string " + STRNumber + "-" + key.toString() + "=" +  content);
		//  Logger.getLogger(STRsave.class.getName()).info(  "embedded value= " + STRNumber + "-" + key.toString() + "=" +  value);
		replys.put(key, value);
	}

    private static synchronized String getEmbeddedObject(String section, String str_number, Mongo mongo) throws UnsupportedEncodingException, IOException {
        //try {
        //Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
        // Logger.getLogger(STRsave.class.getName()).info(  "mongo instance done");

        DB db1 = mongo.getDB("cimapps");

        StringBuilder ObjName = new StringBuilder();
        ObjName.append(str_number).append("-").append(section);

        GridFS gfscimapps = new GridFS(db1, "cimappsSTR");
        BasicDBObject query = new BasicDBObject("filename", ObjName.toString());
        GridFSDBFile imageForOutput = gfscimapps.findOne(query);
        // Logger.getLogger(STRsave.class.getName()).info(  "***************query into GRIDFS*********" + query  );
        String totalLine = "";
        if (imageForOutput != null) {
            Logger.getLogger(STRsave.class.getName()).info("***************image for output was found in GRIDFS*********" + imageForOutput);
            InputStream stream = imageForOutput.getInputStream();
            BufferedReader br;
            br = new BufferedReader(new InputStreamReader(stream, "UTF-8"));
            //Logger.getLogger(STRsave.class.getName()).info(  "***************br BufferedReader*********=" + br );
            String line = null;

            //totalLine.append(" ");
            while ((line = br.readLine()) != null) {
                if (line != null) {
                    totalLine = totalLine + (line);
                    // Logger.getLogger(STRsave.class.getName()).info(  "***************br BufferedReader*********=" + br.toString()  + " LINE= " + line);
                }
            }
        }
        // Logger.getLogger(STRsave.class.getName()).info(  "***************totaline pulled from GRIDFS*********=" + totalLine  );
        return totalLine;
        //return imageForOutput.toString();
    }

    private static synchronized String saveEmbeddedObject(String section, String str_number, Mongo mongo, String content) {

        //try {
        DB db1 = mongo.getDB("cimapps");
        StringBuilder ObjName = new StringBuilder();
        ObjName.append(str_number).append("-").append(section);

        GridFS gfscimapps = new GridFS(db1, "cimappsSTR");
        //BasicDBObject query = new BasicDBObject("filename" , ObjName.toString() );
        gfscimapps.remove(ObjName.toString()); // trying to remove based on a query of the filename results in removing ALL GRIDFS files - DONT USE
        //Logger.getLogger(STRsave.class.getName()).info(  "saving update into GridFS" + ObjName.toString() + "=" + content);
        byte[] b = content.getBytes(Charset.forName("UTF-8"));
        GridFSInputFile in = gfscimapps.createFile(b);

        in.setFilename(ObjName.toString());
        in.save();
        //GridFSInputFile inputFile = gfscimapps.createFile(fileInputStream);
        //GridFSInputFile gfsFile = gfscimapps.createFile(ObjName.toString());
        // set a new filename for identify purpose
        //gfsFile.setFilename(ObjName.toString());
        // save the image file into mongoDB
        //gfsFile.save();
        // get image file by it's filename
        //           GridFSDBFile imageForOutput = gfscimapps.findOne(ObjName.toString());
        //imageForOutput.
//        } catch (Exception ) {
//            System.out.println("exception = " + e);
//            Logger.getLogger(NewClass_multi.class.getName()).log(Level.SEVERE, null, e);
//        }
//    }
        return in.getId().toString();
    }
    
}
