// Copyright (C) 2020 Runway ML Examples
// 
// This file is part of Runway ML Examples.
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

// AttnGAN Demo
// Send OSC text messages to Runway and generate images
// example based on https://github.com/runwayml/processing/blob/master/attnGAN/attnGAN.pde adapted by George Profenza
// Import OSC
import oscP5.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayOSC runway;

// The caption to send
String data = "{ \"caption\": \"a blue ocean\"}";

void setup() {
  size(400, 350);
  frameRate(25);
  // setup Runway
  runway = new RunwayOSC(this);
}

void draw() {
  background(0);
  text("press 's' to send text to Runway",5,15);
}

void keyPressed() {
  if(key == 's'){
    runway.query(data);
  }
}
