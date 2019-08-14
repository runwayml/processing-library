// Copyright (C) 2019 Runway AI Examples
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

// PoseNet Demo:
// Receive HTTP messages from Runway
// Running PoseNet model
// original example by Anastasis Germanidis, adapted by George Profenza

// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// This array will hold all the humans detected
JSONObject data;

// This are the pair of body connections we want to form. 
// Try creating new ones!
int[][] connections = {
  {ModelUtils.POSE_NOSE_INDEX, ModelUtils.POSE_LEFT_EYE_INDEX},
  {ModelUtils.POSE_LEFT_EYE_INDEX, ModelUtils.POSE_LEFT_EAR_INDEX},
  {ModelUtils.POSE_NOSE_INDEX,ModelUtils.POSE_RIGHT_EYE_INDEX},
  {ModelUtils.POSE_RIGHT_EYE_INDEX,ModelUtils.POSE_RIGHT_EAR_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_ELBOW_INDEX},
  {ModelUtils.POSE_RIGHT_ELBOW_INDEX,ModelUtils.POSE_RIGHT_WRIST_INDEX},
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_ELBOW_INDEX},
  {ModelUtils.POSE_LEFT_ELBOW_INDEX,ModelUtils.POSE_LEFT_WRIST_INDEX}, 
  {ModelUtils.POSE_RIGHT_HIP_INDEX,ModelUtils.POSE_RIGHT_KNEE_INDEX},
  {ModelUtils.POSE_RIGHT_KNEE_INDEX,ModelUtils.POSE_RIGHT_ANKLE_INDEX},
  {ModelUtils.POSE_LEFT_HIP_INDEX,ModelUtils.POSE_LEFT_KNEE_INDEX},
  {ModelUtils.POSE_LEFT_KNEE_INDEX,ModelUtils.POSE_LEFT_ANKLE_INDEX}
};

//reference to the camera
Capture camera;

void setup(){
  // match sketch size to default model camera setup
  size(600,400);
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
  image(camera,0,0);
  // manually draw PoseNet parts
  drawPoseParts(data);
  // usage text
  text("press 'SPACE' to query image",5,15);
}

void drawPoseParts(JSONObject data){
  // Only if there are any humans detected
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONObject human = humans.getJSONObject(h);
      JSONArray keypoints = human.getJSONArray("keypoints");
      // Now that we have one human, let's draw its body parts
      for(int i = 0 ; i < connections.length; i++){
        
        JSONObject startPart = keypoints.getJSONObject(connections[i][0]);
        JSONObject endPart   = keypoints.getJSONObject(connections[i][1]);
        
        JSONObject startPosition = startPart.getJSONObject("position");
        JSONObject endPosition   = endPart.getJSONObject("position");
        
        line(startPosition.getFloat("x"),startPosition.getFloat("y"),
             endPosition.getFloat("x"),endPosition.getFloat("y"));
      }
    }
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
  
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

void captureEvent(Capture camera){
  camera.read();
}

void keyPressed(){
  if(key == ' '){
    // crop image to Runway input format (600x400)
    PImage image = camera.get(0,0,600,400);
    // query Runway with webcam image 
    runway.query(image);
  }
}
