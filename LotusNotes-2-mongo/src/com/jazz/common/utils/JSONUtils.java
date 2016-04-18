package com.jazz.common.utils;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;

public class JSONUtils {

	public String covertMapToJSONString(Map<String, List<String>> map) {
		Gson gson = new Gson();
		String jsonStr = gson.toJson(map);
	//	System.out.println(jsonStr);
		return jsonStr;
	}
	
	public static String mergeJSONObjects(String jsonStr1,String jsonStr2) {
		jsonStr1 = StringUtils.removeStart(jsonStr1, "\"");
		 jsonStr1 = StringUtils.removeEnd(jsonStr1, "\"");
		 jsonStr1 = StringEscapeUtils.unescapeJava(jsonStr1);
		// System.out.println("First Json String : "+jsonStr1);
		// System.out.println("Second/RichText   Json String : "+jsonStr2);
		JSONObject json1 = new JSONObject(jsonStr1);
		JSONObject json2 = new JSONObject(jsonStr2);
		JSONObject mergedJSON = new JSONObject();
		try {
			mergedJSON = new JSONObject(json1, JSONObject.getNames(json1));
			for (String crunchifyKey : JSONObject.getNames(json2)) {
				mergedJSON.put(crunchifyKey, json2.get(crunchifyKey));
			}
 
		} catch (JSONException e) {
			throw new RuntimeException("JSON Exception" + e);
		}
		return mergedJSON.toString();
	}

}
