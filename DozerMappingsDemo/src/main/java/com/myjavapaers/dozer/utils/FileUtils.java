package com.myjavapaers.dozer.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class FileUtils {
	
	public static String getContents(final File aFile) {
		
		StringBuffer contents = new StringBuffer();
		BufferedReader input = null;
		try {
			input = new BufferedReader(new FileReader(aFile));
			String line = null;

			while ((line = input.readLine()) != null) {
				contents.append(line);
			}
		} catch (FileNotFoundException e) {
			System.out.println("Exception: " + e);
		} catch (IOException e) {
			System.out.println("Exception: " + e);
		} finally {
			try {
				if (input != null) {
					input.close();
				}
			} catch (IOException e) {
				System.out.println("Exception: " + e);
			}
		}
		return contents.toString();
	}

}
