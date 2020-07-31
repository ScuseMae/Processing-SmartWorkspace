//===================================================================
// Name:          Marcus Giarrusso
// Class:         Creative Code
// Date:          Wednesday, May 9th, 2018
// Description:   Part 2 - Workspace:
//                  Once FaceRec app runs and recognizes user/person,
//                  it calls to launch this application - along with
//                  the recognized users prefered settings, sketchbook,
//                  sketches, notes, images, favorite applications, etc. 
//                  All of which they can change in settings
//===================================================================
import com.onformative.yahooweather.*;  // **Looks like this is no longer supported (need to find alternative)
import controlP5.*;
import g4p_controls.*;
import java.io.File;
import java.awt.Font;
import java.awt.*;

//----------------
//Global Variables
//----------------
int windowX = 1440;  
int windowY = 795;
int sideBarX = 200;
int sideBarY = 795;
int mouseClicks = 0;

//OpenApplications
int openApplicationY = 645;
int openApplicationSizeX = 100;
int openApplicationSizeY = 50;
int noteAppX = 0;
int browserAppX = 100;
int calendarAppX = 200;
int dashAppX = 300;
int mailAppX = 400;
int photoAppX = 500;
int adobeAppX = 600;
int aboutAppX = 700;

//Settings Control 
float c0, c1, c2, c3;
String printTest;
boolean stopMotion_Settings;
boolean digitalClock_Settings;
String font_Settings;

//Buttons
int sketchButton_X = 1265;
int sketchButton_Y = 25;
int sketchButton_SizeX = 150;
int sketchButton_SizeY = 40;
int sketchButton_TextX = 1285;
int sketchButton_TextY = 48;

//Left Button_RollOver
int buttonX = 25; 
int buttonY = 500;
int buttonSizeX =  150;
int buttonSizeY = 40;
boolean callMethodOnce = true;

//Right Button_RollOver
int rightButtonX = 725;
int rightButtonY = 25;
int rightButtonSizeX = 150;
int rightButtonSizeY = 40;

//SettingsIcon
PImage settingsIcon;
int settingsIconX = 1300;
int settingsIconY = 530;
int settingsIconSizeX = 80;
int settingsIconSizeY = 80;
PImage wallpaper;
PImage wallpaper2;
int toggle = 0;

//Clock
int clockX, clockY;
float secondRadius;
float minuteRadius;
float hourRadius;
float clockDiameter;
PFont digitalCLockFont;
PFont monthDay;
PFont font, personalMsg;

//YahooWeather (**Looks like this is no longer supported (need to find alternative))
YahooWeather weather;
int updateInterval_Ms = 30000;
int WOEID;
float windSpeed;
float windDirection;
String correctWindDirection;
float temperature;
float humidity;

//CitySearchField
ControlP5 cp5, searchField;
String textValue = "";

//NotePad
GTextField notePad;
String[] text;
String fileName = "WeatherAppNotes.txt";

//DropListView
DropdownList dropList;
Println console;
int c = 0;
PFont pFont, pFont2;

Process process;  // ** Better to use ProcessBuilder?? 
PWindow win;
AboutWindow aboutWindow;
File selected;
Circle[] circle = new Circle[100];
Rectangle[] rectangle = new Rectangle[100];

//----------------------------------------------
// settings() 
//    - Necessary for additional windows
//----------------------------------------------
public void settings()
{
  size(1440, 795);
}

//----------------------------------------------
// SETUP() 
//    - initializes various variables, visual,
//      and gui elements
//----------------------------------------------
void setup()
{ 
  //Load_SettingsIcon
  settingsIcon = loadImage("settings1.png");
  settingsIcon.resize(settingsIconSizeX, settingsIconSizeY);
  
  //Initial_background
  c0 = 198;
  c1 = 198;
  c2 = 198;
  c3 = 198;
  
  //Initial_Font, Initial_Weather WOEID
  monthDay = createFont("Palatino-Bold", 40);
  updateWeather(2503418);
  
  //NotePad
  notePad = new GTextField(this, 0, height - 120, width, 120);
  notePad.setLocalColorScheme(15);
  notePad.setFont(FontManager.getFont("Palatino", 63, 20));
  text = loadStrings(fileName);
  if (text != null) 
  {
    notePad.setText(text[0]);
    println(text[0]);
  }
  
  //DropList_View
  cp5 = new ControlP5(this);
  pFont = createFont("Palatino-Bold", 22);
  dropList = cp5.addDropdownList("  Sketches")
                .setPosition(width - 200, 100)
                .setSize(200, 400);
  customize(dropList); 

  //Clock
  int clockRadius = 75;
  secondRadius = clockRadius * 0.72;
  minuteRadius = clockRadius * 0.60;
  hourRadius = clockRadius * 0.50;
  clockDiameter = clockRadius * 1.8;
  clockX = 100;
  clockY = 75;
  digitalCLockFont = createFont("Palatino-Bold", 40);
  
  //Search_Weather
  cp5 = new ControlP5(this);
  searchField = new ControlP5(this);
  font = createFont("Palatino-Bold", 16);
  searchField.addTextfield("   Search City")
    .setLabelVisible(false)
    .setPosition(25,205)
    .setSize(150,25)
    .setFont(font)
    .setFocus(true)
    .setColor(color(0))
    .setColorActive(color(255))
    .setColorBackground(color(255))
    .setColorCursor(color(0))
    .setText("     Search Area")
    .setAutoClear(true);
    ;
    
  //Circle_Class, Rectangle_Class
  for (int i = 0; i < circle.length; i++)
  {
    circle[i] = new Circle(random(100), getWindMPH()/PI, getTemp(), getWindDir(), getHumid());
    rectangle[i] = new Rectangle(random(100), getWindMPH()/PI, getTemp(), getWindDir(), getHumid());
  }
}

//----------------------------------------------
// Customize() 
//    - custoizes dropList view for users 
//      sketches
//----------------------------------------------
void customize(DropdownList list) 
{
    list.setBackgroundColor(color(190));
    list.setItemHeight(30);
    list.setBarHeight(50);
    list.setBarVisible(true);
    list.setScrollSensitivity(50);
    list.getCaptionLabel().set("Sketches").setFont(pFont);
    
    for (int i = 0; i < 7; i++)
    {
      list.addItem("Sketch "+i, i);
      
      for (int x = 0; x < 1; x++)
      {
        list.addItem("      >  Play ", x);
      }
    }
    list.setColorBackground(color(60));
    list.setColorActive(color(255, 128));
}

//----------------------------------------------
// Draw() - draw loop 
//----------------------------------------------
void draw()
{
  searchField.get(Textfield.class, "");
  searchField.setVisible(false);

  //Settings window color control
  background(color(c0, c1, c2, c3));
  noStroke();
  
  //Display circles & rectangles
  for (int i = 0; i < circle.length; i++)
  {
    circle[i].display();
    circle[i].move();
    rectangle[i].move();
    rectangle[i].display();
  }
  
  //Personalized Welcome Message
  personalMsg = createFont("Zapfino", 32);
  textFont(personalMsg);
  textAlign(CENTER);
  textAlign(TOP);
  fill(0);
  text("Welcome Marcus, ", 530, 65);
  text("You Handsome Devil You", 465, 125);
  textFont(pFont);
  
  //Opens applications
  openApplications();
  
  //Left sideBar
  if (mouseX <= 180 && mouseY < 690)
  {
    noStroke();
    fill(color(66, 66, 66, 126));
    rect(0, 0, sideBarX, height - 150);
    fill(255);
    ellipseMode(CENTER);
    
    //AnalogClock
    fill(0);
    ellipse(clockX, clockY, clockDiameter, clockDiameter);
    float s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
    float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
    float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
    stroke(255);
    strokeWeight(1);
    line(clockX, clockY, clockX + cos(s) * secondRadius, clockY + sin(s) * secondRadius);
    strokeWeight(2);
    line(clockX, clockY, clockX + cos(m) * minuteRadius, clockY + sin(m) * minuteRadius);
    strokeWeight(4);
    line(clockX, clockY, clockX + cos(h) * hourRadius, clockY + sin(h) * hourRadius);
    strokeWeight(2);
    
    beginShape(POINTS);
    for (int a = 0; a < 360; a+=6) 
    {
      float angle = radians(a);
      float x = clockX + cos(angle) * secondRadius;
      float y = clockY + sin(angle) * secondRadius;
      vertex(x, y);
    }
    endShape();

    //DigitalClock (TODO: Need to Fix)
    if (mousePressed && mouseX > clockX && mouseX < clockX + 100 && mouseY > clockY && mouseY < clockY + 100)
    {
      digitalClock();
    }
    
    //Calendar
    textSize(45);
    textFont(monthDay);
    text("April " + day(), 25, 185);
    
    //SearchField visible with sidebar
    searchField.setVisible(true);
    
    //Display weather data on sidebar
    textSize(16);
    text("City: " + weather.getCityName(), 25, 290);
    text("Humidity: " + round(humidity) + " %", 25, 320);
    text("Wind Speed: " + round(windSpeed/2) + " mph", 25, 350);
    text("Temperature: " + round(temperature) + " F", 25, 380);
    text("Wind Direction: " + getCorrectWindDirection(windDirection), 25, 410);
    
    //Background_Button
    if (mouseX > buttonX && mouseX < buttonX + buttonSizeX && mouseY > buttonY && mouseY < buttonY + buttonSizeY)
    {
      noStroke();
      fill(color(66, 66, 66));
      fill(255);
      text("Backgrounds", 43, 526);
      cursor(CROSS);
      
      if (mousePressed)
      {
        selectInput("Select: ", "fileSelected");
      }
    }
    else
    {
      noStroke();
      rect(buttonX, buttonY, buttonSizeX, buttonSizeY, 4);
      fill(0);
      fill(255);
      text("Backgrounds", 43, 526);
      cursor(ARROW);
    }
  }
  
  //Right_SideBar
  if (mouseX >= width - 200 && mouseY <= 675)
  {
    fill(0);
    noStroke();
    rect(sketchButton_X, sketchButton_Y, sketchButton_SizeX, sketchButton_SizeY, 4);
    fill(255);
    textSize(18);
    text("SketchBook", sketchButton_TextX, sketchButton_TextY);
    
    //Sketchbook_Button
    if (mouseX > 1265 && mouseX < 1415 && mouseY > 25 && mouseY < 65)
    {
      fill(255);
      rect(sketchButton_X, sketchButton_Y, sketchButton_SizeX, sketchButton_SizeY, 4);
      fill(0);
      text("SketchBook", sketchButton_TextX, sketchButton_TextY);
      cursor(CROSS);
      
      if (mousePressed) 
      {
        try
        {
          // Attempts to open a users Processing Projects
          Runtime.getRuntime().exec("open ~/Processing/Projects");
        }
        catch(IOException ioExcept)
        {
          ioExcept.printStackTrace();
          print("Error: Directory not opened");
        }
      }
    }
    else
    {
      fill(0);
      rect(sketchButton_X, sketchButton_Y, sketchButton_SizeX, sketchButton_SizeY, 4);
      fill(255);
      textSize(18);
      text("SketchBook", sketchButton_TextX, sketchButton_TextY);
      cursor(ARROW);
    }
    
    noStroke();
    fill(color(66, 66, 66, 126));
    rect(width - 200, 0, sideBarX, height);
    dropList.setVisible(true);
    
    //settingsIcon Image
    image(settingsIcon, settingsIconX, settingsIconY);
    if (mouseX > settingsIconX && mouseX < settingsIconX + 80 && mouseY > settingsIconY && mouseY < settingsIconY + 80) 
    {
      cursor(CROSS);
      if (mousePressed)
      {
        win = new PWindow(this, 400, 800, "Controls");
        println("Opening new window...");
      }
    } 
  }
  else
  {
    dropList.setVisible(false);
  }
}

//----------------------------------------------
// ControlEvent() 
//    - controls mouse & keyboard events for
//      the notePad, weather searchField, and 
//      dropList 
//----------------------------------------------
void controlEvent(ControlEvent theEvent) 
{ 
  if(theEvent.isAssignableFrom(Textfield.class)) 
  { 
    String eventString = (theEvent.getStringValue());
     
    //WeatherSearch_Events
    if (theEvent.getName().replace(" ", "").equalsIgnoreCase("SearchCity"))
    {
      if (eventString.equalsIgnoreCase("syracuse"))
      {
        WOEID = getWOEID("syracuse");
        updateWeather(WOEID);
      }
      else if (eventString.equalsIgnoreCase("oswego"))
      {
        WOEID = getWOEID("oswego");
        updateWeather(WOEID);
        weather.update();
      }
      else if (eventString.equalsIgnoreCase("florida"))
      {
        WOEID = getWOEID("florida");
        updateWeather(WOEID);
      }
      else if (eventString.equalsIgnoreCase("california"))
      {
        WOEID = getWOEID("california");
        updateWeather(WOEID);
      }
    }
  }
  
  //DropList_Events (TODO: Not fully complete)
  if (theEvent.isFrom(dropList))
  {
    if (theEvent.isController()) 
    {
      println("Controller Clicked : "+theEvent.getController().getValue());
     
      switch ((int)theEvent.getController().getValue())
      {
        case 0 :
          try
          {                          
            // Open Processing Sketch
            process = Runtime.getRuntime().exec("open -a Processing ###PATH TO PROCESSING PROJECT(.PDE) OR DESIRED FILE###");
          }
          catch(IOException ioExcept)
          {
            ioExcept.printStackTrace();
            println("File not executed...;)");
          }
          break;
        case 1 :
          try
          {
            // Run Processing sketch
            process = Runtime.getRuntime().exec("processing-java --sketch= ###PATH TO PROCESSING PROJECT SKETCH FILE### --run");
          }
          catch(IOException ioExcept)
          {
            ioExcept.printStackTrace();
            println("File not executed...;)");
          }
          break;
        case 2 :
          try
          {
            process = Runtime.getRuntime().exec("open -a Processing ###PATH TO PROCESSING PROJECT(.PDE) OR DESIRED FILE###");
          }
          catch(IOException ioExcept)
          {
            ioExcept.printStackTrace();
            println("File not executed...;)");
          }
          break;
        case 3 :
          println("Case 3 :");
          break;
        case 4 :
          try
          {
            process = Runtime.getRuntime().exec("open -a Processing ###PATH TO PROCESSING PROJECT(.PDE) OR DESIRED FILE###");
          }
          catch(IOException ioExcept)
          {
            ioExcept.printStackTrace();
            println("File not executed...;)");
          }
          break;
        case 5 :
          println("case 5 :");
          break;
        case 6 : 
          try
          {
            process = Runtime.getRuntime().exec("open -a Processing ###PATH TO PROCESSING PROJECT(.PDE) OR DESIRED FILE###");
          }
          catch(IOException ioExcept)
          {
            ioExcept.printStackTrace();
            println("File not executed...;)");
          }
          break;
        case 7 :
          println("case 7 :");
          break;
        default :
          println("DropList Crontroller Default_Case");
          break;
      }
    }
  }
}

//----------------------------------------------
// HandleTextEvents() 
//    - handles specific events for saving /
//      writing users notes to a txt file
//----------------------------------------------
void handleTextEvents(GEditableTextControl textcontrol, GEvent event) 
{
  if (textcontrol == notePad && event == GEvent.ENTERED) 
  {
    text = new String[] { notePad.getText() };
    saveStrings(fileName, text);
  }
}

//----------------------------------------------
// CorrectWindDirection() 
//    - returns the normal string form of the
//      basic N, S, E, W, NE, SE, SW, NW               
//      directions from the raw 0-360 deg. form
//      from the Yahoo Lib. 
//----------------------------------------------
String getCorrectWindDirection(float rawWindDirection)
{
  if (rawWindDirection >= 340 && rawWindDirection <= 20)
  {
    correctWindDirection = "N";
  }
  else if (rawWindDirection > 20 && rawWindDirection < 70)
  {
    correctWindDirection = "NE";
  }
  else if (rawWindDirection >= 70 && rawWindDirection <= 110)
  {
    correctWindDirection = "E";
  }
  else if (rawWindDirection > 110 && rawWindDirection < 160)
  {
    correctWindDirection = "SE";
  } 
  else if (rawWindDirection >= 160 && rawWindDirection <= 200)
  {
    correctWindDirection = "S";
  }
  else if (rawWindDirection > 200 && rawWindDirection < 250)
  {
    correctWindDirection = "SW";
  }
  else if (rawWindDirection >= 250 && rawWindDirection <= 290)
  {
    correctWindDirection = "W";
  } 
  else if (rawWindDirection > 290 && rawWindDirection < 340)
  {
    correctWindDirection = "NW";
  }
  return correctWindDirection;
}

//----------------------------------------------
// updateWeather() 
//    - updates weather at setup & when user
//      changes weather location
//----------------------------------------------
void updateWeather(int WOEID)
{
  weather = new YahooWeather(this, WOEID, "c", updateInterval_Ms);
  weather.update();
  windSpeed = getWindMPH();
  windDirection = getWindDir();
  temperature = getTemp();
  humidity = getHumid();
}

//----------------------------------------------
// getTemp() 
//    - getter for weather temperature
//----------------------------------------------
float getTemp()
{
  temperature = weather.getTemperature() * 9/5 + 32;
  return temperature;
}

//----------------------------------------------
// getWindMPH() 
//    - getter for weather windSpeed 
//----------------------------------------------
float getWindMPH()
{
  windSpeed = weather.getWindSpeed();
  return windSpeed;
}

//----------------------------------------------
// getWindDir() 
//    - getter for weather windDirection 
//----------------------------------------------
float getWindDir()
{
  windDirection = weather.getWindDirection();
  return windDirection;
}

//----------------------------------------------
// getHumid() 
//    - getter for weather humidity
//----------------------------------------------
float getHumid()
{
  humidity = weather.getHumidity();
  return humidity;
}

//----------------------------------------------
// getWOEID_City() 
//    - returns unique city WOEID number when
//      user searches location 
//----------------------------------------------
int getWOEID(String city)
{
  switch (city.toLowerCase())
  {
    case "oswego" :
      WOEID = 2466688;
      break;
    case "syracuse" :
      WOEID = 2503418;
      break;
    case "florida" :
       WOEID = 2347568;
       break;
    case "california" :
       WOEID = 2347563;
       break;
    default :
  }
  return WOEID;
}

//----------------------------------------------
// openApplications() 
//    - enables users to launch their favorite
//      or most used applications from inside
//      their workspace
//    - ** Built & Tested on MacOS
// *Future:
//    - enable users to set their own applications
//----------------------------------------------
void openApplications()
{
  //NoteApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(noteAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("Notes", 12, 665);
  if (mousePressed && mouseX > noteAppX && mouseX < noteAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Opens notes in Notes application
      process = Runtime.getRuntime().exec("open -e ###PATH TO NOTES .TXT FILE###");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: NotesNotOpened");
    }
  }
  
  //BrowserApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(browserAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("Browser", 112, 665);
  if (mousePressed && mouseX > browserAppX && mouseX < browserAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Attempts to open Browser 
      process = Runtime.getRuntime().exec("open -a Safari");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: BrowserNotOpened");
    }
  }
  
  //CalendarApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(calendarAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("Calendar", 212, 665);
  if (mousePressed && mouseX > calendarAppX && mouseX < calendarAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Attempts to open Calendar
      process = Runtime.getRuntime().exec("open -a Calendar");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: CalendarNotOpened");
    }
  }
  
  //DashApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(dashAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("DashDocs", 312, 665);
  if (mousePressed && mouseX > dashAppX && mouseX < dashAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Attempts to open Dash application (https://kapeli.com/dash)
      process = Runtime.getRuntime().exec("open -a Dash");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: DashDocsNotOpened");
    }
  }
  
  //MailApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(mailAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("eMail", 412, 665);
  if (mousePressed && mouseX > mailAppX && mouseX < mailAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Attempts to open Mail
      process = Runtime.getRuntime().exec("open -a Mail");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: MailNotOpened");
    }
  }
  
  //PhotosApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(photoAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("Photos", 512, 665);
  if (mousePressed && mouseX > photoAppX && mouseX < photoAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Attempts to open Photos
      process = Runtime.getRuntime().exec("open -a Photos");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: PhotosNotOpened");
    }
  }
  
  //AdobeApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(adobeAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("Adobe", 612, 665);
  if (mousePressed && mouseX > adobeAppX && mouseX < adobeAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    try 
    {
      // Attempts to open GravitDesigner (A free Abode Illustrator-type application)
      process = Runtime.getRuntime().exec("open -a GravitDesigner");
    } 
    catch(IOException ioExcept) 
    {
      ioExcept.printStackTrace();
      println("Error: AdobeNotOpened");
    }
  }
  
  //AboutApp
  fill(color(85, 85, 85));
  stroke(color(c0, c1, c2, c3));
  rect(aboutAppX, openApplicationY, openApplicationSizeX, openApplicationSizeY, 4);
  fill(255);
  textSize(14);
  text("About", 718, 665);
  if (mouseX > aboutAppX && mouseX < aboutAppX + 100 && mouseY < 695 && mouseY > 645)
  {
    cursor(CROSS);
    
    if (mousePressed)
    {
      aboutWindow = new AboutWindow(this, 400, 300, "About iWorkspace");
      println("Opening new window...");
    }
  }
}

//----------------------------------------------
// FileSelected() 
//    - allows user to select image (jpg, png) 
//      file from directory & set it as a
//      background for their workspace
//----------------------------------------------
void fileSelected(File selection) 
{
  if (selection == null) 
  {
    println("Window was closed or the user hit cancel.");
  } 
  else 
  {
    println("User selected " + selection.getAbsolutePath());
    wallpaper = loadImage(selection.getAbsolutePath());
    wallpaper.resize(1440,795);
    background(wallpaper);
  }
}

//----------------------------------------------
// StaticBackground() 
//    - user can choose to have a still
//      background instead of the motion
// *TODO: Need to Fix
//----------------------------------------------
void staticBackground()
{
  //staticBackground = staticBackground(); //in draw (+ stop motion)
}

//----------------------------------------------
// digitalClock() 
//    - displays a digital clock on left sidebar
//      if user chooses do to so
//----------------------------------------------
void digitalClock()
{
  int second = second();
  int minute = minute();
  int hour = hour();
  String am_pm; 
  
  if (hour > 11)
  {
    am_pm = "pm";
  }
  else
  {
    am_pm = "am";
  }
  fill(temperature);
  textFont(digitalCLockFont);
  text(hour + ":" + minute + " " + am_pm, clockX, clockY);
}

//----------------------------------------------
// KeyPressed() 
//    - determines actions based on individual 
//      keys pressed
// *TODO: Need to implement
//----------------------------------------------
//void keyPressed()
//{
//  if (key == 'z' || key == 'Z')
//  {
//  }
//}

//----------------------------------------------
// MousePressed() 
//    - records & keeps track of number of 
//      mousePresses
//----------------------------------------------
void mousePressed()
{
  mouseClicks++;  
  //println("#_MouseClicks -> " + mouseClicks);
}