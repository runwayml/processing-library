// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;
// image from Runway
PImage runwayResult;

// For this example we only care about label to RGB values associations
HashMap<String,Integer> labelToColor = new HashMap<String,Integer>();
// store just the SPADE-COCO labels
String[] labels;

void setupRunway(){
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
}

void sendImageToRunway(){
  runway.query(drawing.get(),ModelUtils.IMAGE_FORMAT_PNG,"semantic_map");
}

void updateLabelColor(){
  currentLabelColor = labelToColor.get(labels[currentLabelIndex]);
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
    // access labelToColor object inside the first element of the "inputs" value
    JSONObject firstInput = info.getJSONArray("inputs").getJSONObject(0);
     //access labelToColor object within the first input
    JSONObject labelToColorJSON = firstInput.getJSONObject("labelToColor");
    // access labelToColor object within the first input
    JSONObject labelToId = firstInput.getJSONObject("labelToId");
    // allocate labels array
    labels = new String[labelToId.size()];
    println(labels.length);
    // iterate through each key in the JSON object
    for(Object labelObj : labelToColorJSON.keys()){
      // cast the key from Object to String
      String label = (String)labelObj;
      // parse integer values from the JSON Array values
      int[] rgbValues = labelToColorJSON.getJSONArray(label).getIntArray();
      // populate the labelToColour lookup table / hashmap 
      labelToColor.put(label,color(rgbValues[0],rgbValues[1],rgbValues[2]));
      // populate the labels array
      int id = labelToId.getInt(label);
      labels[id] = label;
    }
    // update color to the first label
    updateLabelColor();
  }catch(Exception e){
    println("error parsing SPADE-COCO model info, unexpected JSON data received:\n" + info.format(-1));
    e.printStackTrace();
  }
}

// if anything goes wrong
public void runwayErrorEvent(String message){
  println(message);
}
