var SATURATION = 0.7;

image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    // make each pixel more extreme (closer to pure red, green, or blue)
    var avg = (pixel.getRed() + pixel.getGreen() + pixel.getBlue()) / 3;
    var dRed = pixel.getRed() - avg;
    var dGreen = pixel.getGreen() - avg;
    var dBlue = pixel.getBlue() - avg;
    pixel.setRed(pixel.getRed() + dRed * SATURATION);
    pixel.setGreen(pixel.getGreen() + dGreen * SATURATION);
    pixel.setBlue(pixel.getBlue() + dBlue * SATURATION);
}
image.refresh();