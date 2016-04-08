/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;



import com.google.gson.JsonStreamParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.WriteResult;
import com.mongodb.util.JSON;
//import org.bson.Document;
import java.io.IOException;
import java.net.UnknownHostException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.function.Supplier;
import java.util.logging.Logger;
//import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;



/**
 *
 * @author
 */

@WebServlet(urlPatterns = {"/strsave"})
//@WebServlet(name = "STRsave", urlPatterns = {"/strsave"})
public class STRsave  extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    //private final STRsave save = new STRsave();
    //private final static Logger logger = Logger.getLogger(Constants.LOGGER_NAME);
    

    @Override
     protected  void  doPostImpl(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException, SQLException {
        Logger.getLogger(STRsave.class.getName()).info( "************INSIDE loadDATA*******************");
        
        //try {
        JsonStreamParser p = new JsonStreamParser(request.getReader());
        while (p.hasNext()) {
            JsonElement elem = p.next();
            String strtitle="";
            if (elem.isObject()) {
                ArrayList<String> errors = new ArrayList<>();
                //Logger.getLogger(SaveTypes.class.getName()).info(( "elem.isObject =" ));
                JsonObject obj = elem.asObject();
                String objstr = obj.toString();
                Logger.getLogger(STRsave.class.getName()).info( objstr);
//                JsonArray items2 = obj.get("STRdoc").asArray();
//                JsonObject item = items2.get(0).asObject();
//                Logger.getLogger(STRsave.class.getName()).info( item.get("strnum").asString());
                
//               for (JsonElement eld : obj.get("STRdoc").asArray()) {
//                                    JsonObject d = eld.asObject();
//                                    String strnum = d.get("strnum").asString();
//                                    strtitle = d.get("strtitle").asString();
//                                    Logger.getLogger(STRsave.class.getName()).info("strtitle********************");
//                                    Logger.getLogger(STRsave.class.getName()).info(strtitle);
//              }
              String id = obj.get("_id").asString();
              Logger.getLogger(STRsave.class.getName()).info("_id is ................");
              Logger.getLogger(STRsave.class.getName()).info(id);
             
                if (obj != null) {
                    // Logger.getLogger(STRsave.class.getName()).info(  "************obj != null*******************");
                    try {
                        Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
                       // Logger.getLogger(STRsave.class.getName()).info(  "mongo instance done");
                        DB db1 = mongo.getDB("cimapps");
                       // Logger.getLogger(STRsave.class.getName()).info(  "mongo db retrieved");
                       DBObject dbobject = (DBObject)JSON.parse(objstr);
                       
                        DBCollection collection1 = db1.getCollection("strdocs");
                        
                         // delete document from mongo if it exists....
                        BasicDBObject docQuery = new BasicDBObject();
                        docQuery.put("_id", id);
                        WriteResult resultQuery =collection1.remove(docQuery);
                        String resultQueryStr = resultQuery.toString();
                         Logger.getLogger(STRsave.class.getName()).info( "resultQueryStr");
                        Logger.getLogger(STRsave.class.getName()).info(  resultQueryStr);
                        
                        //now re-insert the document
                        WriteResult result =  collection1.insert(dbobject);
                        String resultStr = result.toString();
                        String STRinsertError = result.getError();
//                        if( STRinsertError != null){
//                            Logger.getLogger(STRsave.class.getName()).info( "STRinsertError ");
//                            Logger.getLogger(STRsave.class.getName()).info( STRinsertError);
//                        }
                        
                        Logger.getLogger(STRsave.class.getName()).info( "resultStr");
                        Logger.getLogger(STRsave.class.getName()).info(  resultStr);
                        
                        //now change the strtitle field in the doc
                       // BasicDBObject changeDocument = new BasicDBObject();
                        //changeDocument.append("$set", new BasicDBObject().append("STRdoc.strtitle", "Revised the title from source code"));
                       // BasicDBObject searchQuery = new BasicDBObject().append("_id",  id);
                       /// collection1.update(searchQuery, changeDocument);
                       // DBObject query = new BasicDBObject("_id", id);
                       // DBObject query = new BasicDBObject("strtitle", "title");
                       // DBObject update = new BasicDBObject();
                       // update.put("$set", new BasicDBObject("strtitle","Santa Clara"));
                        //DBObject listItem = new BasicDBObject("STRdoc", new BasicDBObject("strtitle", "Santa Clara"));
                        //DBObject updateQuery = new BasicDBObject("$set", listItem);
        //                DBObject queryForElem = new BasicDBObject("array", new BasicDBObject("$elemMatch", new BasicDBObject("strtitle", "title")));
         //               DBObject updateMatchingElem = new BasicDBObject("$set", new BasicDBObject("STRdoc.$.strtitle", "1111111111111"));
         //               WriteResult queryResult = collection1.update(queryForElem, updateMatchingElem);
                        //WriteResult queryResult =  collection1.update(query, updateQuery);
                        //WriteResult queryResult = collection1.update(query, update);
                        
          //             Logger.getLogger(STRsave.class.getName()).info( "changed strtitle ****************************");
           //            Logger.getLogger(STRsave.class.getName()).info(  queryResult.toString());
                        mongo.close();
                    } catch (UnknownHostException e) {
                        //e.printStackTrace();
                         Logger.getLogger(STRsave.class.getName()).info((Supplier<String>) e);
                        
   
                    }
                }

            } else {
                logger.info( "Input must be a JSON array.");
                throw new ServletException("Input must be a JSON array.");
            }

        }

    }
    
}