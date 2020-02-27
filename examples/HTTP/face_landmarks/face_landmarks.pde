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

// face_landmarks Demo:
// Receive OSC messages from Runway
// Running face_landmarks model
// original example by Joel Matthys @jwmatthys, adapted by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// This array will hold all the humans detected
JSONObject data;

void setup(){
  // match sketch size to default model camera setup
  size(600,400);
  fill(9,130,250);
  noStroke();
  // setup Runway
  runway = new RunwayHTTP(this);
}

void draw(){
  background(0);
  // use the utiliy class to draw PoseNet parts
  if(data != null){
    JSONArray landmarks = data.getJSONArray("points");
    if (landmarks != null)
    {
      for (int k = 0; k < landmarks.size(); k++) {
        // Body parts are relative to width and weight of the input
        JSONArray point = landmarks.getJSONArray(k);
        float x = point.getFloat(0);
        float y = point.getFloat(1);
        ellipse(x * width, y * height, 10, 10);
      }
    }
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
}
