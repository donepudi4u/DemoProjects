/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lotusnotes2mongo;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;
import java.text.StringCharacterIterator;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector; // Lotus Notes Domino requires this object usage and any other Collection class/interface will not work
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.imageio.ImageIO;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.util.Base64;
import org.htmlparser.filters.NodeClassFilter;
import org.htmlparser.tags.ImageTag;
import org.htmlparser.tags.LinkTag;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 *
 * @author whitnem
 */
import com.google.gson.Gson;
import com.jazz.common.utils.JSONUtils;
import com.jazz.common.utils.LotusUtils;
import com.jazz.lotusnotes.richText.procesessor.RichTextProcessor;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteResult;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;
import com.mongodb.util.JSON;

import lotus.domino.Database;
import lotus.domino.DateTime;
import lotus.domino.Document;
import lotus.domino.DocumentCollection;
import lotus.domino.DxlExporter;
import lotus.domino.EmbeddedObject;
import lotus.domino.Item;
import lotus.domino.NotesException;
import lotus.domino.NotesFactory;
import lotus.domino.RichTextItem;
import lotus.domino.Session;

public class LotusNotes2Mongo {

    /**
     * @param argv
     *
     */
    public static void main(String argv[]) throws IOException, ClassNotFoundException {
        try {
            Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
            DB db2 = mongo.getDB("cimapps");

            String host = "jaz-da1.nb.jazzsemi.com";
            String ior = NotesFactory.getIOR(host + ":" + "63148");
            Session session = NotesFactory.createSessionWithIOR(ior, "whitem", "Pnot4u2");

            Database db = session.getDatabase("JAZ-DA1/Server/Jazz Semiconductor", "FAB/STR");

            StringBuilder db1 = new StringBuilder();
            Document doc = null;
            boolean firstValue = false;

            HashSet<String> attNames = new HashSet<>();

            if (!db.isOpen()) {

                Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, "Lotus Notes FAB/STR did not connect or Mongo is not authenticated");
                System.out.println(db1);
            } else {

                DocumentCollection all = db.getAllDocuments();
                if (all.getCount() > 0) {
                    System.out.println(all.getCount());
                    doc = all.getFirstDocument();
                    Integer blank_counter = 0;
                      Boolean continueProcess = Boolean.TRUE;
                    while (doc != null && continueProcess) {
                        boolean firstItem = false;

                        Item item;
                        String str_number = getSTRNumber(doc);
                        if (str_number.isEmpty()) {
                            blank_counter = blank_counter + 1;
                            //System.out.println("the str_number in this doc is blank - it is being bypassed. blank counter = " + blank_counter);
                        } else if (isVallidSTRNumber(str_number)) {
                            System.out.println("STR Number : " + str_number);
                            RichTextProcessor richTextProcessor = new RichTextProcessor(db2, session, doc, str_number);
                        //    Map<String, List<String>> imagesFilesMap = processImagesINDocument(doc, session, db2, str_number);
                            Map<String, String> richTextData = richTextProcessor.processRichTextData();
                            db1.setLength(0);
                            if (doc.hasEmbedded()) {
                                //there are embedded objects in this doc at the document level
                                Vector vv = doc.getEmbeddedObjects(); //lotus notes embedded objects wont pass into arraylists directly
                                ArrayList<?> v = new ArrayList<>(vv);

                                if (v.isEmpty()) {
                                    //Embedded object is an attachment - not sure but did not find any attachments at the doc level
                                    String visEmpty = "is empty";
                                } else {
                                    for (int i = 0; i < v.size(); i++) {
                                        EmbeddedObject eo = (EmbeddedObject) v.get(i);
                                        String eos = eo.getName() + " of " + eo.getClassName();
                                        System.out.println("Etachment name at Document Level: " +eos);
                                    }
                                }
                            }

                            Iterator<Item> it = doc.getItems().iterator();
                            while (it.hasNext()) {
                                item = it.next();
                                attNames.clear();
                                String iname = item.getName(); //this is the name of the field in the doc designer form
                                if (item.getType() == Item.RICHTEXT) {
                                    //processRichTextDataFromLotusNotesDocument(db2, attNames, item, str_number);
                                	richTextProcessor.processEmbeddedObjectsAndSaveToMongoDB(item);
                                }
                                Map<String, List<String>> imagesFilesMap = new HashMap<String, List<String>>();
                                printJsonItem(db1, session, item, firstItem, attNames, imagesFilesMap);

                                if (item != null) {
                                    item.recycle();
                                }
                                firstItem = false;
                            }
                            db1.append("}");
                            String objstr = db1.toString();
                            Gson gson = new Gson();
                            if (richTextData != null){
                            	String jsonStr = gson.toJson(db1.toString());
                            	String richTextJsonStr = gson.toJson(richTextData);
                            	String mergeJSONObjects = JSONUtils.mergeJSONObjects(jsonStr, richTextJsonStr);
                            	objstr = mergeJSONObjects;
                            }
                            DBCollection collection1 = db2.getCollection("strdocs1");
                            // delete document from mongo if it exists....
                            BasicDBObject docQuery = new BasicDBObject();
                            docQuery.put("_id", str_number);
                            WriteResult resultQuery = collection1.remove(docQuery);
                            String resultQueryStr = resultQuery.toString();
                            //now re-insert the document
                            try {
                                System.out.println("objstr : " + objstr);
                                DBObject dbobject = (DBObject) JSON.parse(objstr);
                                WriteResult result = collection1.insert(dbobject);
                                String resultStr = result.toString();
                                String STRinsertError = result.getError();
                            } catch (Exception e) {
                                System.out.println("exception = " + e);
                            }
                             continueProcess = Boolean.FALSE;
                        }
                        doc = all.getNextDocument(doc);
                        if (doc == null) {
                            Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, "this doc is null");
                        }

                    }
                }
            }
            //doc.recycle();
            db.recycle();
            session.recycle();
            mongo.close();
        } catch (UnknownHostException | MongoException | NotesException e) {
            System.out.println("exception = " + e);
            Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, e);
        } finally {

        }
    }

	private static void processRichTextDataFromLotusNotesDocument(DB db2, HashSet<String> attNames, Item item,String str_number) throws NotesException {
		RichTextItem riItem = (RichTextItem) item;
		Vector embv = riItem.getEmbeddedObjects(); //lotus notes embedded objects wont pass into arraylists directly
		ArrayList<?> emb = new ArrayList<>(embv);
		String path2 = "c:\\app\\";
		String embName;
		if (emb.size() > 0) {
		    //    int embeddedObjectSequence = 0;
		    for (Object emb1 : emb) {
		        EmbeddedObject embObj = (EmbeddedObject) emb1;
//                                        if(embObj.getName().contains("\"")){
//                                            int embLastIndex = embObj.getName().lastIndexOf("\"");
//                                            embName =embObj.getName().substring(embLastIndex + 1);
//                                        }else{
//                                            embName =embObj.getName();
//                                        }
		        if (!attNames.contains(embObj.getName())) { //&& !embObj.getSource().contains("notes071343\2F2E6A04.TMP")) {

		            if (embObj.getSource().contains(".") && embObj.getFileSize() > 0) {
		                StringBuilder embeddedObjectFileName = buildAttachemntName(embObj, str_number, item);
		                String path = "c:\\app\\" + embObj.getSource();
		                //attNames.add(embObj.getName());
		                attNames.add(embeddedObjectFileName.toString());

		                //**must test to see if the embedded object is a file that can be extracted
		                if ("SNPBYA03191203049".equals(str_number) && embObj.getSource().contains(".JRP") || "SNPBYA04271203069".equals(str_number)) {
		                    // bypassing these chart files - at least one is corrupt and cannot be extracted - lotus notes Checksum error
		                    //looking at the STR in Lotus notes shows the files are NOT exported in the same order as they appear so finding out
		                    //which file(s) is the culpret would require multiple iterations and Lotus Notes does not have a catch for the exception
		                } else {
		                    embObj.extractFile(path);
		                    //** add embedded object to GridFS and then delete the temp file
		                    saveEmbeddedObject(db2, path, embeddedObjectFileName.toString());
		                    //saveEmbeddedObject(item,   str_number, mongo, embObj , path); // is only saving the last embedded object in GridFS 
		                    //** add embedded object to GridFS and then delete the temp file
		                    //saveEmbeddedObject(item, embObj, path, str_number, mongo); // is only saving the last embedded object in GridFS 
		                }

		            } else {

		            }
		        }
		        //** add embedded object to GridFS and then delete the temp file
		        //           saveEmbeddedObject(item,   str_number, mongo, embObj , path); // is only saving the last embedded object in GridFS 
		    }

		}
		// save all embedded objects into a single GridFS 
		// Item item, String str_number,Mongo mongo, ArrayList emb, HashSet attNames, String path
		//saveEmbeddedObjectGroup(item,   str_number, mongo,  attNames, path2); //
		//remove all files from c:\\app\\ folder
	}

    private static StringBuilder buildAttachemntName(EmbeddedObject embObj, String str_number, Item item) throws NotesException {
        StringBuilder embeddedObjectFileName = new StringBuilder();
       // String fileExtentionName = StringUtils.EMPTY;
        // brought down to inner if to avoid non- attachemnt file names
        //ObjName.append(str_number).append("-").append(item.getName()).append("-").append(embObj.getName());
       /* StringTokenizer tokenizer = new StringTokenizer(embObj.getName(), ".");
        if (tokenizer.countTokens() > 1) {
            tokenizer.nextToken();
            fileExtentionName = tokenizer.nextToken();
        }*/
        embeddedObjectFileName.append(str_number).append("-").append(item.getName()).append("-").append(embObj.getName());
       /* if (StringUtils.isNotBlank(fileExtentionName)) {
            embeddedObjectFileName.append(".").append(fileExtentionName);
        }*/
        return embeddedObjectFileName;
    }

    private static String getSTRNumber(Document doc) {
        Item item;
        String Str_number = "";
        Iterator<Item> it;
        try {
            it = doc.getItems().iterator();

            while (it.hasNext()) {
                item = it.next();
                String iname = item.getName(); //this is the name of the field in the doc designer form
                if (iname.contains("STR_Number")) {
                    Str_number = item.getValueString();
                    break;
                }
            }
        } catch (NotesException ex) {
            Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, ex);
        }
        return Str_number;
    }

    private static void saveEmbeddedObject(Item item, String str_number, Mongo mongo, EmbeddedObject embObj, String path) {
        try {
            //Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
            // Logger.getLogger(STRsave.class.getName()).info(  "mongo instance done");
            DB db1 = mongo.getDB("cimapps");
            //String path = "c:\\app\\";
            StringBuilder ObjName = new StringBuilder();
            ObjName.append(str_number).append("-").append(item.getName()).append("-").append(embObj.getName());
            //ObjName.append(str_number).append("-").append(item.getName());

            File docFile = new File(path);
            // create a "cimappsSTR" namespace
            GridFS gfscimapps = new GridFS(db1, "cimappsSTR1");
//            MongoClient mongoClient;
//            GridFSBucket gridFSBucket = GridFSBuckets.create(db1, "files");
//            byte[] data = "Data to upload into GridFS".getBytes("UTF_8");
//            GridFSUploadStream uploadStream = gridFSBucket.openUploadStream("sampleData");
//            uploadStream.write(data);
//            uploadStream.close();
            // remove the image file from mongoDB
            // try query not on file name but on the id or use find for the _id
            //gfscimapps.remove(gfscimapps.findOne(ObjName.toString())); //this removes all previous GridFS entries even though it shouldnt
            // get doc file from local drive
            GridFSInputFile gfsFile = gfscimapps.createFile(docFile);

            // set a new filename for identify purpose
            gfsFile.setFilename(ObjName.toString());
            // save the image file into mongoDB
            gfsFile.save();
            // get image file by it's filename
            GridFSDBFile imageForOutput = gfscimapps.findOne(ObjName.toString());
            //imageForOutput.
        } catch (UnknownHostException e) {
            System.out.println("exception = " + e);
            Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, e);
        } catch (MongoException | IOException | NotesException e) {
            System.out.println("exception = " + e);
            Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    private static void printJsonItem(StringBuilder db1, Session session, Item item, boolean firstItem, HashSet<String> attNames, Map<String, List<String>> imagesFilesMap) {

        Vector<?> v;
        Iterator<?> it;
        boolean firstValue = true;

        try {
            if (item != null) {
                String finalsb = "";
                if (item.getType() == Item.AUTHORS
                        || item.getType() == Item.DATETIMES
                        || item.getType() == Item.NAMES
                        || item.getType() == Item.NUMBERS
                        || item.getType() == Item.READERS
                     //   || item.getType() == Item.RICHTEXT
                        || item.getType() == Item.TEXT) {
                    v = item.getValues();

                    if (v != null && v.size() > 0) {
                        String itemName = item.getName();
                        if (itemName.contains("$")) {
                            itemName = itemName.replace("$", "");
                        }
                        // no need to of processing Attachments in Rich text : processed separately.
                       /* if (attNames.size() > 0) {
                            //if (itemName.contains("Attachments") && attNames.size() > 0) {
                            //there should only be 1 element in the vector so revise it to hold the attachments also
                            StringBuilder sb = new StringBuilder();
                            //sb.append("\"").append(itemName).append("\"" + ": [" );
                            sb.append(" [");
                            //**iterate thru the HashSet to setup the value array 
                            for (String attname : attNames) {
                                System.out.println("[tem: " + itemName + "]: [ attachmentName : " + attname + " ]");
                                sb.append("\"").append(attname).append("\"").append(",");
                            }
                            finalsb = sb.substring(0, sb.length() - 1) + "]";
                            System.out.println("finalSb : " + finalsb);

                            //item.setValues(vct) ;//doesnt seem to work
                        }*/
                        if (itemName.contains("STR_Number")) {
                            String firstJson = "{\"_id\":\"" + item.getValueString() + "\"";
                            db1.replace(0, 0, firstJson);
                        } else {
                            db1.append(firstItem ? "{\"" : ",\"").append(itemName).append("\":");
                            if (v.size() > 1) {
                                db1.append("[");
                                it = v.iterator();
                                while (it.hasNext()) {
                                    db1.append(firstValue ? "" : ",").append("\"").append(getValueString(session, it.next(), item.getType())).append("\"");
                                    firstValue = false;
                                }
                                // firstValue = true;
                                db1.append("]");
                            } else {
                                //  List<String> imageNamesList = new ArrayList<String>();
                                String itemValueStr = getValueString(session, v.get(0), item.getType());
                                String attachementFiles = StringUtils.isNotBlank(finalsb) ? finalsb : StringUtils.EMPTY;
                                String imageNames = hasImageFiles(itemName, imagesFilesMap) ? LotusUtils.getListValueAsJSONVal(imagesFilesMap.get(itemName)) : StringUtils.EMPTY;

                                //  LOG.error("Has only one Iteam Value : " + itemName);
                                // String itemValueStr = getValueString(session, v.get(0), item.getType());
                                // Only text
                                if (attachementFiles.isEmpty() && imageNames.isEmpty() && !itemValueStr.isEmpty()) {
                                    db1.append("\"").append(itemValueStr).append("\"");
                                } else if (!attachementFiles.isEmpty() && !itemValueStr.isEmpty() && imageNames.isEmpty()) {
                                    // Text and attachments
                                    db1.append("{\"textValue\" :\"").append(itemValueStr).append("\"").append(",\"attachementFiles\" :").append(finalsb).append("}");
                                } else if (!attachementFiles.isEmpty() && !itemValueStr.isEmpty() && !imageNames.isEmpty()) {
                                    // Text , attachments , image files.
                                    db1.append("{\"textValue\" :\"").append(itemValueStr).append("\"").append(",\"attachementFiles\" :").append(finalsb).append(",\"imageFiles\" :").append(imageNames).append("}");
                                } else if (attachementFiles.isEmpty() && !itemValueStr.isEmpty() && !imageNames.isEmpty()) {
                                    //text and images 
                                    db1.append("{\"textValue\" :\"").append(itemValueStr).append("\"").append(",\"imageFiles\" :").append(imageNames).append("}");
                                } else if (!attachementFiles.isEmpty() && itemValueStr.isEmpty() && imageNames.isEmpty()) {
                                    // only attchments 
                                    db1.append(finalsb);
                                } else if (attachementFiles.isEmpty() && itemValueStr.isEmpty() && !imageNames.isEmpty()) {
                                    // only image files
                                    db1.append(imageNames);
                                } else if (!attachementFiles.isEmpty() && itemValueStr.isEmpty() && !imageNames.isEmpty()) {
                                    // attcahments and image files 
                                    db1.append("{\"attachementFiles\" :").append(finalsb).append(",\"imageFiles\" :").append(imageNames).append("}");
                                } else {
                                    db1.append("\"").append(itemValueStr).append("\"");
                                }
                                /*  if (finalsb.isEmpty() && !hasImageFiles(itemName,imagesFilesMap)) {
                                 //System.out.println("has no attachments only text");
                                 db1.append("\"").append(itemValueStr).append("\"");
                                 } else if (!finalsb.isEmpty() && StringUtils.isBlank(itemValueStr)) {
                                 // System.out.println("has attachments no text");
                                 // this is for attachments only
                                 db1.append(finalsb);
                                 } else if (!finalsb.isEmpty() && StringUtils.isNotBlank(itemValueStr)) {
                                 // System.out.println("has both attachments and text");
                                 String replacedStr = StringUtils.replace(finalsb, "[", "").replace("]", "").replace(finalsb, "\"");
                                 //  db1.append("\"").append(itemValueStr).append(" Attachment Info - "+replacedStr).append("\"");
                                 db1.append("{\"Text Value\" :\"").append(itemValueStr).append("\"").append(",\"Attachement Info\" :").append(finalsb).append("}");
                                 //  System.out.println("Formated text and Attachments data : "+db1.toString());
                                 }*/
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("exception " + e);
            //logger.info("STR doGet after session******************************************************************" + e );
        }
    }

    private static String getValueString(Session session, Object obj, int type) {

        String valueString = StringUtils.EMPTY;

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
            System.out.println("exception = " + e);
            //e.printStackTrace();
            // Be quiet.
        }
        return addSlashes(valueString);
        //return (valueString);
    }

    private static String addSlashes(String text) {
        final StringBuffer sb = new StringBuffer(text.length() * 2);
        final StringCharacterIterator iterator = new StringCharacterIterator(
                text);

        char character = iterator.current();

        while (character != StringCharacterIterator.DONE) {
            if (character == '\n') {
                sb.append("\\n");
                //sb.replace(sb.length(), sb.length(), "\\n");
            } else if (character == '\r') {
                //sb.replace(sb.length(), sb.length(), "\\r");
                sb.append("\\r");
            } else if (character == '"') {
                //sb.append("\\\"");
                sb.replace(sb.length(), sb.length(), "");
                //  } else if (character == '\'') {
                //    sb.append("\\\'");
                //  } else if (character == '\\') {
                //     sb.append("\\\\");
                //} else if (character == '\n') {
                //    sb.append("\\n");
                // } else if (character == '{') {
                //    sb.append("\\{");
                //  } else if (character == '}') {
                //     sb.append("\\}");
            } else {
                sb.append(character);
            }

            character = iterator.next();
        }

        return sb.toString();
    }

    private static Map<String, List<String>> processImagesINDocument(Document document, Session session, DB cimAPPSMongoDb, String str_number) {
        Map<String, List<String>> imageFileNamesMap = new HashMap<String, List<String>>();
        try {
            System.out.println("Proces Image start");
            // Third Approch -- Need to code 
            DxlExporter dxlExporter = session.createDxlExporter();
            dxlExporter.setConvertNotesBitmapsToGIF(true);
            String documentXMLString = dxlExporter.exportDxl(document);
            documentXMLString = LotusUtils.removeDTDInfoFromXML(documentXMLString);
            imageFileNamesMap = getImageData(documentXMLString, cimAPPSMongoDb, str_number);
            // Second Approch - HTML / WEb Page - login failure
            // processImageUsingHTMLpage(document, session, cimAPPSMongoDb, str_number);
            System.out.println("Proces Image Completed");
        } catch (Exception ex) {
            System.out.println(ex);
        }
        return imageFileNamesMap;
    }

    private static Map<String, List<String>> getImageData(String generateXML, DB cimAPPSMongoDb, String str_number) {
        Map<String, List<String>> imageFileNamesMap = new HashMap<String, List<String>>();
        try {
            System.out.println("Processing XMl data recevied from Document");
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder newDocumentBuilder = docBuilderFactory.newDocumentBuilder();
            org.w3c.dom.Document documentDOM = newDocumentBuilder.parse(new InputSource(new StringReader(generateXML)));
            if (documentDOM != null) {
                System.out.println("Document DOM parsed successfully");
                imageFileNamesMap = getNotesBitmapData(documentDOM, cimAPPSMongoDb, str_number);
            }
        } catch (ParserConfigurationException | SAXException | IOException ex) {
            System.out.println("Exception : " + ex);
        }
        return imageFileNamesMap;
    }

    private static Map<String, List<String>> getNotesBitmapData(org.w3c.dom.Document documentDOM, DB cimAPPSMongoDb, String str_number) {

        Map<String, List<String>> imageFilesmap = new HashMap<String, List<String>>();
        NodeList richTextElements = documentDOM.getElementsByTagName("richtext");
        if (richTextElements != null) {
            System.out.println("Number Of Bimap/Inline images in document " + richTextElements.getLength());
            for (int richTextEleCounter = 0; richTextEleCounter < richTextElements.getLength(); richTextEleCounter++) {
                int imageCounter = 0;
                Node richTextEle = richTextElements.item(richTextEleCounter);
                NamedNodeMap richTextItemParentNode = richTextEle.getParentNode().getAttributes();
                System.out.println("Item Name : " + richTextItemParentNode.getNamedItem("name").getNodeValue());
                String itemName = richTextItemParentNode.getNamedItem("name").getNodeValue();
                List<String> imageFileNameList = new ArrayList<String>();
                if (richTextEle.getNodeType() == Node.ELEMENT_NODE) {
                    Element richTextElement = (Element) richTextEle;
                    NodeList pictureElementList = richTextElement.getElementsByTagName("picture");
                    System.out.println("Picture tag length " + pictureElementList.getLength());
                    for (int pictureEleCont = 0; pictureEleCont < pictureElementList.getLength(); pictureEleCont++) {
                        Node pictureElement = pictureElementList.item(pictureEleCont);
                        if (pictureElement != null && pictureElement.getNodeType() == Node.ELEMENT_NODE) {
                            if (!pictureElement.getParentNode().getNodeName().equalsIgnoreCase("attachmentref")) {
                                NodeList pictureEleList = pictureElement.getChildNodes();
                                Node gifImageNode = pictureEleList.item(0);
                                if (gifImageNode.getNodeType() == Node.ELEMENT_NODE && gifImageNode.getNodeName().equalsIgnoreCase("gif")) {
                                    Element imageElement = (Element) gifImageNode;
                                    String imageByteDataStr = imageElement.getTextContent();
                                    String fileName = str_number + "_" + itemName + "_" + imageCounter++ + ".jpg";
                                    String outFileName = "C:\\app\\" + fileName;
                                    decodeImagebyteCodeANdWriteImagesToDisk(imageByteDataStr, fileName);
                                    saveEmbeddedObject(cimAPPSMongoDb, outFileName, fileName);
                                    imageFileNameList.add(fileName);
                                }
                            }
                        }
                    }
                }
                imageFilesmap.put(itemName, imageFileNameList);
            }
        }
        return imageFilesmap;
    }

    private static void decodeImagebyteCodeANdWriteImagesToDisk(String imageByteDataStr, String fileName) {
        try {
            System.out.println("Writing Image Fils to Disk >> ");
            String dirName = "C:\\app\\" + fileName;
            //FileOutputStream outputStream = new FileOutputStream("C:\\app\\inLineImage" + imageCount + ".jpg");

            byte[] bytearray = Base64.decodeBase64(imageByteDataStr);
            //System.out.println(Arrays.toString(bytearray));
            BufferedImage imag = ImageIO.read(new ByteArrayInputStream(bytearray));
            ImageIO.write(imag, "jpg", new File(dirName));

            //outputStream.write(imageByteDataStr.getBytes());
            //outputStream.close();
            System.out.println("Writing Image Fils to Disk Completed ");
        } catch (FileNotFoundException ex) {
            System.out.println("Exception : " + ex);
        } catch (IOException ex) {
            System.out.println("Exception : " + ex);
        }
    }

    private static void processImageUsingHTMLpage(Document document, Session session, DB cimAPPSMongoDb, String str_number) {
        System.out.println("PRocessing document as webpage start ");
        Collection<String> imageUrls = new ArrayList<String>();

        try {
            URL uriLink = new URL(document.getHttpURL());
            HttpURLConnection con = authenticateAndGetConnectionObject(document.getHttpURL());
            String documentHTMLContent = LotusUtils.readStream(con.getInputStream());
            org.htmlparser.Parser parser = new org.htmlparser.Parser();
            parser.setInputHTML(documentHTMLContent);
            System.out.println("Document HTML: " + documentHTMLContent);
            // FileUtils.writeStringToFile(new File("c://app/docment.html"), documentHTMLContent);
            org.htmlparser.util.NodeList list = parser.extractAllNodesThatMatch(new NodeClassFilter(ImageTag.class));
            System.out.println("Total Image Node List" + list.size());
            for (int i = 0; i < list.size(); i++) {
                ImageTag extracted = (ImageTag) list.elementAt(i);
                org.htmlparser.Node ImageParentNode = extracted.getParent();
                if (!(ImageParentNode instanceof LinkTag)) {
                    String extractedImageSrc = extracted.getImageURL();
                    if (StringUtils.containsIgnoreCase(extractedImageSrc, "/FAB/STR.nsf/") && !StringUtils.containsIgnoreCase(extractedImageSrc, "/icons/")) {
                        imageUrls.add(extractedImageSrc);
                    }
                }
            }
            Map<String, Integer> itemNameAndFileNameCounterMap = new HashMap<String, Integer>();
            for (String imgSrc : imageUrls) {
                String imageURL = buildImageURL(uriLink.getProtocol(), uriLink.getHost(), imgSrc);
                String iteamName = imageURL.substring(StringUtils.ordinalIndexOf(imageURL, "/", StringUtils.countMatches(imageURL, "/") - 1) + 1, StringUtils.lastIndexOf(imageURL, "/"));
                String fileName = str_number + "_" + iteamName;
                if (itemNameAndFileNameCounterMap.get(fileName) != null) {
                    Integer fileCount = itemNameAndFileNameCounterMap.get(fileName);
                    itemNameAndFileNameCounterMap.put(fileName, ++fileCount);
                } else {
                    itemNameAndFileNameCounterMap.put(fileName, 0);
                }
                fileName = fileName + "-Image" + itemNameAndFileNameCounterMap.get(fileName);
                String outFileName = "C:\\app\\" + fileName + ".jpg";
                downloadImage(imageURL, outFileName);
                System.out.println("Saving Image File to Mongo" + fileName);
                saveEmbeddedObject(cimAPPSMongoDb, outFileName, fileName + ".jpg");
            }
        } catch (Exception e) {
            System.out.println("Exception : " + e);
        }

    }

    private static HttpURLConnection authenticateAndGetConnectionObject(String url) throws MalformedURLException, IOException {
        URL webURL = new URL(url);
        String authString = "whitem:Pnot4u2";
        byte[] authEncBytes = Base64.encodeBase64(authString.getBytes());
        String authStringEnc = new String(authEncBytes);
        HttpURLConnection con = (HttpURLConnection) webURL.openConnection();
        con.setRequestProperty("Authorization", "Basic " + authStringEnc);
        con.connect();
        System.out.println("Connection opened Successfully");
        return con;
    }

    private static String buildImageURL(String protocal, String host, String sourceUrl) throws MalformedURLException {
        URL imageUrl = new URL(protocal + "://" + host + "/" + sourceUrl);

        //   System.out.println("Image path [ " + imageUrl.getPath() + " ]");
        //    System.out.println("Image Query params [ " + imageUrl.getQuery() + " ]");
        String query = imageUrl.getQuery();

        String[] imageFormat = query.split("=");
        if (imageFormat != null && imageFormat.length > 0) {
            //        System.out.println("Image Format " + imageFormat[1]);
        }
        String imagePath = imageUrl.getPath();
        String imageName = imagePath.substring(StringUtils.lastIndexOf(imagePath, "/"), imagePath.length());
        //String iteamName = imagePath.substring(StringUtils.ordinalIndexOf(imagePath, "/", StringUtils.countMatches(imagePath, "/")-1)+1, StringUtils.lastIndexOf(imagePath, "/"));
        String newPath = imagePath.substring(1, StringUtils.lastIndexOf(imagePath, "/")) + imageName + "." + imageFormat[1];
        //   System.out.println("New Path" + newPath);
        String imageURL = protocal + "://" + host + newPath;
        System.out.println("New URL Built : " + imageURL);
        return imageURL;
    }

    public static void downloadImage(String imageURL, String fileName) throws MalformedURLException, IOException, FileNotFoundException {
        HttpURLConnection urlConnection = authenticateAndGetConnectionObject(imageURL);
        BufferedImage read = ImageIO.read(urlConnection.getInputStream());
        ImageIO.write(read, "jpg", new File(fileName));
    }

    private static void saveEmbeddedObject(DB cimAppsMongoDB, String filepath, String fileName) {
        try {
            File docFile = new File(filepath);
            // create a "cimappsSTR" namespace
            GridFS gfscimapps = new GridFS(cimAppsMongoDB, "cimappsSTR1");
            // remove the image file from mongoDB
            // try query not on file name but on the id or use find for the _id
            //gfscimapps.remove(gfscimapps.findOne(ObjName.toString())); //this removes all previous GridFS entries even though it shouldnt
            // get doc file from local drive
            GridFSInputFile gfsFile = gfscimapps.createFile(docFile);
            // set a new filename for identify purpose
            gfsFile.setFilename(fileName);
            // save the image file into mongoDB
            gfsFile.save();
            // get image file by it's filename
            GridFSDBFile imageForOutput = gfscimapps.findOne(fileName);
            //imageForOutput.
        } catch (UnknownHostException e) {
            System.out.println("exception " + e);
        } catch (MongoException | IOException e) {
            System.out.println("exception " + e);
        }
    }

    private static boolean isVallidSTRNumber(String str_number) {
        return !str_number.isEmpty() && StringUtils.trim(str_number).equalsIgnoreCase("SNPBAJ11290100766");//|| (StringUtils.trim(str_number).equalsIgnoreCase("SNPBGE03080000018")));SNPBSK02211603803, SNPBAJ11290100766, SNPBYK04150200934
    }

    private static void saveEmbeddedObjectGroup(Item item, String str_number, Mongo mongo, HashSet<String> attNames, String path2) {
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.

        //try {
        //Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
        // Logger.getLogger(STRsave.class.getName()).info(  "mongo instance done");
        DB db1 = mongo.getDB("cimapps");
        //String path = "c:\\app\\";
        StringBuilder ObjName = new StringBuilder();
        //ObjName.append(str_number).append("-").append(item.getName());
        //File docFile = new File(path2);
        //File folder = new File(path2);
        File folder = new File("/app/");
//            File[] allDocs = folder.listFiles();
//            List<File> fileList = new ArrayList<>();
//            int count = 0;
//            while (count < allDocs.length){
//                if (allDocs[count].isDirectory()){
//                   
//                }
//                else if(attNames.contains(allDocs[count].getName())){
//                    fileList.add(allDocs[count]) ;
//                    
//                }
//                count++;
//            }
//            if(fileList.size() < 1){
//                return;
//            }
        // create a "cimappsSTR" namespace
        GridFS gfscimapps = new GridFS(db1, "cimappsSTR");
//           List<InputStream> opened = new ArrayList<>(attNames.size());
//           // InputStream is = null ;
//            String file = "";
//            for (File f : fileList) { 
//                InputStream is = new FileInputStream(f);
//                String UTF8 = "utf8";
//                int BUFFER_SIZE = 8192;
//                BufferedReader br = new BufferedReader(new InputStreamReader(is,
//                        UTF8), BUFFER_SIZE);
//                String str;
//                while ((str = br.readLine()) != null) {
//                    file += str;
//                }
//                   
//             } 
//            byte[] b = file.getBytes(Charset.forName("UTF-8"));
        //GridFSInputFile gfsFile = gfscimapps.createFile(b);
        //    iss = new SequenceInputStream(Collections.enumeration(opened));

        //byte[] b = is.getBytes(Charset.forName("UTF-8"));
        //Iterator it = opened.listIterator();
        //while(it.hasNext()){
        //opened.stream().close();
        //}
        //GridFSInputFile gfsFile = gfscimapps.createFile(iss,ObjName.toString() );  
        //GridFSInputFile gfsFile = gfscimapps.createFile(is,ObjName.toString() );
        // set a new filename for identify purpose
        //gfsFile.setFilename(ObjName.toString());
        // save the image file into mongoDB
        //gfsFile.save();
        //for (File file: allDocs) {
        //    if (!file.isDirectory()) file.delete();
        //}
        //} catch (MongoException | IOException | NotesException e) {
        //System.out.println("exception = " + e);
        //Logger.getLogger(LotusNotes2Mongo.class.getName()).log(Level.SEVERE, null, e);
    }

    private static boolean hasImageFiles(String itemName, Map<String, List<String>> imagesFilesMap) {
        List<String> imageFileNamesInDocItem = imagesFilesMap.get(itemName.trim());
        return imageFileNamesInDocItem != null && !imageFileNamesInDocItem.isEmpty();
    }

}
//
