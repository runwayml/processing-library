// Copyright (C) 2020 Runway ML Examples
// 
// This file is part of Runway ML Examples.
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

// AttnGAN Demo
// Send OSC text messages to Runway and generate images
// example based on https://github.com/runwayml/processing/blob/master/attnGAN/attnGAN.pde adapted by George Profenza
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// result image will be stored here
PImage runwayResult;

// IP of the computer running RunwayML: change this to your local network configuration
String RUNWAYML_HTTP_IP = "192.168.0.24";
// HTTP port: default is 8000, however this increments when running multiple models (e.g. in chained mode)
int RUNWAYML_HTTP_PORT = 8000;

int captionIndex = 0;
String[] captions = {"cup cake","donut","eclair","froyo","gingerbread","honeycomb","ice cream sandwich","jelly bean","KitKat","lollipop","marshmallow","nougat","oreo","pie"};
// The caption to send
JSONObject input = new JSONObject();

void setup() {
  size(1024, 1024);
  textSize(90);
  frameRate(25);
  // setup Runway
  runway = new RunwayHTTP(this,RUNWAYML_HTTP_IP,RUNWAYML_HTTP_PORT);
  // don't send messages to Runway continuously
  runway.setAutoUpdate(false);
  // update caption JSON to send to Runway
  updateCaption();
}

// iterate through the array of words and update the JSON input for Runway
void updateCaption(){
  input.setString("caption",captions[captionIndex]);
  // increment caption index
  captionIndex++;
  // reset back to 0 at the end of array
  if(captionIndex >= captions.length){
    captionIndex = 0;
  }
}

void draw() {
  background(0);
  
  if(runwayResult != null){
    image(runwayResult,0,0,width,height);
  }
  text("tap screen to to send text to Runway\n"+input,3,90);
}

void mouseReleased() {
  // visual feedback as request is sent
  fill(30);
  // send data
  runway.query(input.toString());
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // visual feedback as data arrives
  fill(255);
  String base64ImageString = runwayData.getString("result");
  // try to decode the image from
  try{
    PImage result = ModelUtilsAndroid.fromBase64(base64ImageString);
    if(result != null){
      runwayResult = result;
    }
  }catch(Exception e){
    e.printStackTrace();
  }
  // update text to send on next tap
  updateCaption();
}
