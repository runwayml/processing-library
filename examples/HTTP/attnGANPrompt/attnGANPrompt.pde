// Copyright (C) 2019 Runway ML Examples
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

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// result image will be stored here
PImage runwayResult;

void setup() {
  size(256, 256);
  frameRate(25);
  // setup Runway
  runway = new RunwayHTTP(this);
  // don't send messages to Runway continuously
  runway.setAutoUpdate(false);
}

void draw() {
  background(0);
  if(runwayResult != null){
    image(runwayResult,0,0);
  }
  text("press 's' to send text to Runway",5,15);
}

void keyPressed() {
  if(key == 's'){
    String caption = (String)javax.swing.JOptionPane.showInputDialog(frame, "Text", "AttnGAN Input Text", javax.swing.JOptionPane.PLAIN_MESSAGE);
    if(caption != null){
      runway.query("{ \"caption\": \""+ caption +"\"}");
    }
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("result");
  // try to decode the image from
  try{
    PImage result = ModelUtils.fromBase64(base64ImageString);
    if(result != null){
      runwayResult = result;
    }
  }catch(Exception e){
    e.printStackTrace();
  }
}
