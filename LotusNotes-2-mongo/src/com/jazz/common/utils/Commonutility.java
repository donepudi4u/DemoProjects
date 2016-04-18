package com.jazz.common.utils;

import java.util.Map;
import java.util.Set;

import lotus.domino.EmbeddedObject;
import lotus.domino.Item;
import lotus.domino.NotesException;

public class Commonutility {

	public static void printMapDetails(Map<String, String> map) {
		System.out.println("MAP Values PRINT : ");
		Set<String> keySet = map.keySet();
		for (String key : keySet) {
			String string = map.get(key);
			System.out.println("[ " + key + " : " + string + " ]");
		}
	}

	public static StringBuilder buildAttachemntName(EmbeddedObject embObj, String str_number, Item item)throws NotesException {
		StringBuilder embeddedObjectFileName = new StringBuilder();
		embeddedObjectFileName.append(str_number).append("-").append(item.getName()).append("-").append(embObj.getName());
		return embeddedObjectFileName;
	}

}
