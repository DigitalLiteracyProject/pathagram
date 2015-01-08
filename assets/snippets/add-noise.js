var NOISE_LEVEL = 100;

function rand(){
    return Math.random() * NOISE_LEVEL - NOISE_LEVEL / 2;
}

var image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    pixel.setRed(pixel.getRed() + rand());
    pixel.setGreen(pixel.getGreen() + rand());
    pixel.setBlue(pixel.getBlue() + rand());
}

image.refresh();
