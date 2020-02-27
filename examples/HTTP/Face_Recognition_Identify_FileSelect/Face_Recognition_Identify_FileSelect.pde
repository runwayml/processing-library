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

// Face Recognition Detect Demo:
// Receive HTTP messages from Runway
// Running Face-Recognition model

// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// The data coming in from Runway as a JSON Object {}
JSONObject data;

PImage inputImage;
PImage labelImage;

String status = "";

void setup() {
  size(1200, 400);
  frameRate(3);
  fill(255);
  stroke(255);
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
}

void draw() {
  background(0);
  
  // Display label image if loaded
  if(inputImage != null){
    image(inputImage,0,0);
  }
  
  // Display label image if loaded
  if(labelImage != null){
    image(labelImage,600,0);
  }
  
  // Display instructions
  text("press 'i' to select an input image\npress 'l' to select a label image\npress SPACE to query Runway\n"+status,5,15);
  
  // Display captions
  drawCaptions();
}

void keyPressed(){
  if(key == 'i'){
    selectInput("Select an input image to process:", "inputImageSelected");
  }
  if(key == 'l'){
    selectInput("Select a label image to process:", "labelImageSelected");
  }
  if(key == ' '){
    status = "loading";
    queryRunway();
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

void labelImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    labelImage = loadImage(selection.getAbsolutePath());
  }
}

void queryRunway(){
  // if there's no input image, don't send anything
  if(inputImage == null){
    return;
  }
  // if there's no label image, don't send anything
  if(labelImage == null){
    return;
  }
  // prepare input JSON object
  JSONObject input = new JSONObject();
  input.setString("input_image",ModelUtils.toBase64(inputImage));
  input.setString("label_image",ModelUtils.toBase64(labelImage));
  // request 75% match
  input.setFloat("match_tolerance",0.95);
  // query Runway with webcam image and input image
  runway.query(input.toString());
}

// A function to display the captions
void drawCaptions() {
  // if no data is loaded yet, exit
  if(data == null){
    return;
  }
  status = "";
  // access boxes and labels JSON arrays within the result
  JSONArray results = data.getJSONArray("results");
  // for each array element
  for(int i = 0 ; i < results.size(); i++){
    JSONObject result = results.getJSONObject(i);
    
    String className = result.getString("class");
    JSONArray box = result.getJSONArray("bbox");
    // extract values from the float array
    float x = box.getFloat(0);
    float y = box.getFloat(1);
    float w = box.getFloat(2);
    float h = box.getFloat(3);
    // display bounding boxes
    noFill();
    rect(x,y,w,h);
    fill(255);
    text(className,x,y);
  }
}



// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data
  data = runwayData;
}
