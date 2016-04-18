package temp;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import lotus.domino.Item;
import lotus.domino.Session;

import org.apache.commons.lang3.StringUtils;

import com.jazz.common.utils.LotusUtils;

public class CodeBackUpClass {
	
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
                        || item.getType() == Item.RICHTEXT
                        || item.getType() == Item.TEXT) {
                    v = item.getValues();

                    if (v != null && v.size() > 0) {
                        String itemName = item.getName();
                        if (itemName.contains("$")) {
                            itemName = itemName.replace("$", "");
                        }
                        if (attNames.size() > 0) {
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
                        }
                        if (itemName.contains("STR_Number")) {
                            String firstJson = "{\"_id\":\"" + item.getValueString() + "\"";
                            db1.replace(0, 0, firstJson);
                        } else {
                            db1.append(firstItem ? "{\"" : ",\"").append(itemName).append("\":");
                            if (v.size() > 1) {
                                db1.append("[");
                                it = v.iterator();
                                while (it.hasNext()) {
                                   // db1.append(firstValue ? "" : ",").append("\"").append(getValueString(session, it.next(), item.getType())).append("\"");
                                    firstValue = false;
                                }
                                // firstValue = true;
                                db1.append("]");
                            } else {
                                //  List<String> imageNamesList = new ArrayList<String>();
                                String itemValueStr = null;//getValueString(session, v.get(0), item.getType());
                                String attachementFiles = StringUtils.isNotBlank(finalsb) ? finalsb : StringUtils.EMPTY;
                                String imageNames = null;//hasImageFiles(itemName, imagesFilesMap) ? LotusUtils.getListValueAsJSONVal(imagesFilesMap.get(itemName)) : StringUtils.EMPTY;

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

}
