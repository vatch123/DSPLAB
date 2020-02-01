// Declaring the input pin where the sensor is connected
int analogPin=A0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  // Declaring the arrays of input, moving average and difference filters 
  float x[500],y[500],z[500];

  // Window size for moving average
  int L=8;

  // Running for all 500 samples
  for(int i=0; i<500; i++){

    // Reading the sensor
    x[i] = analogRead(analogPin);
    delay(10);

    // Moving Average and Difference
    y[i]=0;
    for(int j=0;j<L;j++)
    {
      if(i-j>=0)
        y[i]+=x[i-j];
    }
    if(i==0 || i==1)
      z[i]=0;
    else
      z[i]=y[i]-y[i-2];

    // Showing all the signals 
    Serial.print(x[i]);
    Serial.print(",");
    Serial.println((y[i]/L)+500);
    Serial.print(",");
    Serial.println((z[i]/L)+300);
  }
  
}
