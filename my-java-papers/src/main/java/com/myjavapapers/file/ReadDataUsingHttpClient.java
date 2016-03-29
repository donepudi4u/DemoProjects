package com.myjavapapers.file;

import java.io.IOException;
import java.io.InputStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClients;

public class ReadDataUsingHttpClient {
	
	public static void main(String[] args) {
		
	}
	
	public void getFile(String url) throws ClientProtocolException, IOException{

        HttpGet httpget = new HttpGet(url);
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpResponse response = httpClient.execute(httpget);
        HttpEntity entity = response.getEntity();
        if (entity != null) {
            long len = entity.getContentLength();
            InputStream inputStream = entity.getContent();

        }

    }

}
