package com.runwayml;

import java.io.IOException;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import processing.core.PApplet;
import processing.core.PImage;
import processing.data.JSONObject;

public class RunwayHTTP extends Runway {
	
	public static final int PORT	= 8000;
	
	public static final String QUERY	  = "/query";
	public static final String DATA 	  = "/data";
	public static final String ERROR 	  = "/error";
	public static final String INFO 	  = "/info";
	
	private String serverAddress;
	
	private boolean autoUpdate = true;
	
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
		update();
	}
	
	public void update(){
		// load error
		try {
			JSONObject error = parent.loadJSONObject(serverAddress + ERROR);
			// if there is error data
			//TODO find a more elegant way of checking for errors
			if(!error.get("error").toString().equals("null")){
//						// send data
				//dispatchError(error.getString("error"));
//						// TODO: detemine if error object is String / JSONObject / etc.
				dispatchError("error");
				// no need to load data if there is an error
				return;
			}
		} catch (Exception e) {
			System.err.println("error accessing string from /error HTTP route");
			e.printStackTrace();
			this.onInfoEventMethod = null;
		}
		
		// load data
		try {
			JSONObject data = parent.loadJSONObject(serverAddress + DATA);
			dispatchData(data);
		}catch (Exception e) {
			System.err.println("error parsing JSON from /data HTTP route");
			e.printStackTrace();
			this.onDataEventMethod = null;
		}
	}

	/**
	 * @return the autoUpdate
	 */
	public boolean isAutoUpdating() {
		return autoUpdate;
	}

	/**
	 * @param autoUpdate the value to set
	 */
	public void setAutoUpdate(boolean autoUpdate) {
		this.autoUpdate = autoUpdate;
		if(autoUpdate){
			parent.registerMethod("pre", this);
		}else{
			parent.unregisterMethod("pre", this);
		}
	}
	
	/**
	 * send a query to Runway
	 * 
	 * @param input - input image for Runway to query (assumes image is resized/cropped to dimensions set in model)
	 */
	@Override
	public void query(PImage input){
		String base64 = ModelUtils.toBase64(input);
	    
	    OkHttpClient client = new OkHttpClient();
	    
	    MediaType mediaType = MediaType.parse("application/json");
	    RequestBody body = RequestBody.create(mediaType,"{\"image\":\""+base64+"\"}");
	    
	    Request request = new Request.Builder()
	    .url("http://localhost:8000/query")
	    .post(body)
	    .addHeader("Content-Type", "application/json")
	    .addHeader("Accept", "*/*")
	    .addHeader("Accept-Encoding", "gzip, deflate")
	    .addHeader("Connection", "keep-alive")
	    .build();
	    
	    try{
	      Response response = client.newCall(request).execute();
	      JSONObject data = JSONObject.parse(response.body().string());
	      dispatchData(data);
	    }catch(IOException e){
	      e.printStackTrace();
	    }catch (Exception e) {
	    	System.err.println("error parsing JSON from /data HTTP route");
	    	e.printStackTrace();
	    	this.onDataEventMethod = null;
	    }
	}
}
