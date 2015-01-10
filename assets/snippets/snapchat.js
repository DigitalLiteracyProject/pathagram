var image = new TImage("harvard");

// draw box; anchored at top left corner
var boxX = 0;
var boxY = image.getHeight() * 3/4;
var boxWidth = image.getWidth();
var boxHeight = image.getHeight() / 10;
image.setBrushColor(0, 0, 0, 0); // no border
image.setBucketColor(0, 0, 0, 255 / 2); // semi-transparent black
image.rect(boxX, boxY, boxWidth, boxHeight);

// draw text; anchored at center (horizontal), middle (vertical)
var snapText = "Hello Snapchat!";
var textX = image.getWidth() / 2;
var textY = boxY + boxHeight / 2; // centered in box
var textSize = boxHeight * 3/4; // so that it fills up most of the space
image.setTextAlign("center");
image.setTextVerticalAlign("middle");
image.setBrushColor(0, 0, 0, 0); // no border
image.setBucketColor(255, 255, 255, 255); // white
image.setTextSize(textSize);
image.text(snapText, textX, textY);

image.refresh();
