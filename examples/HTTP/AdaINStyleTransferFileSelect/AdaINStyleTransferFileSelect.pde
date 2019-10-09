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

// AdaIN-Style-Transfer
// Receive HTTP messages from Runway
// Running AdaIN-Style-Transfer model
// example by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage runwayResult;

// status
String status = "";

PImage styleImage;
PImage contentImage;

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
  if(contentImage != null){
    image(contentImage,0,0,600,400);
  }
  // draw style image (if loaded)
  if(styleImage != null){
    image(styleImage,600,0);
  }
  // draw image received from Runway
  if(runwayResult != null){
    image(runwayResult,1200,0);
  }
  
  // display status
  text("Press 's' to select a style image\nPress 'c' to select a content image\nPress ' ' to send to Runway"+status,5,15);
}

void keyPressed(){
  if(key == 's'){
    selectInput("Select a style image to process:", "styleImageSelected");
  }
  if(key == 'c'){
    selectInput("Select a content image to process:", "contentImageSelected");
  }
  if(key == ' '){
    queryRunway();
  }
}

void styleImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    styleImage = loadImage(selection.getAbsolutePath());
    // resize image (adjust as needed)
    styleImage.resize(600,400);
  }
}

void contentImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    contentImage = loadImage(selection.getAbsolutePath());
    // resize image (adjust as needed)
    contentImage.resize(600,400);
  }
}

void queryRunway(){
  // skip if style image isn't loaded yet
  if(styleImage == null){
    return;
  }
  // skip if content image isn't loaded yet
  if(contentImage == null){
    return;
  }
  // prepare input JSON data to send to Runway
  JSONObject input = new JSONObject();
  // set style image
  input.setString("style_image",ModelUtils.toBase64(styleImage));
  // set content image
  input.setString("content_image",ModelUtils.toBase64(contentImage));
  // set preserve colour option
  input.setBoolean("preserve_color",true);
  // set alpha option
  input.setFloat("alpha",1.0);
  // query Runway
  runway.query(input.toString());
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
