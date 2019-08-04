// import Sound lib - to install locally, go Sketch->Import Library->Add Library then search 'sound'
import processing.sound.*;

// IMPORTANT - the loading of large files may need an increase in the RAM available to Processing
//     go to - File->Preferences, then check "Increase maximum memory" and set it to 2048

// Declare globals for access in draw
Atom[] my_atoms;
Frame[] my_frames;

AudioAnalysis analysis;

void setup() {
  
  int i;
  String[] lines, lineData;
  
  // Load .crd file
  
  lines = loadStrings("dna260loop.crd");
  println("Loaded .crd! Number of lines: " + lines.length);
  my_atoms = new Atom[lines.length];
  for (i = 0 ; i < lines.length; i++) {
    lineData = lines[i].split(" ");
    my_atoms[i] = new Atom(i, "???", 0, 0f, 0f, 0f);
  }
  
  // Attempt garbage collection to clear memory
  
  lines = new String[1];  // lol
  System.gc();
  
  // Load .pdb file
  
  lines = loadStrings("dna260loop.pdb");
  println("Loaded .pdb! Number of lines: " + lines.length);
  my_frames = new Frame[lines.length];
  for (i = 0 ; i < lines.length; i++) {
    lineData = lines[i].split(" ");
    //my_frames[i] = new Frame("???????????");
  }
  
  // Need to know (for each frame) order to draw atoms in z-order
  
  // Initialise audio analysis - this == PApplet singleton instance aka the sketch
  analysis = new AudioAnalysis(this, 64);
  
  size(960, 540);
  background(0);
}

void draw() {
  
  // for frame in my_frames
  
      // for atom in my_atoms 
    
          // xyz = frame[atom.id]
          
          // atom.update(xyz);
          
          // atom.display();
        
}
