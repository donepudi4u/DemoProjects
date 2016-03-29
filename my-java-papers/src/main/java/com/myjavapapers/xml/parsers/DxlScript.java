package com.myjavapapers.xml.parsers;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

public class DxlScript {
	public static String separator = "\n<=============================================>\n";

	public static void main(String args[]) {
		String inFileName = "C:\\Users\\xprk791\\Desktop\\test.xml";
		String outFileName = "C:\\Users\\xprk791\\Desktop\\test.jpeg";
		PrintWriter out;
		String inString = "";
		String outString = "";

		/*switch (args.length) {
		case 0:
			System.out.println("USAGE: DxlScript InputFileName [OutputFileName]\n");
			System.out.println("This program will decode the encoded LotusScript from");
			System.out.println("a Notes DXL file. If no OutputFileName is provided,");
			System.out.println("output will be sent to the console.");
			return;
		case 1:
			inFileName = args[0];
			break;
		case 2:
		default:
			inFileName = args[0];
			outFileName = args[1];
			break;
		}*/

		try {
			if (outFileName.length() > 0)
				out = new PrintWriter(new FileWriter(outFileName));
			else
				out = new PrintWriter(System.out);

			decodeScript(inFileName, out);
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * Gets the LotusScript from your DXL file.
	 * 
	 * @param fileName
	 *            the name of the DXL file we're getting information from
	 * @param out
	 *            a PrintWriter to send the resulting information to
	 */
	public static void decodeScript(String fileName, PrintWriter out) {
		try {
			// build the JDom document
			SAXBuilder builder = new SAXBuilder();
			Document doc = builder.build(fileName);

			// get the root
			Element root = doc.getRootElement();

			// get the LotusScript beneath the root
			findScriptElements(root, out, "<" + root.getName() + " "
					+ getAttr(root) + ">");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Private method that recursively finds and decodes the LotusScript entries
	 * beneath a given XML element.
	 * 
	 * @param parent
	 *            the Element we're searching beneath
	 * @param out
	 *            the PrintWriter to send the LotusScript to, if we find it
	 * @param branch
	 *            a String of the Element tags leading up to parent
	 */
	private static void findScriptElements(Element parent, PrintWriter out,
			String branch) {
		List kids = parent.getChildren();
		Iterator i = kids.iterator();
		while (i.hasNext()) {
			Element thisKid = (Element) i.next();
			if (thisKid.getName().compareTo("itemdata") == 0) {
				String kidType = thisKid.getAttributeValue("type");
				if ((kidType.compareTo("10") == 0)
						|| (kidType.compareTo("500") == 0)) {
					// itemdata of type 10 is an agent, and type 500 is a
					// script library. Itemdata is encoded as Base64.
					byte[] inBytes = thisKid.getText().getBytes();
					byte[] outBytes = Base64.decodeBase64(inBytes);
					String outString = new String(outBytes);

					out.println(branch);
					// agents have a 14-byte header we need to step over
					if (kidType.compareTo("10") == 0)
						out.println(outString.substring(14));
					else
						out.println(outString);

					out.println(separator);
				}
			} else if (thisKid.getName().compareTo("lotusscript") == 0) {
				// lotusscript elements (found in forms, views, etc.) are
				// just straight, unencoded text
				out.println(branch);
				out.println(thisKid.getText());
				out.println(separator);
			} else {
				// we didn't find anything here, so we can make a recursive
				// call to search the children under this branch (append
				// the element info to the branch before making the call,
				// so we know where we came from)
				StringBuffer tag = new StringBuffer("<" + thisKid.getName());
				tag.append(" " + getAttr(thisKid));

				// so we know what we're dealing with...
				// grab the Title of this branch, if there is one
				String title = getItem(thisKid, "$TITLE");
				if (title.length() > 0)
					tag.append(" title='" + title + "'");

				// and try to get the Flags too
				String flags = getItem(thisKid, "$Flags");
				if (flags.length() > 0)
					tag.append(" flags='" + flags + "'");

				tag.append(">");

				findScriptElements(thisKid, out, branch + "\n" + tag.toString());
			}
		}

	}

	/**
	 * Returns a String of all the attributes of a given Element.
	 * 
	 * @param parent
	 *            the Element you want the attributes of
	 * @return an attribute String you can use in an element tag
	 */
	private static String getAttr(Element parent) {
		StringBuffer tags = new StringBuffer();
		List attList = parent.getAttributes();
		Iterator ai = attList.iterator();
		while (ai.hasNext()) {
			Attribute att = (Attribute) ai.next();
			tags.append(" " + att.getName() + "='" + att.getValue() + "'");
		}

		return tags.toString().trim();
	}

	/**
	 * Returns the value of a given "item" Element beneath the given Element.
	 * 
	 * @param parent
	 *            the Element that should contain the item as a sub-element
	 * @param itemName
	 *            the name Attribute of the item you're looking for
	 * @return either the value of the item as a String, or an empty String ("")
	 *         if the item is not found
	 */
	private static String getItem(Element parent, String itemName) {
		List kids = parent.getChildren();
		Iterator i = kids.iterator();
		while (i.hasNext()) {
			Element thisKid = (Element) i.next();
			if ((thisKid.getName().compareTo("item") == 0)
					&& (thisKid.getAttributeValue("name").compareTo(itemName) == 0)) {
				List tCount = thisKid.getChildren();
				return ((Element) tCount.get(0)).getText();
				// for some really strange reason, this returns null:
				// return thisKid.getChildText("text");
			}
		}

		return "";
	}

}
