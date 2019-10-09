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

// Image Super Resolution Demo:
// Receive HTTP messages from Runway
// Running Image Super Resolution model
// example by George Profenza
// image credits: SuSuMa original source: https://en.wikipedia.org/wiki/White_tiger#/media/File:White-tiger-2407799_1280.jpg

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

PImage inputImage;
PImage outputImage;

String status = "";

void setup() {
  size(1024, 512);
  noSmooth();
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
  // load example image: feel free to replace with yours
  inputImage = loadImage("white-tiger-128x128.jpg");
}

void draw() {
  background(0);
  // draw input image (if any)
  if(outputImage != null){
    image(outputImage,512,0,512,512);
  }
  // draw webcam image
  image(inputImage,0,0,512,512);
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
   outputImage = ModelUtils.fromBase64(runwayData.getString("upscaled"));
   status = "processing complete";
 }catch(Exception e){
   println("error parsing runway Data:\n" + runwayData.format(-1));
   e.printStackTrace();
 }
}
