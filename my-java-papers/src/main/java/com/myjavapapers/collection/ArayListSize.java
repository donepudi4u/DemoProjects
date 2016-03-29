package com.myjavapapers.collection;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;

public class ArayListSize {

	public static void main(String[] args) {
		/*List<String> listVal = new ArrayList<String>();
		if (CollectionUtils.isNotEmpty(listVal)){
			System.out.println(listVal.get(0));
		}
*/
		/*Set<String> setVal = new HashSet<String>();
		setVal.add("Dileep");
		
		if (CollectionUtils.isNotEmpty(setVal)){
			System.out.println(setVal.iterator().next());
		}*/
		Integer integer = new Integer(10);
		System.out.println("Main 1 :"+integer);
		printValue(integer);
		System.out.println("main 2: "+integer);
	}
	
	public static void printValue(Integer val){
		System.out.println("In Method : "+val);
		val = val+10;
		System.out.println("In Method Add  : "+val);
	}

}
