package com.runwayml;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;

import processing.core.PGraphics;
import processing.core.PImage;
import processing.data.JSONArray;
import processing.data.JSONObject;

public class ModelUtils {
	
	public static int POSE_NET_NOSE_INDEX 			=  0;
	public static int POSE_NET_LEFT_EYE_INDEX  		=  1;
	public static int POSE_NET_RIGHT_EYE_INDEX 		=  2;
	public static int POSE_NET_LEFT_EAR_INDEX  		=  3;
	public static int POSE_NET_RIGHT_EAR_INDEX 		=  4;
	public static int POSE_NET_LEFT_SHOULDER_INDEX  =  5;
	public static int POSE_NET_RIGHT_SHOULDER_INDEX =  6;
	public static int POSE_NET_LEFT_ELBOW_INDEX  	=  7;
	public static int POSE_NET_RIGHT_ELBOW_INDEX 	=  8;
	public static int POSE_NET_LEFT_WRIST_INDEX  	=  9;
	public static int POSE_NET_RIGHT_WRIST_INDEX 	= 10;
	public static int POSE_NET_LEFT_HIP_INDEX  		= 11;
	public static int POSE_NET_RIGHT_HIP_INDEX 		= 12;
	public static int POSE_NET_LEFT_KNEE_INDEX  	= 13;
	public static int POSE_NET_RIGHT_KNEE_INDEX 	= 14;
	public static int POSE_NET_LEFT_ANKLE_INDEX  	= 15;
	public static int POSE_NET_RIGHT_ANKLE_INDEX 	= 16;
	
	/**
	 * Traverses Pose Net poses and keypoints and draws ellipses for each keypoint position
	 * @param data - the Runway PoseNet JSON object 
	 * @param g	   - the PGraphics instance to draw into
	 * @param ellipseSize - dimensions in pixels of each keypoint position ellipse diameter
	 */
	public static void drawPoseNetParts(JSONObject data,PGraphics g,float ellipseSize){
		try{
			// Only if there are any humans detected
			  if (data != null) {
			    JSONArray humans = data.getJSONArray("poses");
			    for(int h = 0; h < humans.size(); h++) {
			      JSONObject human = humans.getJSONObject(h);
			      JSONArray keypoints = human.getJSONArray("keypoints");
			      // Now that we have one human, let's draw its body parts
			      for (int k = 0; k < keypoints.size(); k++) {
			        JSONObject body_part = keypoints.getJSONObject(k);
			        JSONObject positions = body_part.getJSONObject("position");
			        // Body parts are relative to width and weight of the input
			        float x = positions.getFloat("x");
			        float y = positions.getFloat("y");
			        g.ellipse(x, y, ellipseSize, ellipseSize);
			      }
			    }
			  }
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static String toRunwayImageQuery(PImage image){
		JSONObject result = new JSONObject();
		result.setString("image", toBase64(image));
		return result.format(-1);
	}
	
	/**
	 * converts a PImage to a Base64 encoded String
	 * @param image - PImage to convert
	 * @return Base64 encoded string representation of the image
	 */
	public static String toBase64(PImage image){
		String result = null;
	    BufferedImage buffImage = (BufferedImage)image.getNative();
	    ByteArrayOutputStream out = new ByteArrayOutputStream();
	    try {
			ImageIO.write(buffImage, "PNG", out);
			byte[] bytes = out.toByteArray();
			result = Base64.encodeBase64String(bytes);
		} catch (IOException e) {
			e.printStackTrace();
		}
	    return result;
	}
	
	public static PImage fromBase64(String runwayImageString){
		PImage result = null;
		byte[] decodedBytes = Base64.decodeBase64(runwayImageString);
	 
		ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
		BufferedImage bImageFromConvert;
		try {
			bImageFromConvert = ImageIO.read(in);
			BufferedImage convertedImg = new BufferedImage(bImageFromConvert.getWidth(),     bImageFromConvert.getHeight(), BufferedImage.TYPE_INT_ARGB);
			convertedImg.getGraphics().drawImage(bImageFromConvert, 0, 0, null);
			result = new PImage(convertedImg);
		} catch (IOException e) {
			e.printStackTrace();
		}	 
		return result;
	}
	
	
	
	
}
