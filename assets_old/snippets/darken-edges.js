var DARKEN = 120;

image = new TImage("harvard");
var width = image.getWidth();
var height = image.getHeight();
for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
        var pixel = image.getPixelAt(i, j);
        // darken if closer to edge
        var dx = Math.min(i, width - i);
        var dy = Math.min(j, height - j);
        var dxPercent = dx / width;
        var dyPercent = dy / height;
        var closerDistPercent = Math.min(dxPercent, dyPercent);
        var darken = DARKEN * (0.5 - closerDistPercent);
        
        pixel.setRed(pixel.getRed() - darken);
        pixel.setGreen(pixel.getGreen() - darken);
        pixel.setBlue(pixel.getBlue() - darken);
    }
}

image.refresh();