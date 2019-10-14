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

// SPADE Landscapes Demo:
// Receive HTTP messages from Runway
// Running SPADE-Landscapes model
// example by George Profenza

int currentLabelIndex = 0;
int currentLabelColor;

String status = "";

// Input Image
PImage inputImage;


void setup(){
  size(1280,360);
  stroke(255);
  
  setupRunway();
  
}

void draw(){
  // clear background
  background(0);
  // Display image (if loaded)
  if(inputImage != null){
    image(inputImage,0,0);
  }
  // display runway result (if any)
  if(runwayResult != null){
    image(runwayResult,640,0);
  }
  // display usage
  if(labels != null){
    text("press 's' to select an input image\npress SPACE to send image to Runway",5,15);
  }
  // separator
  line(640,0,640,360);
}


void keyPressed(){
  if(key == 's'){
    selectInput("Select an input image to process:", "inputImageSelected");
  }
  if(key == ' '){
    status = "waiting for results";
    sendImageToRunway(inputImage);
  }
}

void inputImageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("selected " + selection.getAbsolutePath());
    inputImage = loadImage(selection.getAbsolutePath());
  }
}
