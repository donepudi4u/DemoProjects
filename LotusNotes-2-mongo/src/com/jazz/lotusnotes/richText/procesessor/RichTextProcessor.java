package com.jazz.lotusnotes.richText.procesessor;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.imageio.ImageIO;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.util.Base64;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.jazz.common.utils.Commonutility;
import com.jazz.common.utils.LotusUtils;
import com.jazz.mongodb.impl.MongoDBDaoImpl;
import com.mongodb.DB;

import lotus.domino.DxlExporter;
import lotus.domino.EmbeddedObject;
import lotus.domino.Item;
import lotus.domino.NotesException;
import lotus.domino.RichTextItem;
import lotus.domino.Session;

public class RichTextProcessor {
	private Session session;
	private lotus.domino.Document document;
	private String strNumber;
	MongoDBDaoImpl daoImpl;
	
	public RichTextProcessor(DB cimAppsDB, Session session,lotus.domino.Document document,String strNumber){
		daoImpl = new MongoDBDaoImpl(cimAppsDB);
		this.session = session;
		this.document = document;
		this.strNumber = strNumber;
		
	}
	public Session getSession() {
		return session;
	}
	public void setSession(Session session) {
		this.session = session;
	}
	public lotus.domino.Document getDocument() {
		return document;
	}
	public void setDocument(lotus.domino.Document document) {
		this.document = document;
	}
	public String getStrNumber() {
		return strNumber;
	}
	public void setStrNumber(String strNumber) {
		this.strNumber = strNumber;
	}
	
	public static void processRichTextData(DB cimAppsDB, HashSet<String> attachmentNames, Item docItem, String strNumber) {
		System.out.println("Process Rich Text Items Start");
	}
	
	public  Map<String, String> processRichTextData() {
		System.out.println("Process Rich Text Items Start");
		 Map<String, String> richtextDataMap =null;
		try {
			org.w3c.dom.Document documentDOM = getDocumentFromLotusDocument();
             richtextDataMap = getRichTextDataAsMap(documentDOM);
		} catch (NotesException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} 
		return richtextDataMap;
	}

	private  org.w3c.dom.Document getDocumentFromLotusDocument()throws NotesException, ParserConfigurationException, SAXException, IOException {
		DxlExporter dxlExporter;
		dxlExporter = getSession().createDxlExporter();
		dxlExporter.setConvertNotesBitmapsToGIF(true);
		String documentHtmlStr = dxlExporter.exportDxl(getDocument());
		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder newDocumentBuilder = docBuilderFactory.newDocumentBuilder();
		documentHtmlStr = LotusUtils.removeDTDInfoFromXML(documentHtmlStr);
		org.w3c.dom.Document documentDOM = newDocumentBuilder.parse(new InputSource(new StringReader(documentHtmlStr)));
		return documentDOM;
	}
	
	
	private  Map<String, String> getRichTextDataAsMap(org.w3c.dom.Document documentDOM) {

		Map<String, String> richtextDataMap = new HashMap<String, String>();
		NodeList richTextElements = documentDOM.getElementsByTagName("richtext");
		if (richTextElements != null) {
			System.out.println("Number Of RichText Fileds in  document " + richTextElements.getLength());
			for (int richTextEleCounter = 0; richTextEleCounter < richTextElements.getLength(); richTextEleCounter++) {
				int imageCounter = 0;
				Node richTextEle = richTextElements.item(richTextEleCounter);
				handleRichTExtElement(richtextDataMap, imageCounter, richTextEle);
			}
		}
		Commonutility.printMapDetails(richtextDataMap);
		return richtextDataMap;

	}

	private  void handleRichTExtElement(Map<String, String> richtextDataMap, int imageCounter,Node richTextEle) {
		NamedNodeMap richTextItemParentNode = richTextEle.getParentNode().getAttributes();
		//System.out.println("Item Name : " + richTextItemParentNode.getNamedItem("name").getNodeValue());
		List<String> richtextDataLines = new ArrayList<String>();
		String itemName = richTextItemParentNode.getNamedItem("name").getNodeValue();
		if (richTextEle.getNodeType() == Node.ELEMENT_NODE) {
			Element richTextElement = (Element) richTextEle;
			NodeList childNodes = richTextElement.getChildNodes();
			for (int richTextSubElementCounter = 0; richTextSubElementCounter < childNodes.getLength(); richTextSubElementCounter++) {
				Node richTextSubElement = childNodes.item(richTextSubElementCounter);
				handleRichTextChildElements(imageCounter, richtextDataLines, childNodes, richTextSubElement,itemName);
			}
			richtextDataMap.put(itemName, StringUtils.join(richtextDataLines,"\n"));
			//System.out.println("RichTExt Data: <> "+richtextDataLines.toString());
		}
	}

	private  void handleRichTextChildElements(int imageCounter, List<String> richtextDataLines,NodeList childNodes, Node richTextSubElement, String itemName) {
		if(richTextSubElement.hasChildNodes()){
			getNodeValueFromElementLsist(richTextSubElement,richtextDataLines,imageCounter,itemName);
		}
		//System.out.println(childNodes.toString());
	}

	private  void getNodeValueFromElementLsist(Node richTextSubElement, List<String> richtextDataLines, int imageCounter, String itemName) {
		if (richTextSubElement.getNodeType() == Node.ELEMENT_NODE && richTextSubElement.hasChildNodes()) {
			//if (!richTextSubElement.getNodeName().equalsIgnoreCase("gif")|| !richTextSubElement.getNodeName().equalsIgnoreCase("attachmentref")) {
				NodeList childNodes = richTextSubElement.getChildNodes();
				for (int childEleCounter = 0; childEleCounter < childNodes.getLength(); childEleCounter++) {
					Node childNode = childNodes.item(childEleCounter);
					if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.hasChildNodes()) {
						if (childNode.getNodeName().equalsIgnoreCase("run")) {
							//System.out.println("Text value" + childNode.getTextContent());
							richtextDataLines.add(childNode.getTextContent());
						} else if (childNode.getNodeName().equalsIgnoreCase("picture")) {
							if (!childNode.getParentNode().getNodeName().equalsIgnoreCase("attachmentref")) {
								NodeList pictureEleList = childNode.getChildNodes();
								Node gifImageNode = pictureEleList.item(0);
								if (gifImageNode.getNodeType() == Node.ELEMENT_NODE
										&& gifImageNode.getNodeName().equalsIgnoreCase("gif")) {
									Element imageElement = (Element) gifImageNode;
									String imageByteDataStr = imageElement.getTextContent();
									String fileName  =  getStrNumber()+"_"+itemName+"_"+imageCounter+".jpg";
									richtextDataLines.add(buildEmeddedPbjectDownloadURL(fileName));
									decodeImagebyteCodeANdWriteImagesToDisk(imageByteDataStr, fileName);
								}
							}
						} else if (childNode.getNodeName().equalsIgnoreCase("attachmentref")){
							NamedNodeMap attributes = childNode.getAttributes();
							Node namedItem = attributes.getNamedItem("name");
							//System.out.println("Attachment Name : "+ namedItem.getNodeValue());
							richtextDataLines.add(buildEmeddedPbjectDownloadURL(namedItem.getNodeValue()));
						//	richtextDataLines.add( namedItem.getNodeValue());
						}
					}
				}
			}
//		}
	}
	private static String buildEmeddedPbjectDownloadURL( String fileName) {
		return "<a href=\"GetEmbeddedObjs?fileName="+fileName+"\">"+fileName+"</a>"+"<br/>";
	}
	
	private  void decodeImagebyteCodeANdWriteImagesToDisk(String imageByteDataStr, String fileName) {
		try {
			System.out.println("Writing Image Fils to Disk >> ");
			String dirName = "C:\\app\\" + fileName;
			byte[] bytearray = Base64.decodeBase64(imageByteDataStr);
			BufferedImage imag = ImageIO.read(new ByteArrayInputStream(bytearray));
			ImageIO.write(imag, "jpg", new File(dirName));
			System.out.println("Writing Image Fils to Disk Completed ");
			System.out.println("Writing Image File into Mongo Db Start");
			daoImpl.saveEmbeddedObject(dirName, fileName);
			System.out.println("Writing Image File into Mongo Db Completed");
		} catch (FileNotFoundException ex) {
			System.out.println("Exception : " + ex);
		} catch (IOException ex) {
			System.out.println("Exception : " + ex);
		}
	}
		
	public  void processEmbeddedObjectsAndSaveToMongoDB(Item item) throws NotesException{

		RichTextItem riItem = (RichTextItem) item;
		Vector embv = riItem.getEmbeddedObjects(); //lotus notes embedded objects wont pass into arraylists directly
		ArrayList<?> emb = new ArrayList<>(embv);
		if (emb.size() > 0) {
		    for (Object emb1 : emb) {
		        EmbeddedObject embObj = (EmbeddedObject) emb1;
		            if (embObj.getSource().contains(".") && embObj.getFileSize() > 0) {
		                StringBuilder embeddedObjectFileName = Commonutility.buildAttachemntName(embObj, getStrNumber(), item);
		                String path = "c:\\app\\" + embObj.getSource();
		                //**must test to see if the embedded object is a file that can be extracted
		                if ("SNPBYA03191203049".equals(getStrNumber()) && embObj.getSource().contains(".JRP") || "SNPBYA04271203069".equals(getStrNumber())) {
		                    // bypassing these chart files - at least one is corrupt and cannot be extracted - lotus notes Checksum error
		                    //looking at the STR in Lotus notes shows the files are NOT exported in the same order as they appear so finding out
		                    //which file(s) is the culpret would require multiple iterations and Lotus Notes does not have a catch for the exception
		                } else {
		                    embObj.extractFile(path);
		                    daoImpl.saveEmbeddedObject( path, embeddedObjectFileName.toString());
		                }
		        }
		    }
		}
	}
}
