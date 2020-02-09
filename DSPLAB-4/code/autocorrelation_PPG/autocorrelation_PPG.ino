float x[75] = {-87.17307638,-109.5495333,11.00037444,163.4286511,199.1497693,123.5660003,56.25558579,11.87495703,-18.97729813,-42.98507139,-49.50432452,-44.95819516,-33.93206642,-28.58275615,-31.58109989,-41.0802992,-54.49307368,-68.26273259,-80.63560247,-89.53265601,-97.96825536,-104.8688265,-109.0354357,-55.42792547,102.4289065,215.9352907,173.6592794,95.27713062,38.69934301,2.586699113,-27.11808597,-41.50592056,-38.88116345,-27.52106187,-19.43972127,-21.31888102,-29.19861314,-42.08703327,-57.83191118,-69.53303635,-80.46281953,-88.35226795,-94.97094082,-102.2065852,-97.71319214,4.172319927,174.7275931,221.5697151,147.842936,75.61863429,28.48903346,-4.64088307,-29.76995187,-35.85962812,-27.26819387,-12.26373734,-5.602559446,-9.189517172,-21.48116953,-38.07938735,-52.01784737,-63.35879895,-71.93471855,-79.04261272,-85.4265121,-86.88364206,-9.984335526,167.9810654,251.6113399,182.1367896,108.0062751,59.54909365,24.89964724,-5.472668004,-17.77934267
};
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  
  // Moving average filter with number of samples as 'm'
  int y[75];
  int m = 4;
  y[0] = x[0];
  for(int i=1; i<m; i++){
    y[i]= y[i-1] + x[i];
  }
  for(int i=m; i<75; i++){
    y[i] = 0;
    for(int j=0; j<m; j++){
      y[i] += x[i-j];
    }
  }

  // Mean subtraction
  float mean=0;
  for(int i=0; i<75; i++){
    y[i] = y[i]/m;
    mean += y[i];
  }
  mean /= 75;

  for(int i=0;i<75;i++){
    y[i] -= mean;
  }

  // Block Processing
  float per[1];
  float pulse[1];
  for(int blocks=0; blocks<1; blocks++){
    per[blocks]=0;
    pulse[blocks]=0;
    float sig[75];
    float* corr;
    
    
    for(int i=0; i<75; i++){
      sig[i] = y[i+blocks*75];
    }
    
    corr = autocorr(sig, 75);

    int zero=0; float peak=0.0;
    for(int i=0; i<74; i++){
      if(corr[i]>=0 && corr[i+1]<0){
        zero = i;
        break;
      }
    }
    
    int lmax = zero;
    for(int k=zero; k<35; k++){
      if(corr[k]>peak){
        peak = corr[k];
        lmax = k;
      }
    }
    
    per[blocks] = lmax/25.0;
    pulse[blocks] = 60.0 / per[blocks];
    
//    Serial.println(pulse[blocks]);
    
  }
  Serial.println(pulse[0]);
  
}

float* autocorr(float* x, int m){
  float corr[m];
  float energy=0;
  for(int j=0; j<m;j++){
    energy += x[j]*x[j];
  }
  for(int delays=0; delays<m; delays++){
    corr[delays]=0;
    for(int i=0; i<m;i++){
      if(i>=delays)
        corr[delays] += x[i]*x[i-delays];
    }
    corr[delays] /= energy;
  }
  return corr;
}
