# RunwayML library for Processing

A library to easily use [RunwayML](https://runwayml.com) with [Processing](https://processing.org/).

## Prerequisites

* [RunwayML](https://runwayml.com/): Download the latest release of [RunwayML](https://runwayml.com/download) and sign up for an account. Visit our [installation guide](https://learn.runwayml.com/#/getting-started/installation) for more details. If you encounter any issues installing RunwayML, feel free to contact us through the [support page](https://support.runwayml.com).

* [Processing](https://processing.org/): Processing version 3.0 or greater is required.

## Installation

1. Download **[RunwayML.zip](https://github.com/runwayml/processing-library/releases/download/latest/RunwayML.zip)**
2. Unzip into **Documents > Processing > libraries**
3. Restart Processing (if it was already running)

[📽 Watch How to Install and Use the RunwayML Processing Library](https://www.youtube.com/watch?v=zGdOKaLOjck&list=PLj598ZXODDO_oWYAiO5c0Ac05IyrPUG8t&index=6&t=0s)

## Basic Example

This example will print `/data` from Runway (e.g. running im2txt)

```processing
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

void setup() {
  // setup Runway
  runway = new RunwayHTTP(this);
}

void draw() {
  
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  println(runwayData);
}
```

## Existing Examples

You can access the following examples via **Processing > Examples > Contributed Libraries > RunwayML**

- AdaIN-Style-Transfer ![preview](assets/examples/ada-in-style-transfer.jpg)
(content image: "Still Life with fruit dish" by Paul Cézanne,
style image: "Fruit Dish" by Georges Braques)
  
- Adaptive-Style-Transfer ![preview](assets/examples/adaptive-style-transfer.jpg)
(content image: "Fruit Dish" by Georges Braques, inference using Cézanne (landscapes) style)  
- Arbitrary-Image-Stylization ![preview](assets/examples/arbitrary-image-stylization.jpg)
(content image: "Girl with a Mandolin" by Pablo Picasso,
style image: "Man with a guitar" by Georges Braques)
  
- AttnGAN:![preview](assets/examples/attn-gan.jpg)
  
- BigGAN: ![preview](assets/examples/big-gan.jpg)

- cnOCR: ![preview](assets/examples/cn-ocr.jpg)

- COCO-SSD: ![preview](assets/examples/coco-ssd.jpg)
(content image: "The Card Players" by Paul Cézanne)

- CycleGAN: ![preview](assets/examples/cycle-gan.jpg)
(content image: "Fruit Dish" by Georges Braques)
- DeepFill: ![preview](assets/examples/deep-fill.jpg)
(content image: "Study after Velázquez's Portrait of Pope Innocent X" by Francis Bacon)
- DeepLab: ![preview](assets/examples/deep-lab.jpg)
(content image: "The Card Players" by Paul Cézanne)
- DeepLabV3: ![preview](assets/examples/deep-lab-v3.jpg)
(content image: "The Card Players" by Paul Cézanne)
- DeepPrivacy: ![preview](assets/examples/deep-privacy.jpg)
(image credits: "Portrait of Ada Lovelace" by Margaret Sarah Carpenter)
- DenseCap: ![preview](assets/examples/dense-cap.jpg)
(content image: "The Card Players" by Paul Cézanne)
- DenseDepth: ![preview](assets/examples/dense-depth.jpg)
(content image: "The Card Players" by Paul Cézanne)
- DensePose: ![preview](assets/examples/dense-pose.jpg)
(image credits: Margaret Hamilton in 1969 with the source code her team developed for the Apollo missions. Photograph: Science History Images/Alamy Stock Photo via theguardian.com)
- DeOldify: ![preview](assets/examples/de-oldify.jpg)
(content image: Grace Hopper, image credits: Courtesy of the Computer History Museum, source: https://news.yale.edu/2017/02/10/grace-murray-hopper-1906-1992-legacy-innovation-and-service)
- DeRaindrop: ![preview](assets/examples/de-raindrop.jpg)
(content image: "Sudden shower over Shin Ōhashi bridge and Atake" by Hiroshige)
- EdgeConnect: ![preview](assets/examples/edge-connect.jpg)
(content image: "Self-Portrait with Striped Shirt" by Egon Schiele)
- ESRGAN: ![preview](assets/examples/esrgan.jpg)
(image credits: SuSuMa original source: https://en.wikipedia.org/wiki/White_tiger#/media/File:White-tiger-2407799_1280.jpg)
- Face-Landmarks: ![preview](assets/examples/face-landmarks.jpg)
(content image: "Celestina" by Pablo Picasso)
- Face-Parser: ![preview](assets/examples/face-parser.jpg)
(content image: "Celestina" by Pablo Picasso)
- Face-Recognition: ![preview](assets/examples/face-recognition.jpg)
(image from 12 Angry Men (1957) directed by Sidney Lumet)
- Fast-Photo-Style ![preview](assets/examples/fast-photo-style.jpg)
(content image: "Still Life with fruit dish" by Paul Cézanne,
style image: "Fruit Dish" by Georges Braques)
- Fast-Style-Transfer: ![preview](assets/examples/fast-style-transfer.jpg)
(content image: "Nude Descending a Staircase, No. 2" by Marcel Duchamp)
- GLOW: ![preview](assets/examples/glow.jpg)
(content image: "Self-Portrait with Striped Shirt" by Egon Schiele)
- GPT-2: ![preview](assets/examples/gpt-2.jpg)
- im2txt: ![preview](assets/examples/im2txt.jpg)
(content image: "The Card Players" by Paul Cézanne)
- Image-Inpainting-GMCNN: ![preview](assets/examples/inpainting-gmcnn.jpg)
(content image: "Study after Velázquez's Portrait of Pope Innocent X" by Francis Bacon)
- Image-Super-Resolution: ![preview](assets/examples/image-super-resolution.jpg)
(image credits: SuSuMa original source: https://en.wikipedia.org/wiki/White_tiger#/media/File:White-tiger-2407799_1280.jpg)
- MaskRCNN: ![preview](assets/examples/mask-rcnn.jpg)
(image credits: Margaret Hamilton in 1969 with the source code her team developed for the Apollo missions. Photograph: Science History Images/Alamy Stock Photo via theguardian.com)
- MobileNet: ![preview](assets/examples/mobilenet.jpg)
(content image: "Still Life with fruit dish" by Paul Cézanne)
- Model3DDFA: ![preview](assets/examples/3ddfa.jpg)
(image credits: "Portrait of Ada Lovelace" by Margaret Sarah Carpenter)
- OpenGPT-2: ![preview](assets/examples/open-gpt-2.jpg)
- OpenPifPaf-Pose: ![preview](assets/examples/open-pif-paf.jpg)
(image credits: Margaret Hamilton in 1969 with the source code her team developed for the Apollo missions. Photograph: Science History Images/Alamy Stock Photo via theguardian.com)
- Photo-Sketch: ![preview](assets/examples/photo-sketch.jpg)
- Pix2Pix: ![preview](assets/examples/pix2pix.jpg)
(content image: "Broadway Boogie Woogie" by Piet Mondrian)
- Pix2Pix Facemarks2Portrait: ![preview](assets/examples/pix2pix-facemarks2portrait.jpg)
- Places365: ![preview](assets/examples/places-365.jpg)
(image credits: "London: The Thames from Somerset House Terrace towards the City" by Canaletto)
- PoseNet: ![preview](assets/examples/posenet.jpg)
(image credits: Margaret Hamilton in 1969 with the source code her team developed for the Apollo missions. Photograph: Science History Images/Alamy Stock Photo via theguardian.com)
- SPADE-COCO: ![preview](assets/examples/spade-coco.jpg)
(uses segmenation based on "The Card Players" by Paul Cézanne)
- SPADE-Landscapes: ![preview](assets/examples/spade-landscapes.jpg)
(uses segmenation based on "The Card Players" by Paul Cézanne)
- Style2Paints: ![preview](assets/examples/style2paints.jpg)
(content image: "Self-Portrait with Striped Shirt" by Egon Schiele)
- StyleGAN: ![preview](assets/examples/style-gan.jpg)
- VisualImportance: ![preview](assets/examples/visual-importance.jpg)
(image credits: "Portrait of Ada Lovelace" by Margaret Sarah Carpenter)
- YOLACT: ![preview](assets/examples/yolact.jpg)
(content image: "The Card Players" by Paul Cézanne)  
- UGATIT: ![preview](assets/examples/ugatit.jpg)
(content image: "Still Life with fruit dish" by Paul Cézanne)


## Dependencies

This Processing Library manages the OSC connection to Runway relying on the [oscP5](http://www.sojamo.de/libraries/oscP5/) library.

Please install oscP5 before using the OSC connection with this library via **Sketch > Import Library... > Add Library... > Contribution Manager Filter > oscP5**

## Contributing

This is still a work in progress. Contributions are welcomed!

## Credits

Special thanks for mentoring and support from [Cris Valenzuela, Anastasis Germanidis](https://runwayml.com) and [Daniel Shiffman](https://github.com/shiffman)

Main library developement by [George Profenza](https://github.com/orgicus)

Library examples are based partially on [Runway Processing Examples](https://github.com/runwayml/processing) by:

- [Cris Valenzuela](https://github.com/cvalenzuela)
- [Anastasis Germanidis](https://github.com/agermanidis)
- [Gene Kogan](https://github.com/genekogan)
- [maybay21](https://github.com/maybay21)
- [JP Yepez](https://github.com/jpyepez)
- [Joel Matthys](https://github.com/jwmatthys)
- [Alejandro Matamala Ortiz](https://github.com/matamalaortiz)
