package com.myjavapapers.collection;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HashMapOperations {
	
	public static void main(String[] args) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		//map.put("Age", 30);
		List<Integer> list = new ArrayList<Integer>(map.values());
		System.out.println(list);
	}

}
