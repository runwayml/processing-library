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

// PoseNet Demo:
// Receive OSC messages from Runway
// Running PoseNet model
// original example by Anastasis Germanidis, adapted by George Profenza

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

PImage image;

void setup(){
  // match sketch size to default model camera setup
  size(600,400);
  // change default black stroke
  stroke(9,130,250);
  strokeWeight(3);
  // setup Runway
  runway = new RunwayHTTP(this);
  // stop auto-updates
  runway.setAutoUpdate(false);
  selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    // load image
    image = loadImage(selection.getAbsolutePath());
    // resize sketch
    surface.setSize(image.width,image.height);
    // send image to Runway
    runway.query(image);
  }
}

void draw(){
  background(0);
  if(image != null){
    image(image,0,0);
  }
  // manually draw PoseNet parts
  drawPoseNetParts(data);
}

void drawPoseNetParts(JSONObject data){
  // Only if there are any humans detected
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for(int i = 0 ; i < connections.length; i++){
        
        JSONArray startPart = keypoints.getJSONArray(connections[i][0]);
        JSONArray endPart   = keypoints.getJSONArray(connections[i][1]);
        // extract floats fron JSON array and scale normalized value to sketch size
        float startX = startPart.getFloat(0) * width;
        float startY = startPart.getFloat(1) * height;
        float endX   = endPart.getFloat(0) * width;
        float endY   = endPart.getFloat(1) * height;
        
        line(startX,startY,endX,endY);
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
