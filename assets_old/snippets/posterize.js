var POSTERIZATION = 60;

image = new TImage("harvard");
var pixels = image.getAllPixels();

for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    pixel.setRed(Math.round(pixel.getRed() / POSTERIZATION) * POSTERIZATION);
    pixel.setGreen(Math.round(pixel.getGreen() / POSTERIZATION) * POSTERIZATION);
    pixel.setBlue(Math.round(pixel.getBlue() / POSTERIZATION) * POSTERIZATION);
}

image.refresh();
