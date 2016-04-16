package com.jazz.common.utils;

import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

public class JSONUtils {

	public String covertMapToJSONString(Map<String, List<String>> map) {
		Gson gson = new Gson();
		String jsonStr = gson.toJson(map);
		System.out.println(jsonStr);
		return jsonStr;
	}

}
