//===========================================================
// Settings Class 
//    - Separate class for application settings window.
//      A second window is created, on which, users
//      can alter their application settings to their
//      preferences.
//===========================================================
import controlP5.*;

class PWindow extends PApplet 
{
  ControlP5 p5;
  CheckBox checkbox;
  int backgroundColor, w, h;
  PApplet parent;
  PFont buttonFont;
  
  //---------------
  // Constructor  
  //---------------
  PWindow(PApplet _parent, int _w, int _h, String _name) 
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
    size(400, 300);
  }

  //----------------------------------------------
  // Setup() 
  //    - initializes fonts and GUI element for
  //      the Settings window
  //----------------------------------------------
  void setup() 
  {
    buttonFont = createFont("Palatino-Bold", 18);
    background(color(128, 128, 128));
    p5 = new ControlP5(this);
    checkbox = p5.addCheckBox("Settings")
                 .setPosition(50, 40)
                 .setSize(20, 20)
                 .setItemsPerRow(1)
                 .setSpacingColumn(20)
                 .setSpacingRow(20)
                 .addItem("    Digital Clock", 60)
                 .plugTo(parent, "digitalClock_Settings")
                 .addItem("    Stop Background", 100)
                 .plugTo(parent, "stopMotion_Settings")
                 .addItem("    Fonts", 140)
                 .plugTo(parent, "font_Settings")
                 .addItem("    Backgrounds", 180)
                 .plugTo(parent, "fileSelected");
               p5.addNumberbox("Background: Red")
                 .plugTo(parent, "c0")
                 .setRange(0, 255)
                 .setValue(128)
                 .setPosition(250, 40)
                 .setSize(100, 20);
               p5.addNumberbox("Background: Green")
                 .plugTo(parent, "c1")
                 .setRange(0, 255)
                 .setValue(128)
                 .setPosition(250, 80)
                 .setSize(100, 20);  
               p5.addNumberbox("Background: Blue")
                 .plugTo(parent, "c2")
                 .setRange(0, 255)
                 .setValue(128)
                 .setPosition(250, 120)
                 .setSize(100, 20);    
               p5.addNumberbox("Background: Alpha")
                 .plugTo(parent, "c3")
                 .setRange(0, 255)
                 .setValue(128)
                 .setPosition(250, 160)
                 .setSize(100, 20);
  }
  
  //----------------------------------------------
  // Draw()
  //    - draw loop
  //----------------------------------------------
  void draw() 
  {
    //println("mouse_X -> " + mouseX);
    //println("mouse_Y -> " + mouseY);
    background(color(198, 198, 198, 198));
    rectMode(CENTER);
    noStroke();
    fill(0);
    rect(width/2, height - 55, 100, 30, 4);
    textAlign(CENTER);
    fill(255);
    text("Close", width/2, height - 50);
    
    if (mouseX > 150 && mouseX < 250 && mouseY > 234 && mouseY < 263)
    {
      fill(255);
      rect(width/2, height - 55, 100, 30, 4);
      fill(0);
      text("Close", width/2, height - 50);
      cursor(CROSS);
      
      if (mousePressed)
      {
        println("2nd Window Stopped");
        win.stop();
        win.stop();
      }
    }
    else
    {
      fill(0);
      rect(width/2, height - 55, 100, 30, 4);
      fill(255);
      text("Close", width/2, height - 50);
      cursor(ARROW);
    } 
  }
  
  //----------------------------------------------
  // ControlEvent() 
  //    - controls checkbox events  
  //----------------------------------------------
  void controlEvent(ControlEvent theEvent) 
  {
    if (theEvent.isFrom(checkbox)) 
    {
      backgroundColor = 0;
      print("got an event from "+checkbox.getName()+"\t\n");
      println(checkbox.getArrayValue());
      int col = 0;
      
      for (int i=0;i<checkbox.getArrayValue().length;i++) 
      {
        int n = (int)checkbox.getArrayValue()[i];
        print(n);
        
        if(n==1) 
        {
          backgroundColor += checkbox.getItem(i).internalValue();
        }
      }
      println();    
    }
  }

  //----------------------------------------------
  // KeyPressed() 
  //    - allows user to control & deactivate 
  //      checkboxes from the keyboard
  //----------------------------------------------
  void keyPressed()
  {
    if (key == ' ') 
    {
      checkbox.deactivateAll();
    } 
    else 
    {
      for (int i = 0; i < 6 ; i++) 
      {
        if (keyCode==(48 + i)) 
        { 
          checkbox.toggle(i);
          println("toggle " + checkbox.getItem(i).getName());
        }
      }
    }
  }

  //----------------------------------------------
  // CheckBox() - 
  //----------------------------------------------
  void checkBox(float[] a) 
  {
    println(a);
  }

}