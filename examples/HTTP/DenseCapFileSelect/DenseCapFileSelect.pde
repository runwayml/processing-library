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

// COCO-SSD Demo:
// Receive HTTP messages from Runway
// Running COCO-SSD model
// example by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// The data coming in from Runway as a JSON Object {}
JSONObject data;

String status = "Press 'c' to select a content image";
// image to send to Runway
PImage contentImage;

void setup() {
  size(600, 400);
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
  // draw content image (if loaded)
  if(contentImage != null){
    image(contentImage,0,0);
  }
  
  // Display captions
  drawCaptions();
  
  // display status
  text(status,5,15);
}

void keyPressed(){
  if(key == 'c'){
    selectInput("Select a content image to process:", "contentImageSelected");
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
    // send to Runway
    runway.query(contentImage);
  }
}



// A function to display the captions
void drawCaptions() {
  // if no data is loaded yet, exit
  if(data == null){
    return;
  }
  
  // for each array element
  for (int i = 0; i < data.size(); i++) {

    JSONArray className = data.getJSONArray("classes");
    JSONArray score = data.getJSONArray("scores");
    JSONArray boxes = data.getJSONArray("bboxes");

    String label = className.getString(i);
    float val=score.getFloat(i);
    JSONArray box = boxes.getJSONArray(i);
    // extract values from the float array
    float x = box.getFloat(0)* width;
    float y = box.getFloat(1)* height;
    float w = (box.getFloat(2) * width) - x;
    float h = (box.getFloat(3) * height) - y;

    // display bounding boxes
    noFill();
    rect(x, y, w, h);
    fill(255);
    text(label + " score: " + String.format("%.2f", val), x, y);

  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
}
