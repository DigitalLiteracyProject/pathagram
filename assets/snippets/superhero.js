var DIAMETER = 8;
var SPACING = 10;

var image = new TImage("harvard");
var width = image.getWidth();
var height = image.getHeight();

image.setBrushColor(0,0,0,100);
image.setBucketColor(255,255,0,30);

for (var i = 0; i < width; i++) {
    // draw ellipses at regularly spaced intervals
    if (i % SPACING == 0){
        for (var j = 0; j < height; j++) {
            if (j % SPACING == 0){
                image.ellipse(i, j, DIAMETER, DIAMETER);
            }
        }
    }
}

image.refresh();
