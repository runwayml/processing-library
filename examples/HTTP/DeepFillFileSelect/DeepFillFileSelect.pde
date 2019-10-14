// Copyright (C) 2019 RunwayML Examples
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

// DeepFill
// Receive HTTP messages from Runway
// Running DeepFill model
// example by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage runwayResult;

// status
String status = "";

// mask reference
PImage mask;
// input Image
PImage inputImage;

void setup(){
  // match sketch size to default model camera setup
  size(1800,400);
  // setup Runway
  runway = new RunwayHTTP(this);
  // update manually
  runway.setAutoUpdate(false);
}

void draw(){
  background(0);
  // draw input if ready
  if(inputImage != null){
    image(inputImage,0,0);
  }
  // draw mask image if ready
  if(mask != null){
    image(mask,600,0);
  }
  // draw image received from Runway
  if(runwayResult != null){
    image(runwayResult,1200,0);
  }
  
  
  // display status
  text("press 's' to select an input image\npress SPACE to query Runway\n"+status,5,15);
}
void keyPressed(){
  if(key == 's'){
    selectInput("Select an input image to process:", "inputImageSelected");
  }
  if(key == ' '){
    if(inputImage != null){
      status = "loading";
      queryRunway();
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
  // nothing to do with no input, exit function
  if(inputImage == null){
    return;
  }
  // make an artifical mask
  mask = fillRect(inputImage,90,60,39,69,color(255));
  // prepare Runway JSON payload
  JSONObject input = new JSONObject();
  // set image
  input.setString("image",ModelUtils.toBase64(inputImage));
  // set mask
  input.setString("mask",ModelUtils.toBase64(mask));
  // query Runway
  runway.query(input.toString());
}

PImage fillRect(PImage input,int x,int y,int w,int h,color fill){
  // copy input
  PImage output = input.get();
  // loop through pixels and fill them
  for(int py = y; py < y + h; py++){
    for(int px = x; px < x + w; px++){
      output.pixels[px + py * output.width] = fill;
      //output.set(px,py,fill);
    }
  }
  // update image
  output.updatePixels();
  // return output
  return output;
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("inpainted");
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
