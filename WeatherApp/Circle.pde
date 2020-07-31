//===========================================================
// Circle Class 
//    - Separate class for creating circle visualizations
//      for background of application. Circle color, 
//      speed, and alpha level are determined by data
//      from a current city's weather values.
//      (e.g. Hot(red),Cold(blue), WindSpeed-High(Fast Motion),
//            WindSpeed-Low(Slow Motion), etc.)
//===========================================================

class Circle
{
  float radius;
  float xPosition, yPosition;
  float xSpeed, ySpeed;
  float colorTemp;
  float direction;
  float humidity;
  
  //---------------
  // Constructor  
  //---------------
  Circle(float radi, float windSpd, float temp, float windDir, float humid)
  {
    radius = radi;
    xSpeed = windSpd;
    ySpeed = windSpd;
    colorTemp = temp;
    direction = windDir;
    humidity = humid;
    xPosition = random(width);
    yPosition = random(height);
  }
  
  //----------------------------------------------
  // Move() 
  //    - enables animation/movement of background
  //      circles
  //----------------------------------------------
  void move()
  {
    xPosition += xSpeed/2;
    yPosition += ySpeed/2;
    
    if (xPosition > width || xPosition < 0)
    {
      xSpeed *= -1;
    }
    
    if (yPosition > height || yPosition < 0)
    {
      ySpeed *= -1;
    }
  }
  
  //----------------------------------------------
  // Display() 
  //    - displays the circles  
  //----------------------------------------------
  void display()
  {
    noStroke();
    smooth();
    int colors = getColor((int)colorTemp);
    humidity = random(humidity-5,humidity+5);
    fill(colors, humidity);
    ellipse(xPosition, yPosition, radius, radius);
  }
  
  //----------------------------------------------
  // GetColor() 
  //    - sets circle color based on the range 
  //      of temperature from the YahooWeather
  //      library
  //----------------------------------------------
  int getColor(int colors)
  {
    if (colorTemp >= 80 && colorTemp <= 100)
    {
      colorTemp = color(random(175,255), 0, 0);
    }
    else if (colorTemp >= 60 && colorTemp < 80)
    {
      colorTemp = color(255, random(110, 150),0);
    }
    else if (colorTemp >= 40 && colorTemp < 60)
    {
      colorTemp = color(random(190,225), random(175, 250),0);
    }
    else if (colorTemp >= 20  && colorTemp < 40)
    {
      colorTemp = color(random(0, 138), 255, random(0, 244));
    }
    else if (colorTemp >= 0 && colorTemp < 20)
    {
      colorTemp = color(random(0, 5), random(0, 180), 255); 
    }
    return colors;
  }
  
  //----------------------------------------------
  // StopMotion() 
  //    - function to stop circle motion if user
  //      chooses to do so 
  //----------------------------------------------
  void stopMotion()
  {
    radius = 0;
    xSpeed = 0;
    ySpeed = 0;
    colorTemp = 0;
    direction = 0;
    humidity = 0;
    xPosition = 0;
    yPosition = 0;
  }

}