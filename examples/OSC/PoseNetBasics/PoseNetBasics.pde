// Copyright (C) 2018 Runway AI Examples
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
// Receive OSC messages from Runway
// Running PoseNet model
// original example by Anastasis Germanidis, adapted by George Profenza

// import OSC libraries
import oscP5.*;
import netP5.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayOSC runway;

// This array will hold all the humans detected
JSONObject data;

void setup(){
  // match sketch size to default model camera setup
  size(600,400);
  // setup Runway
  runway = new RunwayOSC(this);
}

void draw(){
  background(0);
  // use the utiliy class to draw PoseNet parts
  runway.drawPoseNetParts(data,10);
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
}
