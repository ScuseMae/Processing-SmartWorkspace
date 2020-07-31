//===========================================================
// AboutApp Class 
//    - Separate class for application description window.
//      A second window is created, on which, users
//      can read about the application and its features
//===========================================================
import controlP5.*;

class AboutWindow extends PApplet 
{
  ControlP5 p5;
  int backgroundColor, w, h;
  PApplet parent;
  PFont aboutFont, aboutFont_Title, aboutFont_Title_Altern;
  Textarea myTextArea;
  
  //---------------
  // Constructor  
  //---------------
  AboutWindow(PApplet _parent, int _w, int _h, String _name) 
  {
    super();
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  //----------------------------------------------
  // Settings() 
  //    - necessary for additional windows 
  //----------------------------------------------
  void settings() 
  {
    size(600, 400);
  }

  //----------------------------------------------
  // Setup() 
  //    - initializes fonts and GUI element for
  //      the AboutApp window
  //----------------------------------------------
  void setup() 
  {
    aboutFont_Title = createFont("Impact", 36);
    aboutFont_Title_Altern = createFont("Zapfino", 30);
    aboutFont = createFont("Palatino", 16);
    cp5 = new ControlP5(this);
    myTextArea = cp5.addTextarea("txt")
                    .setPosition(25, 50)
                    .setSize(550, 275)
                    .setFont(aboutFont)
                    .setLineHeight(14)
                    .setColor(color(255))
                    .setColorBackground(color(255,100))
                    .setColorForeground(color(255,100));
                    ;
    myTextArea.setText("            Your all-in-one workspace, automated by facial recognition  "
                      +"                                                                        "
                      +"                                                                        "
                      +"Background Motion ->  Visual Weather(color/temp, speed/windSpeed)      "
                      +"Bottom Text Area    ->   Your personal notepad                                                  "
                      +"Left Side Bar             ->   Clock, Weather data, Search favorite cities                 "
                      +"Right Side Bar          ->   Open Sketchbook, individual sketches, Settings       "
                      +"Application Tabs      ->   Launch applications you use regularly                                "
                      );
  }
  
  //----------------------------------------------
  // DRAW() 
  //    - draw loop 
  //----------------------------------------------
  void draw() 
  {
    background(color(128, 128, 128));
    fill(255);
    textAlign(CENTER);
    textSize(28);
    textFont(aboutFont_Title);
    text("About iWorkspace", 300, 35);
    textFont(aboutFont);
    textSize(16);
    text("", 200, 65);

    //CloseWindow Button
    rectMode(CENTER);
    noStroke();
    fill(0);
    rect(width/2, height - 35, 100, 30, 4);
    textSize(18);
    textFont(aboutFont);
    textAlign(CENTER);
    fill(255);
    text("Close", width/2, height - 30);
    
    if (mouseX > 250 && mouseX < 350 && mouseY > 353 && mouseY < 383)
    {
      fill(255);
      rect(width/2, height - 35, 100, 30, 4);
      fill(0);
      text("Close", width/2, height - 30);
      cursor(CROSS);
      
      if (mousePressed)
      {
        println("About Window Stopped");
        aboutWindow.stop();
        aboutWindow.stop();
      }
    }
    else
    {
      fill(0);
      rect(width/2, height - 35, 100, 30, 4);
      fill(255);
      text("Close", width/2, height - 30);
      cursor(ARROW);
    }
  }
  
}