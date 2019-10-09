
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
// along with Runway.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAY
// www.runwayapp.ai

// COCO-SSD StreetView Demo:
// Loads a csv file exported by Runway
// Made by jpyepez

import processing.video.*;

Movie streetMovie;
float movieScale;
boolean isFirstFrame;
float movieDuration;
boolean isPlaying;

Coco coco;

void setup() {
    size(1, 1);
    surface.setResizable(true);

    // movie setup
    streetMovie = new Movie(this, "street.mp4");
    streetMovie.loop();
    movieDuration = streetMovie.duration();
    movieScale = 0.5;
    isFirstFrame = true;

    // Coco SSD handler
    // initialize with maximum result index
    // e.g. '12' in results.12.bbox...
    coco = new Coco(12);

}

void draw() {
    image(streetMovie, 0, 0, width, height);
    coco.display(streetMovie.time());
}

void movieEvent(Movie movie) {
    movie.read();

    // resize canvas using movie properties
    // set playhead start
    if(isFirstFrame) {
        surface.setSize(int(movie.width * movieScale), int(movie.height * movieScale));
        surface.setLocation(0, 0);
        isFirstFrame = false;
        isPlaying = false;
    }
}

void keyReleased() {
    if(key == ' ') {
        if(!isPlaying) {
            streetMovie.play();
        } else {
            streetMovie.pause();
        }
        isPlaying = !isPlaying;
    }
}