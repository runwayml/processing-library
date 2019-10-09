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

// OpenPifPaf Demo:
// Running OpenPifPaf model
// example by George Profenza

// import video library
import processing.video.*;

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// This array will hold all the humans detected
JSONArray humans;

PImage runwayResult;

color BLUE = color(9,130,250); 

// periocally to be updated using millis()
int lastMillis;
// how often should the above be updated and a time action take place ?
// OpenPifPaf 6.5-7.0 seconds on CPU to process a frame
int waitTime = 7000;

// reference to the camera
Capture camera;

// status
String status = "waiting ~"+(waitTime/1000)+"s";

void setup(){
  // match sketch size to default model camera setup
  size(1640,666);
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
  // draw image received from Runway
  if(runwayResult != null){
    image(runwayResult,640,0);
  }
  // draw camera feed
  image(camera,0,0);
  // manually draw PoseNet parts
  drawOpenPifPafParts(humans);
  // display status
  text(status,5,15);
}

void sendFrameToRunway(){
  // nothing to send if there's no new camera data available
  if(camera.available() == false){
    return;
  }
  // read a new frame
  camera.read();
  // crop image to Runway input format (600x400)
  PImage image = camera.get(0,0,600,400);
  // query Runway with webcam image 
  runway.query(image);
}

void drawOpenPifPafParts(JSONArray humans){
  // Only if there are any humans detected
  if (humans != null) {
    for(int h = 0; h < humans.size(); h++) {
      JSONObject human = humans.getJSONObject(h);
      JSONArray keypoints = human.getJSONArray("keypoints");
      JSONArray boundingBox = human.getJSONArray("bbox");
      // Now that we have one human, let's draw its body parts
      noStroke();
      fill(BLUE);
      // iterate through keypoints: a 1D array of alternating x1,y1,score1,x2,y2,score2,etc. 
      for(int k = 0 ; k < keypoints.size() - 1; k += 3){
        float x = keypoints.getFloat(k);
        float y = keypoints.getFloat(k + 1);
        //float score = keypoints.getFloat(k + 2);
        // if keypoints have been found, render
        if(x != 0.0 && y != 0.0){
          ellipse(x,y,9,9);
        }
      }
      // render bounding box
      stroke(BLUE);
      strokeWeight(3);
      noFill();
      rect(boundingBox.getFloat(0),boundingBox.getFloat(1),boundingBox.getFloat(2),boundingBox.getFloat(3));
    }
  }
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
  // get keypoints
  try{
    humans = JSONArray.parse(runwayData.getString("keypoints"));
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
