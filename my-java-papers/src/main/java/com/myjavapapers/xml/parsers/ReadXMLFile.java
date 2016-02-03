package com.myjavapapers.xml.parsers;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ReadXMLFile {

	public static void main(String[] args) {

		try {
			for (int i= 0 ; i<=275 ; i++) {
				File file = new File("C:/Users/xprk791/Desktop/temp/tih/ETA-Events/File_"+ i+".xml");
				DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
				Document doc = dBuilder.parse(file);
				if (doc.hasChildNodes()) {
					//System.out.println("\n **************      " + i +"     ************************");
					System.out.println("");
					printNote(doc.getElementsByTagName("text"));
					//System.out.println("--------------      " + i +" END ------------------------");
				}
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

	private static void printTextMessage(String source) throws ParserConfigurationException, SAXException, IOException {
		if (StringUtils.isNotBlank(source)){
			DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			
			Document doc = dBuilder.parse(IOUtils.toInputStream(source, "UTF-8"));
			//	System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
			NodeList eventDetail = doc.getElementsByTagName("evnt");
			//if (checkforTIHEvents(eventDetail)){
				NodeList mvDocDetail = doc.getElementsByTagName("mv_doc_detail");
				NodeList equipmentDetail = doc.getElementsByTagName("eqmt");
				NodeList plannedEvent = doc.getElementsByTagName("plnd_evnt");
				printAttributes(eventDetail);
				printAttributes(equipmentDetail);
				printAttributes(mvDocDetail);
				printAttributes(plannedEvent);
				//System.out.println("------------------------------------------------------");
			//}
		}
		
	}

	private static Boolean checkforTIHEvents(NodeList eventDetail) {
		for (int count = 0; count < eventDetail.getLength(); count++) {
			Node tempNode = eventDetail.item(count);
			// make sure it's element node.
			if (tempNode.getNodeType() == Node.ELEMENT_NODE) {
				// get node name and value
				if (tempNode.hasAttributes()) {
					// get attributes names and values
					NamedNodeMap nodeMap = tempNode.getAttributes();
					for (int i = 0; i < nodeMap.getLength(); i++) {
						Node node = nodeMap.item(i);
						String nodeValue = node.getNodeValue();
						if (StringUtils.equalsIgnoreCase(StringUtils.trim(nodeValue), "CP")
								|| StringUtils.equalsIgnoreCase(StringUtils.trim(nodeValue), "RL")
								|| StringUtils.equalsIgnoreCase(StringUtils.trim(nodeValue), "AP")) {
							return Boolean.TRUE;
						}
					}
				}
			}
		}
		return Boolean.FALSE;
	}

	private static void printAttributes(NodeList mvDocDetail) throws DOMException, ParserConfigurationException, SAXException, IOException {
		
		for (int count = 0; count < mvDocDetail.getLength(); count++) {
			Node tempNode = mvDocDetail.item(count);
			// make sure it's element node.
			if (tempNode.getNodeType() == Node.ELEMENT_NODE) {
				// get node name and value
				if (tempNode.hasAttributes()) {
					// get attributes names and values
					NamedNodeMap nodeMap = tempNode.getAttributes();
					for (int i = 0; i < nodeMap.getLength(); i++) {
						Node node = nodeMap.item(i);
						if (node.getNodeName().equalsIgnoreCase("eqmt_init")){
							System.out.print("Equipment ::" + node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("eqmt_nbr")){
							System.out.print(" " +node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("stcc_code")){
							//System.out.println("STCC Code: :" + node.getNodeValue());
							//System.out.println("attr value : " + node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("tih_flag")){
							//System.out.println("tih_flag :: " + node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("evnt_code")){
							//System.out.println("evnt_code :: " + node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("stop_code")){
							//System.out.println("stop_code :: " + node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("stat_code")){
							//System.out.println("Status Code :: " + node.getNodeValue());
						}
						if (node.getNodeName().equalsIgnoreCase("evnt_dt")){
							//System.out.println("Event Date  :: " + node.getNodeValue());
						}
					}
				}
				if (tempNode.hasChildNodes()) {
					// loop again if has child nodes
					printNote(tempNode.getChildNodes());
				}
			}
		}
	}

	private static void printNote(NodeList nodeList) throws DOMException, ParserConfigurationException, SAXException, IOException {

		for (int count = 0; count < nodeList.getLength(); count++) {
			Node tempNode = nodeList.item(count);
			// make sure it's element node.
			if (tempNode.getNodeType() == Node.ELEMENT_NODE) {
				printTextMessage(tempNode.getTextContent());
				
			}
		}
	}
}