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

// Few Shot Face Translation GAN
// Receive HTTP messages from Runway
// Running Few-Shot-Face-Translation-GAN model
// example by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage runwayResult;

// status
String status = "";

PImage targetImage;
PImage sourceImage;

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
  // draw content image (if loaded)
  if(sourceImage != null){
    image(sourceImage,0,0,600,400);
  }
  // draw style image (if loaded)
  if(targetImage != null){
    image(targetImage,600,0);
  }
  // draw image received from Runway
  if(runwayResult != null){
    image(runwayResult,1200,0);
  }
  
  // display status
  text("Press 's' to select a source image\nPress 't' to select a target image\nPress ' ' to send to Runway"+status,5,15);
}

void keyPressed(){
  if(key == 't'){
    selectInput("Select a target image to process:", "targetImageSelected");
  }
  if(key == 's'){
    selectInput("Select a source image to process:", "sourceImageSelected");
  }
  if(key == ' '){
    queryRunway();
  }
}

void targetImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    targetImage = loadImage(selection.getAbsolutePath());
    // resize image (adjust as needed)
    targetImage.resize(600,400);
  }
}

void sourceImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    sourceImage = loadImage(selection.getAbsolutePath());
    // resize image (adjust as needed)
    sourceImage.resize(600,400);
  }
}

void queryRunway(){
  // skip if style image isn't loaded yet
  if(targetImage == null){
    return;
  }
  // skip if content image isn't loaded yet
  if(sourceImage == null){
    return;
  }
  // prepare input JSON data to send to Runway
  JSONObject input = new JSONObject();
  // set source image
  input.setString("source",ModelUtils.toBase64(sourceImage));
  // set target image
  input.setString("target",ModelUtils.toBase64(targetImage));
  // query Runway
  runway.query(input.toString());
}


// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("result");
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
