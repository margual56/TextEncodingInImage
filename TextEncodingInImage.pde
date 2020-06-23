void setup(){
  size(500, 500);
  
  //////////////////ENCODE TEXT INTO IMAGE//////////////////////
  //Change the name of the image to encode the text in
  //Change the name of the file containing the message
  /*PImage img = encode("cat.jpg", "message.txt");
  
  float scale = min(width/img.width, height/img.height);
  
  image(img, 0, 0, img.width*scale, img.height*scale);
  
  img.save("encodedCat.png");*/
  
  //////////////////DECODE TEXT FROM IMAGE//////////////////////
  //Change the name of the image to decode the text from
  String decoded[] = {decode("encodedCat.png")};
  
  //Change the name of the file to write the message in
  saveStrings("decodedMessage.txt", decoded);
  
  println("Finished");
}

void draw(){
  //Because it takes long sometimes, this lets you know that it finishes (flickers)
  /*frameRate(20);
  if(frameCount % 2 == 0)
    background(255, 0, 0);
  else
    background(0, 0, 255);*/
}

PImage encode(String image, String file){
  String text = formatStrings(loadStrings(file));
  
  PImage img = loadImage(image);
  PImage newImg = createImage(img.width, img.height, ARGB);
  
  int total = img.width*img.height;
  
  if(total < text.length()*2){
    println("image too small! Size needed: " + nfc(sqrt(text.length()*2), 2) + " x " + nfc(sqrt(text.length()*8), 2) + " minimum");
    return null;
  }
    
  boolean first = true;  
  int cCount = 0;
  
  println("Beggining image processing");
  img.loadPixels();
  newImg.loadPixels();
  for(int j = 0; j<img.height; j++){
    int index = 0;
    for(int i = 0; i<img.width; i++){
      index = i + j * img.width;
      
      if(cCount>=text.length()-1){
        newImg.pixels[index] = img.pixels[index];
      }else{
        int pos = first?0:1;
        first = !first;
        
        if((i+1)%2 == 0)
          cCount++;
          
        int toEncode = encode(text.charAt(floor(index/2)), pos);
        
        //println(toEncode);
        
        newImg.pixels[index] = compose(img.pixels[index], toEncode);
      }
   println("Progress: " + nfc(index*100/total, 2) + "%");
    }
  }
  
  newImg.updatePixels();
  
  println("Finished image processing");
  
  return newImg;
}

String decode(String image){
  String text = "";
  PImage img = loadImage(image);
  
  String newChar = "";
  
  img.loadPixels();
  for(int j = 0; j<img.height; j++)
    for(int i = 0; i<img.width; i++){
      int index = i + j * img.width;
      
      int a = (int)round(255-alpha(img.pixels[index]));
      
      newChar += Integer.toHexString(a);
        
      if(newChar.length()>=2){
        if(!newChar.equals("00"))
          text += (char)(toInt(newChar));
        
        newChar = "";
      }
    }
    
  return text;
}

int toInt(String c){
  return Integer.parseInt(c, 16);
}

color compose(color c, int encodation){
  return color(red(c), green(c), blue(c), 255-encodation);
}

int encode(char c, int pos){
  String converted = toHex(c);
  
  if(converted.length()==1)
    converted = '0' + converted;
    
  return Integer.parseInt(""+(converted.charAt(pos)), 16);
}

String toHex(char c){
  return Integer.toHexString((int)c);
}

String formatStrings(String text[]){
  String str = "";
  println("Started loading file");
  
  for(int i = 0; i<text.length; i++){
    if(i % 500 == 0)
      println("Progress: " + nfc(i*100/text.length, 2) + "%");
    str += text[i] + '\n';
  }
  println("Finished loading file");
  return str;
}
