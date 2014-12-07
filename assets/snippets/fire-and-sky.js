/**
 * Maps the given ratio onto a new ratio.
 * map(10, 20, 100, 200) = 150 (10/20 = 50%, so pick the number 50% between 100 and 200 => 150)
 */
map = function(x, of, min, max){
    return x/of * (max-min) + min;
}

image = new TImage("harvard");
var pixels = image.getAllPixels();
for (var i = 0; i < pixels.length; i++) {
    var pixel = pixels[i];
    if (pixel.getAlpha() > 0) {
        var avg = (pixel.getRed() + pixel.getGreen() + pixel.getBlue()) / 3;
        var r = map(i, pixels.length, 0.8, 1.2);
        var g = map(i, pixels.length, 1.2, 0.8);
        var b = map(i, pixels.length, 1.5, 0.5);
        pixel.setRGBA(avg * r, avg * g, avg * b);
    }

}

image.refresh();