// Copyright (C) 2020 RunwayML Examples
// 
// This file is part of RunwayML Examples.
// 
// Runway-Examples is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Runway-Examples is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAYML
// www.runwayml.com

// BigGAN Demo:
// Receive HTTP messages from Runway
// Running BigGAN
// example by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// The data coming in from Runway as a JSON Object {}
JSONObject data;

// Storage for received Runway image data
PImage runwayResult;

// example input vector
String[] categories;
int categoryIndex;
String category = "tiger, Panthera tigris";
// latent vector z: change values to explore what the model captured
JSONArray z;
// sampling standard deviation
float zSamplingStd;
// input data to send to Runway ML
JSONObject input = new JSONObject();

void setup() {
  size(512, 512);
  frameRate(3);
  fill(255);
  
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
}

void draw() {
  background(0);
  
  // display result (if any)
  if(runwayResult != null){
    image(runwayResult,0,0);
  }
  
  // display instructions
  text("press SPACE to request an image\npress 's' to save it disk\ndrag mouse to tweak Z\npress LEFT/RIGHT to change category\n"+category,5,15);
}

void keyPressed(){
  if(keyCode == LEFT && categoryIndex > 0){
    categoryIndex--;
    category = categories[categoryIndex];
  }
  if(keyCode == RIGHT && categoryIndex < categories.length - 1){
    categoryIndex++;
    category = categories[categoryIndex];
  }
  if(key == ' '){
    queryRunwayML();
  }
  if(key == 's' && runwayResult != null){
    runwayResult.save(dataPath("result.png"));
  }
}
// following Gene Kogan's brilliant suggestion to map mouse coordinates to the z vector
void mouseDragged(){
  if(z != null){
    // map mouse X to first element in z vector
    z.setFloat(0,map(mouseX,0,width,-zSamplingStd,zSamplingStd));
    // map mouse Y to second element in z vector...what would other array elements do ? have a play !
    z.setFloat(1,map(mouseY,0,height,-zSamplingStd,zSamplingStd));
  }
}

void mouseReleased(){
  if(z != null){
    queryRunwayML();
    println(z.format(-1));
  }
}

// send query HTTP request to RunwayML
void queryRunwayML(){
  // query a set vector
  input.setJSONArray("z",z);
  input.setString("category",category);
  // send the String representation formatted with no indentation (-1)
  runway.query(input.format(-1));
}

// given an array of objects, look for one with the given property and value (e.g. find {..."name":"z"})
JSONObject getJSONObjectByStringProperty(JSONArray array,String property,String value){
  JSONObject object = null;
  try{
    for(int i = 0 ; i < array.size(); i++){
      object = array.getJSONObject(i);
      if(object != null && object.hasKey(property)){
        if(object.getString(property).equals(value)){
          return object;
        }
      }
    }
  }catch(Exception e){
    println("error traversing array",array.toString());
    e.printStackTrace();
  }
  return object;
}
// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  println(info.format(-1));
  JSONArray inputs = info.getJSONArray("inputs");
  // setup z
  z = new JSONArray();
  JSONObject zInput = getJSONObjectByStringProperty(inputs,"name","z");
  if(zInput != null){
    int zLength = zInput.getInt("length");
    zSamplingStd = zInput.getFloat("samplingStd");
    for(int i = 0 ; i < zLength; i++){
      z.setFloat(i,random(-zSamplingStd,zSamplingStd));
    }
  }
  // setup categories
  JSONObject categoriesInput = getJSONObjectByStringProperty(inputs,"name","category");
  if(categoriesInput != null){
    categories = categoriesInput.getJSONArray("oneOf").getStringArray();
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("generated_output");
  // try to decode the image from
  try{
    PImage result = ModelUtils.fromBase64(base64ImageString);
    if(result != null){
      runwayResult = result;
    }
  }catch(Exception e){
    e.printStackTrace();
  }
}
