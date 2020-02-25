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
// along with Runway.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAYML
// www.runwayml.com
// original example by https://github.com/maybay21, adapted by George Profenza

// import controlp5
import controlP5.*;
//create controlP5 instance
ControlP5 cp5;

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

String textValue = "";
String text_output;
JSONObject data;
JSONObject json_message;
String json_output;

void setup() {
  //create canvas
  size(900,700);
  
  // setup Runway
  runway = new RunwayHTTP(this);
  // don't send data at the end of each frame automatically
  runway.setAutoUpdate(false);
  
  //create a font
  PFont font = createFont("arial",20);
  
  cp5 = new ControlP5(this);
  //definetextField
  cp5.addTextfield("input")
     .setPosition(20,40)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(0,255,0))
     ;
                  
     
  textFont(font);
}

void draw() {
  //create black background
  background(0);
  fill(255);
  
  //display the text we are writing to the screen
  text(cp5.get(Textfield.class,"input").getText(), 20,180);
  
  //get the returned results and display them on the interface
  text(textValue, 20,80);
   if(text_output != null){
    fill(255);
    stroke(255);
    textSize(12);
    text(text_output, 320, 10, 400, height);
   }
}


//clear the text field after input
void clear() {
  cp5.get(Textfield.class,"textValue").clear();
}

//send the text from ou interface to RunwayML
void input(String theText) {
  //create json object
  json_message = new JSONObject();
  
  //add the text from the textfield and seed
  json_message.setString("prompt", theText);
  json_message.setInt("seed", 1);
  print(json_message);
  json_output = json_message.toString();

  //send the message to RunwayML
  runway.query(json_output);
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
  //get the value of the "text" key
  text_output = data.getString("generated_text");
}
