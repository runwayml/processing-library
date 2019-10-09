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

// BigGAN Demo:
// Receive HTTP messages from Runway
// Running BigGAN
// example by George Profenza

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// The data coming in from Runway as a JSON Object {}
JSONObject data;

// Storage for received Runway image data
PImage runwayResult;

// example input vector
String[] categories;
int categoryIndex;
String category = "tiger, Panthera tigris";
String z = "[0.7724706985220299,-0.4935352445386155,0.2593357840584296,-0.05743993482325836,0.12922740189943813,-0.060854071580116284,0.07779830974178048,0.18591635221794583,0.09204426513037678,0.268461073932552,-0.14970301672565567,0.03862303139078582,0.07271976281960693,0.007121388855950386,-0.5069413947533913,-0.3016005623282333,-0.2920439260204202,0.0295308185555595,0.16109896520491807,0.7723146038226892,0.11192404162410646,-0.8726172013185323,0.29947722555274314,0.026325803732270055,0.6236836525482027,-0.372698611973506,-0.05011597055774075,0.3660891904537052,0.25454821768290364,-0.6378830373939408,0.5215835565314639,0.3318826133990969,0.10021523540248883,0.14069006313433852,-0.38841455340610725,0.5985318346184829,0.013850558924667838,0.2854599746774973,-0.3341204895186766,-0.4755360858115585,-0.02342583193809257,-0.07100704662583471,-0.11419099265351242,0.2105769109992658,-0.3679241862481314,0.1710232283991349,-0.19673291892127817,0.4601336381707294,0.016799314952714136,0.32061601187616756,0.07927030386199643,-0.3091743644373721,-0.4562185027283634,0.4181295648821426,-0.4263505103385551,-0.2555957058426298,0.3870287193853762,0.19119020483648722,0.458403869615646,-0.3086904491088613,-0.6981333194280939,0.41109764683152983,-0.030187214371002274,0.18437403028970195,0.23492772479034263,-0.4795481034726173,-0.1632641132816952,0.4028936323088781,-0.006844683102349605,-0.020974318581923376,0.49665969611449967,-0.07669994829341059,-0.08075611451693354,0.05059452457912972,0.1269498344771861,0.226235960163477,0.2615467208420373,-0.7571567903391764,-0.24550549778162034,-0.23809037646188924,-0.014359179879207887,0.32586786327073414,-0.10340666918821795,-0.45584681163743856,0.10399542736170442,-0.2141247756958835,0.21001790249356353,0.13962871777427782,0.01615356911672447,-0.5676829745278167,-0.32422784609220023,-0.2796470245062035,-0.04064660459311962,0.2354834772004773,-0.21663294994273885,-0.1576731670876877,0.39628375714654224,0.2908319752122952,-0.30473026166065076,-0.3946504032852317,0.5397363017624044,0.40991068583696294,0.6025498951409232,-0.27893581171240944,0.26376608238660637,-0.37149186635243897,-0.16643279259996024,0.05066529520523722,0.17628791083318915,0.14736760837688206,0.02222836588745039,-0.24714092995513795,-0.019522288876607247,-0.23830087746793802,0.3489243241854584,0.31710870136528924,-0.36014639076417326,0.24290714807418015,0.003521384072587279,0.4394382985702696,-0.1593721594350416,0.09790779287771165,-0.21306143680434336,0.22204710067614605,-0.005431850712497521,0.3446260435686303,0.03810049055705578,-0.35938716082257766,0.0798418187615908,-0.20540713892642465,-0.26576984965373646,-0.4476687138908696,0.016813515206818293,-0.47106624874439573,-0.10211071768405018,0.4499661044048413,-0.30550018883475755,-0.26409452989423443,0.8031365137371466,-0.3680150738025804]";

void setup() {
  size(256, 256);
  frameRate(3);
  fill(255);
  
  // setup Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);
}

void draw() {
  background(0);
  
  // display result (if any)
  if(runwayResult != null){
    image(runwayResult,0,0);
  }
  
  // display instructions
  text("press SPACE to request an image\npress 's' to save it disk\npress LEFT/RIGHT to change category\n"+category,5,15);
}

void keyPressed(){
  if(keyCode == LEFT && categoryIndex > 0){
    categoryIndex--;
    category = categories[categoryIndex];
  }
  if(keyCode == RIGHT && categoryIndex < categories.length - 1){
    categoryIndex++;
    category = categories[categoryIndex];
  }
  if(key == ' '){
    // query a set vector
    String input = "{\"z\":"+z+",\"category\":\""+category+"\"}";
    runway.query(input);
  }
  if(key == 's' && runwayResult != null){
    runwayResult.save(dataPath("result.png"));
  }
}

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  println(info.format(-1));
  categories = info.getJSONArray("inputs").getJSONObject(0).getJSONArray("oneOf").getStringArray();
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  String base64ImageString = runwayData.getString("generatedOutput");
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
