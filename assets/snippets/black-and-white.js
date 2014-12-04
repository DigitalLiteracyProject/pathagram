var THRESHOLD;

image = new TImage("harvard");
var pixels = image.getAllPixels();

// determine threshold
var sum = 0;
var n = 0;
for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    if (pixel.getAlpha() > 0) {
        var avg = (pixel.getRed() + pixel.getGreen() + pixel.getBlue()) / 3;
        sum += avg;
        n++;
    }
}

THRESHOLD = sum / n;

for (var i = 0; i < pixels.length; i++) {
    // make pixel darker or lighter
    var pixel = pixels[i];
    if (pixel.getAlpha() > 0) {
        var avg = (pixel.getRed() + pixel.getGreen() + pixel.getBlue()) / 3;
        if (avg < THRESHOLD) {
            pixel.setRGBA(0, 0, 0);
        } else {
            pixel.setRGBA(255, 255, 255);
        }
    }
}

image.refresh();