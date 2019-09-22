package com.runwayml;

import java.lang.reflect.Method;
import java.util.regex.Pattern;

import processing.core.PApplet;
import processing.core.PImage;
import processing.data.JSONObject;

/**
 * Base Runway class to be subclassed based on the transport method (e.g. OSC,HTTP,Socket.IO)
 * 
 */

public class Runway {
	
	// parent is a reference to the parent sketch
	PApplet parent;

	public final static String VERSION = "##library.prettyVersion##";
	
	public static String OSC	   = "OSC";
	public static String HTTP 	   = "HTTP";
	public static String SOCKET_IO = "Socket.io";
	
	public static String DEFAULT_HOST = "127.0.0.1";
	
	protected String host = DEFAULT_HOST;
	protected int 	 port;
	
	protected Method onInfoEventMethod;
	protected Method onDataEventMethod;
	protected Method onErrorEventMethod;
	
	//reference: https://stackoverflow.com/Questions/5667371/validate-ipv4-address-in-java
	protected static final Pattern IPV4_PATTERN = Pattern.compile(
	        "^(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d\\d?|2[0-4]\\d|25[0-5])$");
	
	protected void setupPApplet(PApplet parent){
		this.parent = parent;
		this.onInfoEventMethod = findCallback("runwayInfoEvent",JSONObject.class);
		this.onDataEventMethod = findCallback("runwayDataEvent",JSONObject.class);
		this.onErrorEventMethod= findCallback("runwayErrorEvent",String.class);
	}
	
	/**
	 * send a query to Runway
	 * 
	 * @param input - input image for Runway to query (assumes image is resized/cropped to dimensions set in model)
	 */
	public void query(PImage input){
		
	}
	
	/**
	 * if <pre>runwayInfoEvent</pre> is present it calls it passing the info <pre>JSONObject</pre>
	 * @param info
	 */
	protected void dispatchInfo(JSONObject info){
		// if the callback isn't null
		if (onInfoEventMethod != null) {
			// try to call it
			try {
				// JSON parse first string argument and pass as callback argument 
				onInfoEventMethod.invoke(parent, info);
			}catch (Exception e) {
				System.err.println("Error, disabling runwayInfoEvent()");
				System.err.println(e.getLocalizedMessage());
				onInfoEventMethod = null;
			}
		}
	}
	
	/**
	 * if <pre>runwayErrorEvent</pre> is present it calls it passing the error String
	 * @param info
	 */
	protected void dispatchError(String message){
		// if the callback isn't null
		if (onErrorEventMethod != null) {
			// try to call it
			try {
				// pass OSC first argument as callback argument 
				onErrorEventMethod.invoke(parent, message);
			}catch (Exception e) {
				System.err.println("Error, disabling runwayErrorEvent()");
				System.err.println(e.getLocalizedMessage());
				onErrorEventMethod = null;
			}
		}
	}
	
	protected void dispatchData(JSONObject data){
		// if the callback isn't null
		if (onDataEventMethod != null) {
			// try to call it
			try {
				// JSON parse first string argument and pass as callback argument 
				onDataEventMethod.invoke(parent, data);
			}catch (Exception e) {
				System.err.println("Error, disabling runwayDataEvent()");
				System.err.println(e.getLocalizedMessage());
				onDataEventMethod = null;
			}
		}
	}
	
	public void welcome() {
		System.out.println("##library.name## ##library.prettyVersion## by ##author##");
	}
	
	/**
	 * return the version of the Library.
	 * 
	 * @return String
	 */
	public static String version() {
		return VERSION;
	}
	
	public void drawPoseNetParts(JSONObject data,float ellipseSize){
		ModelUtils.drawPoseParts(data, parent.g, ellipseSize);
	}
	
	// "kindly borrowed" from https://github.com/processing/processing/blob/master/java/libraries/serial/src/processing/serial/Serial.java
	private Method findCallback(final String name,Class argumentType) {
		try {
	      return parent.getClass().getMethod(name, argumentType);
	    } catch (Exception e) {
	    	System.out.println("couldn't find " + name + " callback in sketch, ignoring data");
	    	//e.printStackTrace();
	    }
	    return null;
	 }

	
}

