var SEPIA_FACTOR = 65;
// Sepia = rgb(112, 66, 20)
var RED_MULT = 112 / SEPIA_FACTOR;
var GREEN_MULT = 66 / SEPIA_FACTOR;
var BLUE_MULT = 20 / SEPIA_FACTOR;

var image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    if (pixel.getAlpha() > 0) {
        var avg = (pixel.getRed() + pixel.getGreen() + pixel.getBlue()) / 3;
        pixel.setRGBA(avg * RED_MULT, avg * GREEN_MULT, avg * BLUE_MULT);
    }

}

image.refresh();
