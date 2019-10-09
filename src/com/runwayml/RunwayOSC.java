package com.runwayml;

import netP5.NetAddress;
import oscP5.OscMessage;
import oscP5.OscP5;
import oscP5.OscProperties;
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
	 * @param input - the PImage to query the Runway model with (<strong>Must</strong> be of the dimensions the model expects)
	 */
	@Override
	public void query(PImage input) {
		oscP5.send(new OscMessage(QUERY)
				.add(ModelUtils.toRunwayImageQuery(input)), 
				runwayNetAddress);
	}
	
	/**
	 * Send a /query OSC message to Runway with the passed image Base64 encoded with the selected format and as the value of the selected JSON key
	 * @param input - PImage to encode and send
	 * @param format - ModelUtils.IMAGE_FORMAT_JPG or ModelUtils.IMAGE_FORMAT_PNG
	 * @param key - the key of the JSON object for the image value
	 */
	public void query(PImage input,String format,String key){
		oscP5.send(new OscMessage(QUERY)
				.add(ModelUtils.toRunwayImageQuery(input,format,key)), 
				runwayNetAddress);
	}
	
	/**
	 * @param input - JSON formatted string for the selected model
	 */
	@Override
	public void query(String input){
		oscP5.send(new OscMessage(QUERY).add(input), runwayNetAddress);
	}
	
	/**
	 * called internally by OscP5 library
	 * 
	 * @param message
	 */
	public void oscEvent(OscMessage message) {
		// check info address and type tag
		if(message.checkAddrPattern(INFO) && message.checkTypetag("s")){
			try {
				dispatchInfo(JSONObject.parse(	message.get(0).stringValue()	));
			} catch (Exception e) {
				System.err.println("error parsing JSON from /info OSC message");
				e.printStackTrace();
			}
		}
		
		// check error address and type tag
		if(message.checkAddrPattern(ERROR) && message.checkTypetag("s")){
			try{
				dispatchError(message.get(0).stringValue());
			} catch (Exception e) {
				System.err.println("error accessing string from /error OSC message");
				e.printStackTrace();
			}
			
		}
		// check data address and type tag
		if(message.checkAddrPattern(DATA) && message.checkTypetag("s")){
			try {
				dispatchData(JSONObject.parse(	message.get(0).stringValue()	));
			}catch (Exception e) {
				System.err.println("error parsing JSON from /data OSC message");
				e.printStackTrace();
			}
		}
		
	}
	
}
