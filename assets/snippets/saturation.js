var SATURATION = 0.7;

var image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    var red = pixel.getRed();
    var green = pixel.getGreen();
    var blue = pixel.getBlue();

    // make each pixel more extreme (closer to pure red, green, or blue)
    var avg = (red + green + blue) / 3;
    var dRed = red - avg;
    var dGreen = green - avg;
    var dBlue = blue - avg;
    pixel.setRed(red + dRed * SATURATION);
    pixel.setGreen(green + dGreen * SATURATION);
    pixel.setBlue(blue + dBlue * SATURATION);
}

image.refresh();
