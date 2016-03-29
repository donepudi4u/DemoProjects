package com.myjavapapers.io.files;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;

public class TextFileOperations {
	
//		public static void manipulateFile(InputStream fileInputStream) throws IOException{
			public static void manipulateFile(FileReader fileReader) throws IOException{
			File localFile = new File("C:/Users/xprk791/Desktop","outFile.txt");
			//FileUtils.copyInputStreamToFile(fileInputStream, localFile);
			//List<String> readLines = FileUtils.readLines(localFile);
			List<String> lines = FileUtils.readLines(localFile);
			List<String> outLines = new ArrayList<String>();
			for (String line : lines) {
				if (StringUtils.isNotBlank(line)) // don't write out blank lines
				{
					String[] split = StringUtils.split(line," ");
					if (split != null && split.length >=5 ){
						String intVal = split[4];
						if (StringUtils.isNotBlank(intVal)){
							try{
								Float valeue = Float.valueOf(intVal).floatValue();
								if (valeue > 10){  // If less than 10 skip the operation.
									Float value2 = valeue/10;  // Check precision size we should display. Ex: 19.22 or 19.2234
									split[4] = value2.toString();
								}
							}catch(NumberFormatException e){
								System.err.println("Number Format Exception");
							}
							line = StringUtils.join(split," ");
						}
					}
					outLines.add(line);
				}
			}
			FileUtils.writeLines(localFile, outLines);
		//	fileInputStream.close();
			
		}

		public static void main(String[] args) {
			try {
				//	FileInputStream fileInputStream = new FileInputStream("C:/Users/xprk791/Desktop/Dileep.txt");
				 	FileReader fileReader = new FileReader("C:/Users/xprk791/Desktop/Dileep.txt"); 
//				 	manipulateFile(fileInputStream);
					manipulateFile(fileReader);
			} catch (IOException ex) {
				System.out.println("Oops! Something wrong happened");
				ex.printStackTrace();
			}finally{
			}
		}
	}
