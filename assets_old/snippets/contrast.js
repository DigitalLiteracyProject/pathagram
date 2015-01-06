var THRESHOLD;
var RATIO = 0.8;

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
    // set to either darker or lighter
    var pixel = pixels[i];
    if (pixel.getAlpha() > 0) {
        var avg = (pixel.getRed() + pixel.getGreen() + pixel.getBlue()) / 3;
        if (avg < THRESHOLD) {
            pixel.setRed(pixel.getRed() * RATIO);
            pixel.setGreen(pixel.getGreen() * RATIO);
            pixel.setBlue(pixel.getBlue() * RATIO);            
        } else {
            pixel.setRed(pixel.getRed() / RATIO);
            pixel.setGreen(pixel.getGreen() / RATIO);
            pixel.setBlue(pixel.getBlue() / RATIO);  
        }
    }
}

image.refresh();