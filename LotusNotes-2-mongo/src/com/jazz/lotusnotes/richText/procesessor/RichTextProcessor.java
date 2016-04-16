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
import com.mongodb.DB;

import lotus.domino.DxlExporter;
import lotus.domino.Item;
import lotus.domino.NotesException;
import lotus.domino.Session;

public class RichTextProcessor {

	public static void processRichTextData(DB cimAppsDB, HashSet<String> attachmentNames, Item docItem, String strNumber) {
		System.out.println("Process Rich Text Items Start");
	}
	
	public static Map<String, String> processRichTextData(DB cimAppsDB, Session session,lotus.domino.Document document, String strNumber) {
		System.out.println("Process Rich Text Items Start");
		 Map<String, String> richtextDataMap =null;
		try {
			org.w3c.dom.Document documentDOM = getDocumentFromLotusDocument(session, document);
             richtextDataMap = getNotesBitmapData(documentDOM, cimAppsDB, strNumber);
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

	private static org.w3c.dom.Document getDocumentFromLotusDocument(Session session, lotus.domino.Document document)
			throws NotesException, ParserConfigurationException, SAXException, IOException {
		DxlExporter dxlExporter;
		dxlExporter = session.createDxlExporter();
		dxlExporter.setConvertNotesBitmapsToGIF(true);
		String documentHtmlStr = dxlExporter.exportDxl(document);
		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder newDocumentBuilder = docBuilderFactory.newDocumentBuilder();
		documentHtmlStr = LotusUtils.removeDTDInfoFromXML(documentHtmlStr);
		org.w3c.dom.Document documentDOM = newDocumentBuilder.parse(new InputSource(new StringReader(documentHtmlStr)));
		return documentDOM;
	}
	
	
	private static Map<String, String> getNotesBitmapData(org.w3c.dom.Document documentDOM, DB cimAPPSMongoDb,
			String str_number) {

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

	private static void handleRichTExtElement(Map<String, String> richtextDataMap, int imageCounter,Node richTextEle) {
		NamedNodeMap richTextItemParentNode = richTextEle.getParentNode().getAttributes();
		System.out.println("Item Name : " + richTextItemParentNode.getNamedItem("name").getNodeValue());
		List<String> richtextDataLines = new ArrayList<String>();
		String itemName = richTextItemParentNode.getNamedItem("name").getNodeValue();
		if (richTextEle.getNodeType() == Node.ELEMENT_NODE) {
			Element richTextElement = (Element) richTextEle;
			NodeList childNodes = richTextElement.getChildNodes();
			for (int richTextSubElementCounter = 0; richTextSubElementCounter < childNodes.getLength(); richTextSubElementCounter++) {
				Node richTextSubElement = childNodes.item(richTextSubElementCounter);
				handleRichTextChildElements(imageCounter, richtextDataLines, childNodes, richTextSubElement);
			}
			richtextDataMap.put(itemName, StringUtils.join(richtextDataLines,"\n"));
			//System.out.println("RichTExt Data: <> "+richtextDataLines.toString());
		}
	}

	private static void handleRichTextChildElements(int imageCounter, List<String> richtextDataLines,NodeList childNodes, Node richTextSubElement) {
		if(richTextSubElement.hasChildNodes()){
			getNodeValueFromElementLsist(richTextSubElement,richtextDataLines,imageCounter);
		}
		System.out.println(childNodes.toString());
	}

	private static void getNodeValueFromElementLsist(Node richTextSubElement, List<String> richtextDataLines, int imageCounter) {
		if (richTextSubElement.getNodeType() == Node.ELEMENT_NODE && richTextSubElement.hasChildNodes()) {
			//if (!richTextSubElement.getNodeName().equalsIgnoreCase("gif")|| !richTextSubElement.getNodeName().equalsIgnoreCase("attachmentref")) {
				NodeList childNodes = richTextSubElement.getChildNodes();
				for (int childEleCounter = 0; childEleCounter < childNodes.getLength(); childEleCounter++) {
					Node childNode = childNodes.item(childEleCounter);
					if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.hasChildNodes()) {
						if (childNode.getNodeName().equalsIgnoreCase("run")) {
							System.out.println("Text value" + childNode.getTextContent());
							richtextDataLines.add(childNode.getTextContent());
						} else if (childNode.getNodeName().equalsIgnoreCase("picture")) {
							if (!childNode.getParentNode().getNodeName().equalsIgnoreCase("attachmentref")) {
								NodeList pictureEleList = childNode.getChildNodes();
								Node gifImageNode = pictureEleList.item(0);
								if (gifImageNode.getNodeType() == Node.ELEMENT_NODE
										&& gifImageNode.getNodeName().equalsIgnoreCase("gif")) {
									Element imageElement = (Element) gifImageNode;
									String imageByteDataStr = imageElement.getTextContent();
									String fileName  =  "image_"+imageCounter+".jpg";
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
}
