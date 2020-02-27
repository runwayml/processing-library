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

// DenseCap Demo:
// Receive HTTP messages from Runway
// Running DenseCap model
// example by George Profenza, updated by Jen Sykes

// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// The data coming in from Runway as a JSON Object {}
JSONObject data;

// reference to the camera
Capture camera;

// periocally to be updated using millis()
int lastMillis;
// how often should the above be updated and a time action take place ?
int waitTime = 1000;

void setup() {
  size(600, 400);
  frameRate(3);
  fill(255);
  stroke(255);
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
  // setup camera
  camera = new Capture(this, 640, 480);
  camera.start();
  // setup timer
  lastMillis = millis();
}

void draw() {
  // update timer
  int currentMillis = millis();
  // if the difference between current millis and last time we checked past the wait time
  if (currentMillis - lastMillis >= waitTime) {
    // call the timed function
    sendFrameToRunway();
    // update lastMillis, preparing for another wait
    lastMillis = currentMillis;
  }
  background(0);
  // draw webcam image
  image(camera, 0, 0);

  // Display captions
  drawCaptions();
}


// A function to display the captions
void drawCaptions() {
  // if no data is loaded yet, exit
  if (data == null) {
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

void sendFrameToRunway() {
  // nothing to send if there's no new camera data available
  if (camera.available() == false) {
    return;
  }
  // read a new frame
  camera.read();
  // crop image to Runway input format (600x400)
  PImage image = camera.get(0, 0, 600, 400);
  // query Runway with webcam image 
  runway.query(image);
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData) {
  // point the sketch data to the Runway incoming data 
  data = runwayData;
}
