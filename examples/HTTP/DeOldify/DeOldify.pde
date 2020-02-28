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

// DeOldify Demo:
// Receive HTTP messages from Runway
// Running DeOldify model
// example by George Profenza
// image credits: Courtesy of the Computer History Museum, source: https://news.yale.edu/2017/02/10/grace-murray-hopper-1906-1992-legacy-innovation-and-service

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage inputImage;
PImage outputImage;

String status = "";

void setup() {
  size(1150, 334);
  noSmooth();
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
  // load example image: feel free to replace with yours
  inputImage = loadImage("GraceHopper.jpg");
}

void draw() {
  background(0);
  // draw input image (if any)
  if(outputImage != null){
    image(outputImage,575,0);
  }
  // draw webcam image
  image(inputImage,0,0);
  // draw instructions
  text("press SPACE to send image to Runway\n" + status,5,15);
}

void keyPressed(){
  if(key == ' '){
    status = "processing data";
    // send inputImage to Runway
    runway.query(inputImage);
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // extract Base64 encoded image from JSON object and decode it to a PImage
 try{
   outputImage = ModelUtils.fromBase64(runwayData.getString("image"));
   status = "processing complete";
 }catch(Exception e){
   println("error parsing runway Data:\n" + runwayData.toString());
   e.printStackTrace();
 }
}
