/**
 * PIXELATE
 * pixelate.pde
 * 
 * Creates pixelated images
 * Implemented using the pcoessing framework
 * https://processing.org/
 *
 * @author Guido Schmidt <guido.schmidt.2912@gmail.com>
 * @version 0.2
 * @date 06.01.2015
 * @license http://opensource.org/licenses/MIT
 */

// Options
String filepath = "img/";
String imgName = "eames.jpg";
int pixelCount = 10;
int margin = 0;

// Globals
PImage img;

void setup() { 
  img = loadImage(filepath + '/' +  imgName);
  noLoop();
  background(65, 65, 65);
  size((img.width/2)*2+60, (img.height/2)+40);
} 

void draw() {
  image(img, 20, 20, img.width/2, img.height/2);
  img.loadPixels();
  println("Image dimension: " + img.width + " x " + img.height);

  if(pixelCount >= img.width || pixelCount >= img.height) {
    println("ERROR: pixelCount should be smaller than the image dimension!");
    exit();
  }

  int step = img.width/pixelCount;
  println("Stepsize: " + step);
  int borderX = 0, borderY = 0;
  borderX = img.width % step;
  borderY = img.height % step;
  println("Bordersize: " + borderX + " | " + borderY);

  int divisor = (step*step);
  float[] colorArray = new float[3];
  PImage outImg = createImage(img.width, img.height, RGB);

  for (int y = 0; y < img.height-1-borderY; y+=step) {
    for (int x = 0; x < img.width-1-borderX; x+=step) {
      int pos = y * img.width + x;
      int sumR = 0, sumG = 0, sumB = 0;

      for(int ky = 0; ky < step; ky++) {
        for(int kx = 0; kx < step; kx++) {
          int maskPos = (y + ky) * img.width + (x + kx);

          // Border 
          if((y + ky) > img.height)
            maskPos = (y - ky) * img.width + (x + kx);
          if((x + kx) > img.width)
            maskPos = (y + ky) * img.width + (x - kx);

          colorArray[0] =   red(img.pixels[maskPos]);
          colorArray[1] = green(img.pixels[maskPos]);
          colorArray[2] =  blue(img.pixels[maskPos]);

          int randomIndex = int(random(colorArray.length));

          sumR += colorArray[0];
          sumG += colorArray[1];
          sumB += colorArray[2];
        }
      }

      for(int ky = 0; ky < step; ky++) {
        for(int kx = 0; kx < step; kx++) {
          // Border 
          if((y + ky) > img.height || (x + kx) > img.width)
            continue;

          int maskPos = (y + ky) * img.width + (x + kx);
          outImg.pixels[maskPos] = color(sumR/divisor,
                                         sumG/divisor,
                                         sumB/divisor);
        }
      }

    }
  }

  outImg.updatePixels();
  image(outImg, width/2 + 10 + borderX/4, 20 + borderY/4, img.width/2, img.height/2); // Draw the new image
  outImg.save(filepath + "/pixelated_" + imgName);
}

