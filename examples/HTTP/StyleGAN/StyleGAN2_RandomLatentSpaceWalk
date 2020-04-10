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

// StyleGAN2_RandomLatentSpaceWalk Demo:
// Receive HTTP messages from Runway
// Running StyleGAN2
// Sending a random 512 float vector into StyleGAN2
// Interpolates between previous and current vector point  
// Example by Moisés Horta Valenzuela (http://moiseshorta.audio)

// import Runway library
import com.runwayml.*;

// reference to runway instance
RunwayHTTP runway;

// storage for received Runway image data
PImage runwayResult;

// declare input vector as string
String input;

//declare number of vectors in StyleGAN2 model (512 floats)
int vectors = 512;
//declare arrays for receiving vectors values
float[] z = new float[vectors];
float[] arrayLerp = new float[vectors];
String[] zString = new String[vectors];
// declare lerp speed
float lerpSpeed = 0.005;

void setup() {
  size(1024, 1024);
  frameRate(25);
  fill(255);
// setup Runway
  runway = new RunwayHTTP(this);
// disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
}

void draw() {
  background(0);
 // loop to generated a random float between -1 and 1 and input into vector
  for(int i = 0; i < (vectors); i++){
 // generates random floats between -1 and 1
   z[i] = random(-1, 1);
 // lerps between last random float value to the next
   arrayLerp[i] = lerp(arrayLerp[i], z[i], lerpSpeed);
   String[] _z = str(arrayLerp);
   zString = _z;
  }
  
// joins zString array into one string
  String _zString = join(zString, ", ");
  //println(_zString);
// random 512 float array gets added to string and sent to Runway
    input = "{\"z\":["+_zString+"],\"truncation\":1.0}";
    runway.query(input);
    
// display result (if any)
  if(runwayResult != null){  
    image(runwayResult, 0, 0);   
 }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
// point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("image");
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
