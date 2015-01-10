var RADIUS = 1;
var SHARPNESS = 2.5;

var image = new TImage("harvard");
var width = image.getWidth();
var height = image.getHeight();

for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
        var pixel = image.getPixelAt(i, j);

        // get average of neighbors' values
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

        // make this pixel diverge more from its neighbors to increase sharpness
        var baseRed = sumRed / n;
        var baseGreen = sumGreen / n;
        var baseBlue = sumBlue / n;
        var red = pixel.getRed();
        var blue = pixel.getBlue();
        var green = pixel.getGreen();

        pixel.setRGBA(
	        (red - baseRed) * SHARPNESS + baseRed,
	        (green - baseGreen) * SHARPNESS + baseGreen,
	        (blue - baseBlue) * SHARPNESS + baseBlue
        );
    }
}

image.refresh();
