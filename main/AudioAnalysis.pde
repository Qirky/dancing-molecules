class AudioAnalysis {
  AudioIn in;
  Amplitude amp;
  FFT fft;
  int bands;
  float[] spectrum;
  
  AudioAnalysis(PApplet parent, int fft_bands) {
    bands = fft_bands;
    spectrum = new float[bands];
    amp = new Amplitude(parent);
    fft = new FFT(parent, bands);
    in = new AudioIn(parent, 0);
    in.start();
    amp.input(in);
    fft.input(in);
  }
  
  float getAmplitude() {
    return amp.analyze();
  }
  
  float[] getSpectrum() {
    return fft.analyze(spectrum);
  }
  
  int getSmoothing() {
    return 10;
  }
}
