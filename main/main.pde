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
  
  // Load .pdb file
  
  lines = loadStrings("dna260loop.pdb");                    // ['ATOM', atom_id, element, ?, 'X', molecule_id, x, y, z, 0, 0]\n
  println("Loaded Atoms from .pdb! Number of lines: " + lines.length);
  
  // Initialise atoms
  
  my_atoms = new Atom[lines.length - 2];
  
  for (i = 1; i < lines.length - 1; i++) {
    lineData = lines[i].split("\\s+");
    my_atoms[i-1] = new Atom(int(lineData[1]), lineData[2], int(lineData[5]), float(lineData[6]), float(lineData[7]), float(lineData[8]));
  }
  
  // Total number of atoms loaded
  
  int num_atoms = my_atoms.length;
  
  // Attempt garbage collection to clear memory
  
  lines = new String[1];  // lol
  System.gc();
  
  // Load .crd file
  
  lines = loadStrings("dna260loop.crd");                      // [x, y, z, (atom 1, frame 1)], [x, y, z, atom 2, frame 1], ...
  println("Loaded Frames from .crd! Number of lines: " + lines.length);
  
  // Keep track of frame we are adding data to
  
  Frame current_frame = new Frame(num_atoms);
  int frame_id = 0;
  
  float[] current_atom  = new float[3];
  int atom_id = 0;
  int axis    = 0; // keep track of x, y, z pos we add
  
  for (i = 1; i < lines.length - 1; i++) {
    
    // Read data; every 3 items are an atom's x,y,z pos
    lineData = lines[i].trim().split("\\s+");
    
    // Go through each point in the data
    for (String s: lineData){
      
      // Append the data
      current_atom[axis] = float(s);
      
      // jsut debugging
      //if (atom_id == num_atoms) {
      //  println("Completed loading atoms from line " + i);
      //}
        
      
      // When we have 3 axes, create data point and store
      if (axis == 2) {
        current_frame.add_data_point(atom_id, current_atom);
        axis = 0;
        atom_id++;
        println("Finished loading atom " + atom_id + " of " + num_atoms + ". Finished: " + str(atom_id == num_atoms));
      } else {
        // Increase axis tracker
        axis++;
      }
    }
    
    // When we get to the end of a frame
    if (atom_id == num_atoms) { 
      
      println("Finished loading frame: " + frame_id);
      
      // Sort and store
      current_frame.sort_by_z_axis();
      my_frames[frame_id] = current_frame;
      
      // Next frame_id
      current_frame = new Frame(num_atoms);
      frame_id++;
      atom_id = 0;      
      
    }
  }
  
  // Need to know (for each frame) order to draw atoms in z-order - scale z coordinate to z-order ?
  
  // Initialise audio analysis - this == PApplet instance == the sketch
  analysis = new AudioAnalysis(this, 64);
  
  size(960, 540);
  background(0);
}

void draw() {
  
  background(0);
  
  // for frame in my_frames
  
      // for atom in my_atoms 
    
          // xyz = frame[atom.id]
          
          // atom.update(xyz);
          
          // atom.display();
          
  for(Atom atom : my_atoms) {
    //atom.update(,,);
    atom.display();
  }
        
}
