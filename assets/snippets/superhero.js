image = new TImage("harvard");

image.setBrushColor(0,0,0,100);
image.setBucketColor(255,255,0,30);
var DIAMETER = 8;
var SPACING = 10;

var width = image.getWidth();
var height = image.getHeight();
for (var i = 0; i < width; i++) {
    if (i % SPACING == 0){
        for (var j = 0; j < height; j++) {
            if (j % SPACING == 0){
                image.ellipse(i, j, DIAMETER, DIAMETER);
            }
        }
    }
}

image.refresh();