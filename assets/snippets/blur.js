var RADIUS = 1;

var image = new TImage("harvard");
var width = image.getWidth();
var height = image.getHeight();

for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
        var pixel = image.getPixelAt(i, j);
        // smear by averaging with nearby pixels' values
        var neighbors = [
            image.getPixelAt(i, j)
        ];
        for (var m = i - RADIUS; m <= i + RADIUS; m++) {
            for (var n = j - RADIUS; n <= j + RADIUS; n++) {
                neighbors.push(image.getPixelAt(m, n));
            }
        }
        var sumRed = 0, sumGreen = 0, sumBlue = 0;
        var n = 0;
        for (var k = 0; k < neighbors.length; k++) {
            var neighbor = neighbors[k];
            if (neighbor) {
                n++;
                sumRed += neighbor.getRed();
                sumGreen += neighbor.getGreen();
                sumBlue += neighbor.getBlue();
            }
        }

        pixel.setRGBA(sumRed / n, sumGreen / n, sumBlue / n);
    }
}

image.refresh();
