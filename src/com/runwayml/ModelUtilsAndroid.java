package com.runwayml;

import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

import processing.core.PImage;

public class ModelUtilsAndroid extends ModelUtils {

	/**
	 * converts a PImage to a Base64 encoded String
	 * @param image - PImage to convert
	 * @return Base64 encoded string representation of the image (using JPG mime type by default, see <pre>toBase64(PImage image,String format)</pre>)
	 */
	public static String toBase64(PImage image){
		String result = null;
		
		try{
			result = "data:image/jpeg;base64," + toBase64Android(image, "JPG");
		}catch(Exception e){
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
			
		try{
			result = "data:" + mimeType + ";base64," + toBase64Android(image,format);
		}catch(Exception e){
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
			result = fromBase64Android(base64Image);
		} catch (Exception e) {
			e.printStackTrace();
		}
	    
	    return result;
	}
	
	
	/**
	 * converts a Base64 encoded String to a PImage on Android
	 * (it's a bit over-complicated and inefficient due to so much reflection, but does the job at allowing both Android and non-Android PImages to live side by side)
	 * 
	 * @param runwayImageString the base64 
	 * @return
	 */
	public static PImage fromBase64Android(String runwayImageString) {
		PImage result = null;
		
		try {
		    // use reflection to access the android Base64 and BitmapFactory classes
		    Class<?> Base64Class = Class.forName("android.util.Base64");
		    Class<?> BitmapFactoryClass = Class.forName("android.graphics.BitmapFactory");
		    
		    // access decode method and call it
		    Method decode = Base64Class.getDeclaredMethod("decode",String.class,int.class);
		    byte[] decodedString = (byte[])decode.invoke(null, runwayImageString,0);
		    
		    // access decodeByteArray method and call it 
		    Method decodeByteArray = BitmapFactoryClass.getDeclaredMethod("decodeByteArray",byte[].class,int.class,int.class);
		    Object decodedBitmap = decodeByteArray.invoke(null, decodedString, 0, decodedString.length);
		    
		    // final pass the decoded android.graphics.Bitmap to the Android version of PImage
		    //e.g. new PImage(decodedBytes)
		    Class<?> PImageClass = Class.forName("processing.core.PImage");
		    Constructor<?> PImageConstructor = PImageClass.getConstructor(Object.class);
		    // return result
		    return (PImage)PImageConstructor.newInstance(decodedBitmap);
		} catch (Exception e) {
			e.printStackTrace();
		}

	  return result;
	}
	
	/**
	 * converts an Android PImage to a Base64 encoded string
	 * 
	 * @param image - Android PImage
	 * @param format - "JPG" or "PNG"
	 * @return
	 */
	public static String toBase64Android(PImage image,String format){
		String result = null;
		try{
			// container for incoming image data
		    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		    // access android Bitmap and CompressFormat classes
		    Class<?> BitmapClass = Class.forName("android.graphics.Bitmap");
		    Class<?> CompressFormatClass = Class.forName("android.graphics.Bitmap$CompressFormat");
		    Method compress = BitmapClass.getDeclaredMethod("compress",CompressFormatClass, int.class, OutputStream.class);
		    Object[] compressFormats = CompressFormatClass.getEnumConstants(); 
		    // default to JPEG (0)
		    int formatIndex = 0;
		    // switch to PNG (1), ignore WEBP (2)
		    if(format.equals("PNG")){
		      formatIndex = 1;
		    }
		    // compress
		    compress.invoke(image.getNative(),compressFormats[formatIndex], 100, byteArrayOutputStream);
		    // get byte array
		    byte[] byteArray = byteArrayOutputStream.toByteArray();
		    // access Base64 class and it's encodeToString method
		    Class<?> Base64Class = Class.forName("android.util.Base64");
		    Method encodeToString = Base64Class.getDeclaredMethod("encodeToString",byte[].class,int.class);
		    // convert byte array to base64 string
		    return (String)encodeToString.invoke(null,byteArray, 0);
		  }catch(Exception e){
		    e.printStackTrace();
		  }
		  return result;
	}
}
