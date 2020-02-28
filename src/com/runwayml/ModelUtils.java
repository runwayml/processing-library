package com.runwayml;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

import javax.imageio.ImageIO;
import javax.xml.bind.DatatypeConverter;

import java.awt.image.BufferedImage;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import processing.core.PGraphics;
import processing.core.PImage;
import processing.data.JSONArray;
import processing.data.JSONObject;

public class ModelUtils {
	
	public static int POSE_NOSE_INDEX 			=  0;
	public static int POSE_LEFT_EYE_INDEX  		=  1;
	public static int POSE_RIGHT_EYE_INDEX 		=  2;
	public static int POSE_LEFT_EAR_INDEX  		=  3;
	public static int POSE_RIGHT_EAR_INDEX 		=  4;
	public static int POSE_LEFT_SHOULDER_INDEX  =  5;
	public static int POSE_RIGHT_SHOULDER_INDEX =  6;
	public static int POSE_LEFT_ELBOW_INDEX  	=  7;
	public static int POSE_RIGHT_ELBOW_INDEX 	=  8;
	public static int POSE_LEFT_WRIST_INDEX  	=  9;
	public static int POSE_RIGHT_WRIST_INDEX 	= 10;
	public static int POSE_LEFT_HIP_INDEX  		= 11;
	public static int POSE_RIGHT_HIP_INDEX 		= 12;
	public static int POSE_LEFT_KNEE_INDEX  	= 13;
	public static int POSE_RIGHT_KNEE_INDEX 	= 14;
	public static int POSE_LEFT_ANKLE_INDEX  	= 15;
	public static int POSE_RIGHT_ANKLE_INDEX 	= 16;
	
	public static String IMAGE_FORMAT_JPG = "JPG";
	public static String IMAGE_FORMAT_PNG = "PNG";
	
	/**
	 * Traverses Pose Net poses and keypoints and draws ellipses for each keypoint position
	 * @param data - the Runway Pose JSON object 
	 * @param g	   - the PGraphics instance to draw into
	 * @param ellipseSize - dimensions in pixels of each keypoint position ellipse diameter
	 */
	public static void drawPoseParts(JSONObject data,PGraphics g,float ellipseSize){
		try{
			// Only if there are any humans detected
			if (data != null) {
				JSONArray humans = data.getJSONArray("poses");
			    for(int h = 0; h < humans.size(); h++) {
			      JSONArray keypoints = humans.getJSONArray(h);
			      // Now that we have one human, let's draw its body parts
			      for (int k = 0; k < keypoints.size(); k++) {
			        // Body parts are relative to width and weight of the input
			        JSONArray point = keypoints.getJSONArray(k);
			        float x = point.getFloat(0);
			        float y = point.getFloat(1);
			        g.ellipse(x * g.width, y * g.height, ellipseSize, ellipseSize);
			      }
			    }
			  }
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * convert a PImage to a JSONObject with the Base64 encoded image as the value of the "image" key 
	 * @param image - the PImage to convert to Base64
	 * @return JSON formatted String
	 */
	public static String toRunwayImageQuery(PImage image){
		return "{\"image\":\"" + toBase64(image) + "\"}";
	}
	
	/**
	 * convert a PImage to a JSONObject with the Base64 encoded image as the value of the "image" key 
	 * @param image - the PImage to convert to Base64
	 * @param format - the image format: <pre>ModelUtils.IMAGE_FORMAT_JPG</pre>("JPG") or <pre>ModelUtils.IMAGE_FORMAT_PNG</pre>("PNG")
	 * @return JSON formatted String
	 */
	public static String toRunwayImageQuery(PImage image,String format){
		return "{\"image\":\"" + toBase64(image,format) + "\"}";
	}
	
	/**
	 * convert a PImage to a JSONObject with the Base64 encoded image as the value of the "image" key 
	 * @param image - the PImage to convert to Base64
	 * @param format - the image format: <pre>ModelUtils.IMAGE_FORMAT_JPG</pre>("JPG") or <pre>ModelUtils.IMAGE_FORMAT_PNG</pre>("PNG")
	 * @param key - the JSON key for the Base64 image
	 * @return JSON formatted String
	 */
	public static String toRunwayImageQuery(PImage image,String format,String key){
		return "{\"" + key + "\":\"" + toBase64(image,format) + "\"}";
	}
	
	/**
	 * converts a PImage to a Base64 encoded String
	 * @param image - PImage to convert
	 * @return Base64 encoded string representation of the image (using JPG mime type by default, see <pre>toBase64(PImage image,String format)</pre>)
	 */
	public static String toBase64(PImage image){
		String result = null;
		
		BufferedImage jImage = (BufferedImage)image.getNative();
		ByteArrayOutputStream encodedBytesStream = new ByteArrayOutputStream();
		try {
			ImageIO.write(jImage, "JPG", encodedBytesStream);
			byte[] bytes = encodedBytesStream.toByteArray();
			result = "data:image/jpeg;base64," + DatatypeConverter.printBase64Binary(bytes);
		} catch (IOException e) {
			e.printStackTrace();
		}
			
	    return result;
	}
	
	/**
	 * converts a PImage to a Base64 encoded String
	 * @param image - PImage to convert
	 * @param format - the image format: <pre>ModelUtils.IMAGE_FORMAT_JPG</pre>("JPG") or <pre>ModelUtils.IMAGE_FORMAT_PNG</pre>("PNG")
	 * @return Base64 encoded string representation of the image
	 */
	public static String toBase64(PImage image,String format){
		if(!format.equals(ModelUtils.IMAGE_FORMAT_JPG) && !format.equals(ModelUtils.IMAGE_FORMAT_PNG)){
			System.err.println("Invalid format type: " + format + "\nexpected formats are ModelUtils.IMAGE_FORMAT_JPG or ModelUtils.IMAGE_FORMAT_PNG");
			return null;
		}
		
		String mimeType = "";
		
		if(format.equals(ModelUtils.IMAGE_FORMAT_JPG)){
			mimeType = "image/jpeg";
			image.filter(PImage.OPAQUE);
		}
		
		if(format.equals(ModelUtils.IMAGE_FORMAT_PNG)){
			mimeType = "image/png";
		}
		
		String result = null;
		
		BufferedImage jImage = (BufferedImage)image.getNative();
		ByteArrayOutputStream encodedBytesStream = new ByteArrayOutputStream();
		
		try {
			ImageIO.write(jImage, format, encodedBytesStream);
			byte[] bytes = encodedBytesStream.toByteArray();
			result = "data:" + mimeType + ";base64," + DatatypeConverter.printBase64Binary(bytes);
		} catch (IOException e) {
			e.printStackTrace();
		}
			
		
		return result;
	}
	
	/**
	 * converts a Base64 encoded String to a PImage
	 * 
	 * @param runwayImageString - the Base64 encoded image String from RunwayML
	 * @return - the PImage decoded from the string
	 */
	public static PImage fromBase64(String runwayImageString){
		
		PImage result = null;
		String base64Image = runwayImageString;
		// search for comma: indicator of MIME type
		int commaIndex = base64Image.indexOf(',');
		// if found, remove the type before converting
		if(commaIndex >= 0){
			base64Image = base64Image.substring(commaIndex + 1);
		}
	    
		try {
			byte[] decodedBytes = DatatypeConverter.parseBase64Binary(base64Image);
			
			if(decodedBytes == null){
				return null;
			}
			
			ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
			result = new PImage(ImageIO.read(in));
			
		} catch (IOException e) {
			e.printStackTrace();
		}
			
	    return result;
	}
	
}
