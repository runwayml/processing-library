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

// im2txt Demo:
// Receive HTTP messages from Runway
// Running im2txt model

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// The data coming in from Runway as a JSON Object {}
JSONObject data;

void setup() {
  size(500, 300);
  frameRate(3);
  fill(255);
  stroke(255);
  // setup Runway
  runway = new RunwayHTTP(this);
}

void draw() {
  background(0);
  
  // Display captions
  drawCaptions();
}


// A function to display the captions
void drawCaptions() {
  // Only if there are any captions 
  if (data != null) {
    String results = data.getString("caption");
    text(results, 100, 100);
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
}
