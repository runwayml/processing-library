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

// MaskRCNN
// Receive OSC messages from Runway
// Running MaskRCNN model
// example by George Profenza

// import video library
import processing.video.*;

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage runwayResult; 

// status
String status = "";

String category = "person";

// Input Image
PImage inputImage;

void setup(){
  // match sketch size to default model camera setup
  size(1200,400);
  // setup Runway
  runway = new RunwayHTTP(this);
  // update manually
  runway.setAutoUpdate(false);
}

void draw(){
  background(0);
  // Display image (if loaded)
  if(inputImage != null){
    image(inputImage,0,0);
  }
  
  // Display instructions
  text("press 's' to select an input image\npress SPACE to query Runway\n"+status,5,15);
  // draw image received from Runway
  if(runwayResult != null){
    image(runwayResult,600,0);
  }
}

void keyPressed(){
  if(key == 's'){
    selectInput("Select an input image to process:", "inputImageSelected");
  }
  if(key == ' '){
    if(inputImage != null){
      runway.query(inputImage);
    }
  }
}

void inputImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    inputImage = loadImage(selection.getAbsolutePath());
  }
}

void queryRunway(){
  // nothing to do if there's no input image
  if(inputImage == null){
    return;
  }
  // create input JSON object to hold image and category data
  JSONObject input = new JSONObject();
  // set image
  input.setString("image",ModelUtils.toBase64(inputImage));
  // set category
  input.setString("category",category);
  // query Runway
  runway.query(input.toString());
}


// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("output");
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
