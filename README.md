# RunwayML library for Processing

A library to easily use [RunwayML](https://runwayml.com) with [Processing](https://processing.org/).

## How install 

### Option 1: via Contribution Manager

In Processing:

1. go to **Sketch > Import Library... > Add Library... > Contribution Manager Filter > Runway**
2. select RunwayML
3. press install

### Option 2: manually

1. Download **RunwayML.zip** from the [releases page](https://github.com/runwayml/processing-library/releases)
2. Unzip into **Documents > Processing > libraries**
3. Restart Processing (if it was already running)

## Basic Examples

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
  
- Adaptive-Style-Transfer ![preview](assets/examples/adaptive-style-transfer.jpg)
  
- Arbitrary-Image-Stylization ![preview](assets/examples/arbitrary-image-stylization.jpg)
  
- AttnGAN:![preview](assets/examples/attn-gan.jpg)
  
- BigGAN: ![preview](assets/examples/big-gan.jpg)

- cnOCR: ![preview](assets/examples/cn-ocr.jpg)

- COCO-SSD: ![preview](assets/examples/coco-ssd.jpg)

- CycleGAN: ![preview](assets/examples/cycle-gan.jpg)

- DeepLab: ![preview](assets/examples/deep-lab.jpg)

- DenseCap: ![preview](assets/examples/dense-cap.jpg)

- DenseDepth: ![preview](assets/examples/dense-depth.jpg)

- DeOldify: ![preview](assets/examples/de-oldify.jpg)

- Face-Landmarks: ![preview](assets/examples/face-landmarks.jpg)

- Face-Recognition: ![preview](assets/examples/face-recognition)

- Fast-Style-Transfer: ![preview](assets/examples/fast-style-transfer.jpg)

- GPT-2: ![preview](assets/examples/gpt-2.jpg)

- im2txt: ![preview](assets/examples/im2txt.jpg)

- Image-Inpainting-GMCNN: ![preview](assets/examples/inpainting-gmcnn.jpg)

- Image-Super-Resolution: ![preview](assets/examples/image-super-resolution.jpg)

- MaskRCNN: ![preview](assets/examples/mask-rcnn.jpg)

- Model3DDFA: ![preview](assets/examples/3ddfa.jpg)

- OpenPifPaf-Pose: ![preview](assets/examples/open-pif-paf.jpg)

- Photo-Sketch: ![preview](assets/examples/photo-sketch.jpg)

- PoseNet: ![preview](assets/examples/posenet.jpg)

- SPADE-COCO: ![preview](assets/examples/spade-coco.jpg)

- SPADE-Landmarks: ![preview](assets/examples/spade-landmarks.jpg)

- StyleGAN: ![preview](assets/examples/style-gan.jpg)

- VisualImportance: ![preview](assets/examples/visual-importance.jpg)

- YOLACT: ![preview](assets/examples/yolact.jpg)
  

## Dependencies

This Processing Library manages the OSC connection to Runway relying on the [oscP5](http://www.sojamo.de/libraries/oscP5/) library.

Please install oscP5 before using the OSC connection with this library

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