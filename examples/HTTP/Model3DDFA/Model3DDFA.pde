// Copyright (C) 2020 Runway AI Examples
// 
// This file is part of Runway AI Examples.
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

// RUNWAY
// www.runwayapp.ai

// 3DDFA Demo:
// Receive HTTP messages from Runway
// Running 3DDFA model
// example by by George Profenza

// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// store image results from Runway
PImage runwayResult;

// reference to the camera
Capture camera;

void setup(){
  // match sketch size to default model camera setup
  size(1200,400);
  // change default black stroke
  stroke(9,130,250);
  strokeWeight(3);
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
  // setup camera
  camera = new Capture(this,640,480);
  camera.start();
}

void draw(){
  background(0);
  // draw webcam image
  image(camera,0,0,600,400);
  // display Runway result if available
  if(runwayResult != null){
    image(runwayResult,600,0,600,400);
  }
  // display instructions
  text("press '1' to request Pose\n"+
       "press '2' to request Depth\n"+
       "press '3' to request Points\n"+
       "press '4' to request Skin",5,15);
}

void keyPressed(){
  if(key == '1'){
    sendFrameToRunway("pose");
  }
  if(key == '2'){
    sendFrameToRunway("depth");
  }
  if(key == '3'){
    sendFrameToRunway("points");
  }
  if(key == '4'){
    sendFrameToRunway("skin");
  }
}

void sendFrameToRunway(String outputType){
  // nothing to send if there's no new camera data available
  if(camera.available() == false){
    return;
  }
  // read a new frame
  camera.read();
  // crop image to Runway input format (600x400)
  PImage image = camera.get(0,0,600,400);
  // query Runway with webcam image 
  JSONObject input = new JSONObject();
  input.setString("content_image",ModelUtils.toBase64(image,ModelUtils.IMAGE_FORMAT_JPG));
  input.setString("output_type",outputType);
  // send input to Runway
  runway.query(input.toString());
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("image");
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

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  println(info);
}
// if anything goes wrong
public void runwayErrorEvent(String message){
  println(message);
}
