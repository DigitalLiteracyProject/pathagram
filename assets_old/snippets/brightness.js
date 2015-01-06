var RATIO = 1.5;

image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    pixel.setRed(pixel.getRed() * RATIO);
    pixel.setGreen(pixel.getGreen() * RATIO);
    pixel.setBlue(pixel.getBlue() * RATIO);
}

image.refresh();