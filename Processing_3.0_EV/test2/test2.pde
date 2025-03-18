PFont customFont;
PFont customFont2;

void setup() {
  size(800, 600);

  // Replace "YourFontFile.ttf" with your actual font file name and extension
  customFont = createFont("Arial Narrow Italic", 32);
  textFont(customFont);
  text("Forsaking",100,100);
  PFont.list();
}


//void setup() {
//  size(400, 400);
  
//  // Print out all available fonts
//  String[] fonts = PFont.list();
//  for (String font : fonts) {
//    println(font);
//  }
//}
