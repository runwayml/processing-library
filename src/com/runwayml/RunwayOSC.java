package com.runwayml;

import java.util.regex.Pattern;

import netP5.*;
import oscP5.*;
import processing.core.PApplet;
import processing.core.PImage;
import processing.data.JSONObject;

public class RunwayOSC extends Runway {
	
	public static final int PORT_OSC_TO_RUNWAY 	 = 57100;
	public static final int PORT_OSC_FROM_RUNWAY = 57200;
	
	public static final String CONNECT 	  = "/server/connect";
	public static final String DISCONNECT = "/server/disconnect";
	
	public static final String QUERY	  = "/query";
	public static final String DATA 	  = "/data";
	public static final String ERROR 	  = "/error";
	public static final String INFO 	  = "/info";
	
	//reference: https://stackoverflow.com/Questions/5667371/validate-ipv4-address-in-java
	private static final Pattern IPV4_PATTERN = Pattern.compile(
	        "^(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d\\d?|2[0-4]\\d|25[0-5])$");
	
	private OscP5 oscP5;
	NetAddress runwayNetAddress;
	
	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @param parent   - the parent PApplet (usually <pre>this</pre>)
	 */
	public RunwayOSC(PApplet parent) {
		this.setupPApplet(parent);
		this.setup();
	}
	
	/**
	 * Constructor variant that takes in an IPv4 Address 
	 * for situations where Runway runs on a different computer on the same network
	 * 
	 * @param parent   - the parent PApplet (usually <pre>this</pre>)
	 * @param host	   - the IPv4 Address where Runway is running
	 */
	public RunwayOSC(PApplet parent,String host) {
		if(IPV4_PATTERN.matcher(host).matches()){
			this.host = host;
		}else{
			System.out.println("invalid IPv4 address: " + host + " -> defaulting to " + host);
		}
		this.setupPApplet(parent);
		this.setup();
	}
	
	protected void setup(){
		OscProperties properties = new OscProperties();
		properties.setRemoteAddress(host, PORT_OSC_FROM_RUNWAY);
		properties.setListeningPort(PORT_OSC_FROM_RUNWAY);
		properties.setDatagramSize(99999999);
		properties.setSRSP(OscProperties.ON);
		this.oscP5 = new OscP5(this, properties);
		
		runwayNetAddress = new NetAddress(host, PORT_OSC_TO_RUNWAY);
		
		connect();
	}
	
	/**
	 * send a /server/connect message to Runway
	 */
	public void connect(){
		oscP5.send(new OscMessage(CONNECT), runwayNetAddress);
	}
	
	/**
	 * send a /server/disconnect message to Runway
	 */
	public void disconnect(){
		oscP5.send(new OscMessage(DISCONNECT), runwayNetAddress);
	}
	
	/**
	 * send a /query with a PImage sencoded as Base64 string within a JSON string (<pre>{"image": <base 64 image>}</pre>)
	 * @param image - the PImage to query the Runway model with (<strong>Must</strong> be of the dimensions the model expects)
	 */
	public void queryImage(PImage image){
		oscP5.send(new OscMessage(QUERY)
					   .add(ModelUtils.toRunwayImageQuery(image)), 
				runwayNetAddress);
	}
	
	public void oscEvent(OscMessage message) {
		// check info address and type tag
		if(message.checkAddrPattern(INFO) && message.checkTypetag("s")){
			// if the callback isn't null
			if (onInfoEventMethod != null) {
				// try to call it
				try {
					// JSON parse first string argument and pass as callback argument 
					onInfoEventMethod.invoke(parent, JSONObject.parse(	message.get(0).stringValue()	));
				}catch (Exception e) {
					System.err.println("Error, disabling runwayInfoEvent()");
					System.err.println(e.getLocalizedMessage());
					onInfoEventMethod = null;
				}
			}
		}
		
		// check error address and type tag
		if(message.checkAddrPattern(ERROR) && message.checkTypetag("s")){
			// if the callback isn't null
			if (onErrorEventMethod != null) {
				// try to call it
				try {
					// pass OSC first argument as callback argument 
					onErrorEventMethod.invoke(parent, message.get(0).stringValue());
				}catch (Exception e) {
					System.err.println("Error, disabling runwayErrorEvent()");
					System.err.println(e.getLocalizedMessage());
					onErrorEventMethod = null;
				}
			}
		}
		// check data address and type tag
		if(message.checkAddrPattern(DATA) && message.checkTypetag("s")){
			// if the callback isn't null
			if (onDataEventMethod != null) {
				// try to call it
				try {
					// JSON parse first string argument and pass as callback argument 
					onDataEventMethod.invoke(parent, JSONObject.parse(	message.get(0).stringValue()	));
				}catch (Exception e) {
					System.err.println("Error, disabling runwayDataEvent()");
					System.err.println(e.getLocalizedMessage());
					onDataEventMethod = null;
				}
			}
		}
		
	}
	
}
