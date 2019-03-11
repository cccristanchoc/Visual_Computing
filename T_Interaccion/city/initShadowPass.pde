public void initShadowPass() {
  shadowMap = createGraphics(720, 600, P3D);
  String[] vertSource = {
    "uniform mat4 transform;", 

    "attribute vec4 vertex;", 

    "void main() {", 
    "gl_Position = transform * vertex;", 
    "}"
  };
  String[] fragSource = {

    // In the default shader we won't be able to access the shadowMap's depth anymore,
    // just the color, so this function will pack the 16bit depth float into the first
    // two 8bit channels of the rgba vector.
    "vec4 packDepth(float depth) {", 
    "float depthFrac = fract(depth * 255.0);", 
    "return vec4(depth - depthFrac / 255.0, depthFrac, 1.0, 1.0);", 
    "}", 

    "void main(void) {", 
    "gl_FragColor = packDepth(gl_FragCoord.z);", 
    "}"
  };
  shadowMap.noSmooth(); // Antialiasing on the shadowMap leads to weird artifacts
  //shadowMap.loadPixels(); // Will interfere with noSmooth() (probably a bug in Processing)
  shadowMap.beginDraw();
  shadowMap.noStroke();
  shadowMap.shader(new PShader(this, vertSource, fragSource));
  shadowMap.ortho(-200, 200, -200, 200, 10, 400); // Setup orthogonal view matrix for the directional light
  shadowMap.endDraw();
}
