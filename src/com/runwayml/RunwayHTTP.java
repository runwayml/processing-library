package com.runwayml;

import netP5.NetAddress;
import oscP5.OscP5;
import oscP5.OscProperties;
import processing.core.PApplet;
import processing.data.JSONObject;

public class RunwayHTTP extends Runway {
	
	public static final int PORT	= 8000;
	
	public static final String QUERY	  = "/query";
	public static final String DATA 	  = "/data";
	public static final String ERROR 	  = "/error";
	public static final String INFO 	  = "/info";
	
	private String serverAddress;
	
	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @param parent   - the parent PApplet (usually <pre>this</pre>)
	 */
	public RunwayHTTP(PApplet parent) {
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
	public RunwayHTTP(PApplet parent,String host) {
		if(IPV4_PATTERN.matcher(host).matches()){
			this.host = host;
		}else{
			System.out.println("invalid IPv4 address: " + host + " -> defaulting to " + host);
		}
		this.setupPApplet(parent);
		this.setup();
	}
	
	protected void setup(){
		// concatenate server address (-route)
		serverAddress = "http://" + host + ":" + PORT;
		// load info 
		try {
			JSONObject info = parent.loadJSONObject(serverAddress + INFO);
			dispatchInfo(info);
		} catch (Exception e) {
			System.err.println("error parsing JSON from /info HTTP route");
			e.printStackTrace();
		}
		// register pre which is called once every frame before draw() kicks in
		parent.registerMethod("pre", this);
	}	
	
	// TODO disable events on first error
	public void pre(){
		// load error
		try {
			JSONObject error = parent.loadJSONObject(serverAddress + ERROR);
			// if there is error data
			//TODO find a more elegant way of checking for errors
			if(!error.get("error").toString().equals("null")){
//				// send data
				//dispatchError(error.getString("error"));
//				// TODO: detemine if error object is String / JSONObject / etc.
				dispatchError("error");
				// no need to load data if there is an error
				return;
			}
		} catch (Exception e) {
			System.err.println("error accessing string from /error HTTP route");
			e.printStackTrace();
		}
		
		// load data
		try {
			JSONObject data = parent.loadJSONObject(serverAddress + DATA);
			dispatchData(data);
		}catch (Exception e) {
			System.err.println("error parsing JSON from /data HTTP route");
			e.printStackTrace();
		}
	}
}
