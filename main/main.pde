// import Sound lib - to install locally, go Sketch->Import Library->Add Library then search 'sound'
import processing.sound.*;

// IMPORTANT - the loading of large files may need an increase in the RAM available to Processing
//     go to - File->Preferences, then check "Increase maximum memory" and set it to 2048

// Declare globals for access in draw
Atom[] my_atoms;
Frame[] my_frames;

int NUM_ATOMS;
int NUM_SIMULATION_ATOMS;

AudioAnalysis analysis;

void setup() {
  
  int i;
  int STEP_SIZE = 3; // decrease to display more atoms
  String[] lines, lineData;
  
  // Load .pdb file
  
  lines = loadStrings("dna260loop.pdb");                    // ['ATOM', atom_id, element, ?, 'X', molecule_id, x, y, z, 0, 0]\n
  println("Loaded Atoms from .pdb! Number of lines: " + lines.length);
  
  // Initialise atoms
  
  NUM_SIMULATION_ATOMS = int(lines.length - 2);
  NUM_ATOMS = int((NUM_SIMULATION_ATOMS - 1) / STEP_SIZE) + 1;
  
  my_atoms = new Atom[NUM_ATOMS];
  
  int atom_id = 0;
  
  //for (i = 1; i < lines.length - 1; i = i + STEP_SIZE) {
  for (i = 0; i < NUM_SIMULATION_ATOMS; i = i + STEP_SIZE) {
    lineData = lines[i + 1].split("\\s+");
    // Use our own ID numbers
    my_atoms[atom_id] = new Atom(atom_id, lineData[2], int(lineData[5]), float(lineData[6]), float(lineData[7]), float(lineData[8]));
    atom_id ++;
  }
  
  println("Using " + NUM_ATOMS + " atoms from simulation (total = " + NUM_SIMULATION_ATOMS + ")");
  
  // Attempt garbage collection to clear memory
  
  lines = new String[1];  // lol
  System.gc();
  
  // Load .crd file
  
  lines = loadStrings("dna260loop.crd");                      // [x, y, z, (atom 1, frame 1)], [x, y, z, atom 2, frame 1], ...
  println("Loaded Frames from .crd! Number of lines: " + lines.length);
  
  // Keep track of frame we are adding data to
  
  //my_frames = new Frame[int(lines.length / 10)];
  int num_frames = 300;
  my_frames = new Frame[num_frames];
  
  Frame current_frame = new Frame(NUM_ATOMS);
  int frame_id = 0;
  atom_id = 0;
  
  float[] current_atom  = new float[3];
  int axis    = 0; // keep track of x, y, z pos we add
  String line = "";
  int atom_counter = 0;
  
  for (i = 1; i < lines.length - 1; i++) {
    
    // Read data; every 3 items are an atom's x,y,z pos    
    line = lines[i];
    
    // Go through each point in the data
    for (int j = 0; j < line.length(); j = j + 8){ // each value is 8 characters of the string
    
      // Append the data
      current_atom[axis] = float(line.substring(j, j + 8));
      
      // When we have 3 axes, create data point and store
      if (axis == 2) {
         
        // only store if the atom will be in 'my_atoms'
        
        if (atom_counter % STEP_SIZE == 0) {
          current_frame.add_data_point(atom_id, current_atom);
          atom_id ++;
        }
        
        // Increase atom counter when we process 3 axis
        atom_counter ++;
        
        // reset axis tracker
        axis = 0;
        
      } else {
        // Increase axis tracker
        axis++;
      }
    }
    
    // When we get to the end of a frame
    if (atom_counter == NUM_SIMULATION_ATOMS) { 
      
      // Sort and store
      current_frame.sort_by_z_axis();
      my_frames[frame_id] = current_frame;
      
      // Next frame_id
      current_frame = new Frame(NUM_ATOMS);
      frame_id++;
      atom_id = 0;
      atom_counter = 0;
      
    }
    
    // Debug purposes, break on x number of frames
    if (frame_id == num_frames){
      print("Finished loading frames!\n");
      break;
    }
    
  }
  
  // Need to know (for each frame) order to draw atoms in z-order - scale z coordinate to z-order ?
  
  // Initialise audio analysis - this == PApplet instance == the sketch
  analysis = new AudioAnalysis(this, 64);
  
  size(960, 540, P3D);
  background(0);
  smooth();
}

void draw() {
  
  background(0);
  
  Frame frame = my_frames[frameCount % 300]; // first 300 frames for debug purposes
  
  for (int i = 0; i < NUM_ATOMS; i++){
    
    // Load data point
    FrameDataPoint dp = frame.data[i];
    
    // Get atom
    Atom atom = my_atoms[dp.atom_id];
    
    // Do transformation of x, y, z based on fft / osc messages
    // e.g. x, y, z = transform(dp.x, dp.y, dp.z)
    atom.update(dp.x, dp.y, dp.z);
    
    // Display
    atom.display();
  }      
}
