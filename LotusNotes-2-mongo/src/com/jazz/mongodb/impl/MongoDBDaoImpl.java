package com.jazz.mongodb.impl;

import java.io.File;
import java.io.IOException;
import java.net.UnknownHostException;

import com.mongodb.DB;
import com.mongodb.MongoException;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;

public class MongoDBDaoImpl {
	
	 public static void saveEmbeddedObject(DB cimAppsMongoDB, String filepath, String fileName) {
	        try {
	            File docFile = new File(filepath);
	            // create a "cimappsSTR" namespace
	            GridFS gfscimapps = new GridFS(cimAppsMongoDB, "cimappsSTR1");
	            // remove the image file from mongoDB
	            // try query not on file name but on the id or use find for the _id
	            //gfscimapps.remove(gfscimapps.findOne(ObjName.toString())); //this removes all previous GridFS entries even though it shouldnt
	            // get doc file from local drive
	            GridFSInputFile gfsFile = gfscimapps.createFile(docFile);
	            // set a new filename for identify purpose
	            gfsFile.setFilename(fileName);
	            // save the image file into mongoDB
	            gfsFile.save();
	            // get image file by it's filename
	            GridFSDBFile imageForOutput = gfscimapps.findOne(fileName);
	            //imageForOutput.
	        } catch (UnknownHostException e) {
	            System.out.println("exception " + e);
	        } catch (MongoException | IOException e) {
	            System.out.println("exception " + e);
	        }
	    }

}
