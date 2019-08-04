package com.runwayml;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.*;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;

import processing.core.*;
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
		ModelUtils.drawPoseNetParts(data, parent.g, ellipseSize);
	}
	
	// "kindly borrowed" from https://github.com/processing/processing/blob/master/java/libraries/serial/src/processing/serial/Serial.java
	private Method findCallback(final String name,Class argumentType) {
		try {
	      return parent.getClass().getMethod(name, argumentType);
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    return null;
	 }

	
}

