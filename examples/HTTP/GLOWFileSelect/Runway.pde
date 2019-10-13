// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;
// image from Runway
PImage runwayResult;

// store just the features
String[] features;

void setupRunway(){
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
}

void sendImageToRunway(PImage image){
  // prepare the expected input object
  JSONObject input = new JSONObject();
  // set image (base64 encoded)
  input.setString("image",ModelUtils.toBase64(image));
  // set feature
  input.setString("feature",currentFeature);
  // set amount
  input.setFloat("amount",amount);
  // send input to runway
  runway.query(input.toString());
}

void updateFeature(){
  currentFeature = features[currentFeatureIndex];
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("output");
  // try to decode the image from
  try{
    PImage result = ModelUtils.fromBase64(base64ImageString);
    if(result != null){
      runwayResult = result;
      status = "";
    }
  }catch(Exception e){
    e.printStackTrace();
  }
}

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  // cache the labelToColor data parsed from JSON data to Processing color data
  try{
    // access inputs array
    JSONArray inputs = info.getJSONArray("inputs");
    // loop through array to find features
    for(int i = 0 ; i < inputs.size(); i++){
      // access each input inside the array
      JSONObject input = inputs.getJSONObject(i);
      // check if the input name is feature
      if(input.getString("name").equals("feature")){
        // retrieve the oneOf array which is the array of features:
        features = input.getJSONArray("oneOf").getStringArray();
      }
    }
    // update color to the first label
    updateFeature();
  }catch(Exception e){
    println("error parsing SPADE-COCO model info, unexpected JSON data received:\n" + info.format(-1));
    e.printStackTrace();
  }
}

// if anything goes wrong
public void runwayErrorEvent(String message){
  println(message);
}
