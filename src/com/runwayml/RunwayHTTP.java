package com.runwayml;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import processing.core.PApplet;
import processing.core.PImage;
import processing.data.JSONObject;

public class RunwayHTTP extends Runway {
	
	// how many seconds to wait for a response from Runway before timeout
	public static int HTTP_TIMEOUT_SECONDS = 90;
	// Runway HTTP port
	public static final int PORT		  = 8000;
	// Runway routes
	public static final String QUERY	  = "/query";
	public static final String DATA 	  = "/data";
	public static final String ERROR 	  = "/error";
	public static final String INFO 	  = "/info";
	// server address
	private String serverAddress;
	// update each frame or not ?
	private boolean autoUpdate = true;
	// cached client and mediaType, 
	private OkHttpClient client;
	private MediaType mediaType = MediaType.parse("application/json");
	
	/**
	 * Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @param parent   - the parent PApplet (usually <pre>this</pre>)
	 */
	public RunwayHTTP(PApplet parent) {
		this.port = PORT;
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
	public RunwayHTTP(PApplet parent, String host) {
		if(IPV4_PATTERN.matcher(host).matches()){
			this.host = host;
		}else{
			System.out.println("invalid IPv4 address: " + host + " -> defaulting to " + host);
		}
		this.setupPApplet(parent);
		this.setup();
	}
	
	public RunwayHTTP(PApplet parent, String host, int port){
		if(IPV4_PATTERN.matcher(host).matches()){
			this.host = host;
		}else{
			System.out.println("invalid IPv4 address: " + host + " -> defaulting to " + host);
		}
		if(port >= 8000 && port < 65535){
			this.port = port;
		}else{
			this.port = PORT;
			System.out.println("invalid port: " + port + " -> (8000-65535 range) defaulting to " + PORT);
		}
		this.setupPApplet(parent);
		this.setup();
	}
	
	protected void setup(){
		// concatenate server address (-route)
		serverAddress = "http://" + host + ":" + port;
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
		// setup client
		client = new OkHttpClient.Builder()
		        .connectTimeout(HTTP_TIMEOUT_SECONDS, TimeUnit.SECONDS)
		        .writeTimeout(HTTP_TIMEOUT_SECONDS, TimeUnit.SECONDS)
		        .readTimeout(HTTP_TIMEOUT_SECONDS, TimeUnit.SECONDS)
		        .build();
	}	
	
	/**
	 * <strong>Don't call method directly</strong> The sketch calls this before each frame if <pre>isAutoUpdating()</pre>
	 */
	public void pre(){
		update();
	}
	
	/**
	 * call <pre>/error</pre> and <pre>/data</pre> endpoints to retrieve new information from Runway
	 * 
	 * calling <pre>setAutoUpdate(true)</pre> (true by default) automatically calls update() before each frame
	 */
	public void update(){
		// load error
		try {
			JSONObject error = parent.loadJSONObject(serverAddress + ERROR);
			// if there is error data
			if(!error.isNull("error")){
				// send data
//				dispatchError(error.getString("error"));
//						// TODO: determine if error object is String / JSONObject / etc.
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
	 * Call Runway before each frame or not ?
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
	 * send an image query to Runway (defaults to jpg encoding format and "image" JSON object key)
	 * 
	 * @param input - input image for Runway to query (assumes image is resized/cropped to dimensions set in model)
	 */
	@Override
	public void query(PImage input){
		query(input, ModelUtils.IMAGE_FORMAT_JPG, "image");
	}
	
	/**
	 * send an image query to Runway
	 * 
	 * @param input - input image for Runway to query (assumes image is resized/cropped to dimensions set in model)
	 * @param format - the image format: <pre>ModelUtils.IMAGE_FORMAT_JPG</pre>("JPG") or <pre>ModelUtils.IMAGE_FORMAT_PNG</pre>("PNG")
	 * @param key - the JSON key for the Base64 image
	 */
	@Override
	public void query(PImage input,String format,String key){
		sendQuery(ModelUtils.toRunwayImageQuery(input, format, key));
	}
	
	/**
	 *	send a JSON string query to Runway
	 */
	@Override 
	public void query(String input){
		sendQuery(input);
	}
	
	// do POST request to /QUERY
	private void sendQuery(String jsonPayload){
	    RequestBody body = RequestBody.create(mediaType,jsonPayload);
	    
	    Request request = new Request.Builder()
	    .url(serverAddress + QUERY)
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
