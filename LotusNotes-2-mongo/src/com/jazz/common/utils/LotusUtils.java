/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jazz.common.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author kudaraa
 */
public class LotusUtils {
    
    
    public static String readStream(InputStream in) {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(in));) {

            String nextLine = "";
            while ((nextLine = reader.readLine()) != null) {
                sb.append(nextLine);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return sb.toString();
    }
    
    
     public static String removeDTDInfoFromXML(String documentXMLString) {
        String substring = StringUtils.substring(documentXMLString, StringUtils.indexOf(documentXMLString, "SYSTEM"), StringUtils.indexOf(documentXMLString, "\'>") + 1);
        System.out.println("Removed Substring : " + substring);
        return StringUtils.replaceOnce(documentXMLString, substring, "");
    }
     
     public static String getListValueAsJSONVal(List<String> strList) {
        StringBuilder jsonStr = new StringBuilder("[");
        for (int fileCounter = 0; fileCounter < strList.size(); fileCounter++) {
            jsonStr.append("\"").append(strList.get(fileCounter)).append("\"");
            if (fileCounter != (strList.size() - 1)) {
                jsonStr.append(",");
            }
        }
        jsonStr.append("]");
         System.out.println("Json String Prepared : " + jsonStr.toString());
        return jsonStr.toString();
    }
    
}
