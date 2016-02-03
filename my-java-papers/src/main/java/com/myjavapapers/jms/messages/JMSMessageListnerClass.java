package com.myjavapapers.jms.messages;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

public class JMSMessageListnerClass implements MessageListener {

	public void onMessage(Message message) {
		System.out.println("Message Listened sucessfully");
		
		try {
			TextMessage textMessage = (TextMessage)message;
			String stringProperty = textMessage.getStringProperty("tcs_car_kind");
			System.out.println("String Property : "+stringProperty);
			String text = textMessage.getText();
			System.out.println("text : "+text);
			
		} catch (JMSException e) {
			e.printStackTrace();
		}
		
	}
}
