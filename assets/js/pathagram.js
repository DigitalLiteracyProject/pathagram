$(function(){
    //console.log('Pathagram.js Loaded');
    
    // preload images
    /*
    Tripod.setSources(["../images/elephant.png" ]);
    Tripod.start(function(){
        q = new TImage("../images/elephant.png");
        var pixels = q.getAllPixels();
        for (var i = 0; i < pixels.length; i++)
        {
            // increase brightness
            var rgba = pixels[i].getRGBA();
            pixels[i].setRed(Math.min(rgba[0] * 1.5, 255));
            pixels[i].setGreen(Math.min(rgba[1] * 1.5, 255));
            pixels[i].setBlue(Math.min(rgba[2] * 1.5, 255));     
            
            // contrast is harder. http://stackoverflow.com/questions/10521978/html5-canvas-image-contrast
        }
        q.refresh();
    });
    */
    
    //renderAceEditor();
    
    
    /*
    p = new TImage(100, 100);
    var pixels = p.getAllPixels();
    for (var i = 0; i < pixels.length; i++)
    {
        pixels[i].setRGBA(255, 0, 0, i % 100);
    }
    */
});
/*
function renderAceEditor(){
    // autosave interval
    var autosave_interval = 1000;

    // Render ace editor for HTML editor
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/xcode");
    editor.getSession().setMode("ace/mode/javascript");
    
    $('#run').click(function(){
        var code = editor.getValue();
        try{
            eval(code);
            $('#console').addClass('alert-success').removeClass('alert-danger').html("Success!");
        }
        catch(e){
            console.log(e);
            $('#console').removeClass('alert-success').addClass('alert-danger').html("Line " + e.lineNumber + ": " + e.message);
        }
    });
}
*/
/*
function setPixel(imageData, x, y, r, g, b, a) {
    index = (x + y * imageData.width) * 4;
    imageData.data[index+0] = r;
    imageData.data[index+1] = g;
    imageData.data[index+2] = b;
    imageData.data[index+3] = a;
}

canvas = $("#main-canvas");
canvas.attr('width', 200);
canvas.attr('height', 200);
var context = canvas.get(0).getContext("2d");


// read the width and height of the canvas
width = canvas.get(0).width;
height = canvas.get(0).height;

// create a new pixel array
imageData = context.createImageData(width, height);

// draw random dots
for (i = 0; i < 10000; i++) {
    x = Math.random() * width | 0; // |0 to truncate to Int32
    y = Math.random() * height | 0;
    r = Math.random() * 256 | 0;
    g = Math.random() * 256 | 0;
    b = Math.random() * 256 | 0;
    setPixel(imageData, x, y, r, g, b, 255); // 255 opaque
}

// copy the image data back onto the canvas
context.putImageData(imageData, 0, 0); // at coords 0,0

context.strokeStyle = "#000";
drawEllipseByCenter(context, 50, 50, 30, 30);


// http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas

function drawEllipseByCenter(ctx, cx, cy, w, h) {
  drawEllipse(ctx, cx - w/2.0, cy - h/2.0, w, h);
}

function drawEllipse(ctx, x, y, w, h) {
  var kappa = .5522848,
      ox = (w / 2) * kappa, // control point offset horizontal
      oy = (h / 2) * kappa, // control point offset vertical
      xe = x + w,           // x-end
      ye = y + h,           // y-end
      xm = x + w / 2,       // x-middle
      ym = y + h / 2;       // y-middle

  ctx.beginPath();
  ctx.moveTo(x, ym);
  ctx.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
  ctx.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
  ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
  ctx.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
    
  ctx.stroke();
}
*/