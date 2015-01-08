var memeTop = "Brace yourselves";
var memeBottom = "The memes are coming";

var image = new TImage("harvard");
image.setBrushColor(0, 0, 0);
image.setBucketColor(255, 255, 255);
image.setTextSize(40);
image.setTextFont("Impact");
image.setTextAlign("center");

image.setTextVerticalAlign("top");
image.text(memeTop.toUpperCase(), image.getWidth() / 2, 0);

image.setTextVerticalAlign("bottom");
image.text(memeBottom.toUpperCase(), image.getWidth() / 2, image.getHeight());

image.refresh();
