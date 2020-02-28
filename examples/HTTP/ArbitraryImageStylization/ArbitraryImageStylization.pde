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

// Arbitrary-Image-Stylization
// Receive HTTP messages from Runway
// Running AdaIN-Style-Transfer model
// example by George Profenza

// import video library
import processing.video.*;

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage runwayResult; 

// periocally to be updated using millis()
int lastMillis;
// how often should the above be updated and a time action take place ?
int waitTime = 1000;

// reference to the camera
Capture camera;

// status
String status = "waiting ~"+(waitTime/1000)+"s";

PImage styleImage;

float interpolationWeight = 1.0;

void setup(){
  // match sketch size to default model camera setup
  size(1800,400);
  // setup Runway
  runway = new RunwayHTTP(this);
  // update manually
  runway.setAutoUpdate(false);
  // setup camera
  camera = new Capture(this,640,480);
  camera.start();
  // setup timer
  lastMillis = millis();
}

void draw(){
  background(0);
  // update timer
  int currentMillis = millis();
  // if the difference between current millis and last time we checked past the wait time
  if(currentMillis - lastMillis >= waitTime){
    status = "sending image to Runway";
    // call the timed function
    sendFrameToRunway();
    // update lastMillis, preparing for another wait
    lastMillis = currentMillis;
  }
  // draw style image (if loaded)
  if(styleImage != null){
    image(styleImage,600,0);
  }
  // draw image received from Runway
  if(runwayResult != null){
    image(runwayResult,1200,0);
  }
  // draw camera feed
  image(camera,0,0,600,400);
  // display status
  text("Press SPACE to select a style image\ndrag mouse horizontally to change interpolation weight:"+String.format("%.2f",interpolationWeight)+"\n"+status,5,15);
}

void mouseDragged(){
  interpolationWeight = map(constrain(mouseX,0,width),0,width,0.0,1.0);
}

void keyPressed(){
  if(key == ' '){
    selectInput("Select a file to process:", "fileSelected");
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    styleImage = loadImage(selection.getAbsolutePath());
    // resize image (adjust as needed)
    styleImage.resize(600,400);
  }
}

void sendFrameToRunway(){
  // skip if style image isn't loaded yet
  if(styleImage == null){
    return;
  }
  // nothing to send if there's no new camera data available
  if(camera.available() == false){
    return;
  }
  // read a new frame
  camera.read();
  // crop image to Runway input format (600x400)
  PImage image = camera.get(0,0,600,400);
  // prepare input JSON data to send to Runway
  JSONObject input = new JSONObject();
  // set style image
  input.setString("style_image",ModelUtils.toBase64(styleImage));
  // set content image
  input.setString("content_image",ModelUtils.toBase64(image));
  // set interpolation weight
  input.setFloat("interpolation_weight",interpolationWeight);
  // query Runway
  runway.query(input.format(-1));
}


// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("image");
  // try to decode the image from
  try{
    runwayResult = ModelUtils.fromBase64(base64ImageString);
  }catch(Exception e){
    e.printStackTrace();
  }
  status = "received runway result";
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
