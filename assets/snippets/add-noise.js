var NOISE_LEVEL = 100;

var rand = function(){
    return Math.random() * NOISE_LEVEL - NOISE_LEVEL / 2;
}

image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    pixel.setRed(pixel.getRed() + rand());
    pixel.setGreen(pixel.getGreen() + rand());
    pixel.setBlue(pixel.getBlue() + rand());
}

image.refresh();
