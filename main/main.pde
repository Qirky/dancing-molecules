// import Sound lib - to install locally, go Sketch->Import Library->Add Library then search 'sound'
import processing.sound.*;

// IMPORTANT - the loading of large files may need an increase in the RAM available to Processing
//     go to - File->Preferences, then check "Increase maximum memory" and set it to 2048

// Declare globals for access in draw
Atom[] my_atoms;
Frame[] my_frames;

int NUM_ATOMS;             // atoms being drawn
int NUM_SIMULATION_ATOMS;  // Total atoms in .pdb file
int NUM_FRAMES;

// Offset for X and Y location

int WINDOW_WIDTH = 0;
int WINDOW_HEIGHT = 0;

// Vectors to center / enlarge molecule

PVector POSITION_AVG;
PVector POSITION_OFFSET;
float   POSITION_AVG_SIZE;
float   POSITION_SCALAR = 1;
float   POSITION_ZOOM = 1; // percentage to fill window
float   ATOM_SIZE = 1;

// Mappings

float AMPLITUDE;
float AMP_SENS = 8; // Amplitude sensitivity
int SMOOTHING;

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
  
   // TODO -- Get number of frames - can we do this earlier and instantiate atoms with frame array
  
  NUM_FRAMES = 300;
  my_frames = new Frame[NUM_FRAMES];
  // Go through atoms and set up frame array
  for (i = 0; i < NUM_ATOMS; i ++) {
    my_atoms[i].setup_frames(NUM_FRAMES);
  }
  
  // Begin frame setup
  
  Frame current_frame = new Frame(NUM_ATOMS);
  int frame_id = 0;
  atom_id = 0;
  
  String line;
  float[] current_atom  = new float[3];
  int axis              = 0; // keep track of x, y, z pos we add
  int atom_counter      = 0;
  
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
          // Store the atom_id and z-axis point
          current_frame.add_data_point(atom_id, current_atom[2]);
          
          // Add frame data to the atom
          my_atoms[atom_id].add_frame(frame_id, current_atom);
          
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
    
    // TODO -- can we know the number of frames first?
    if (frame_id == NUM_FRAMES){
      print("Finished loading frames!\n");
      break;
    }
    
  }
  
  // Use first frame to get the co-ord scales
  POSITION_AVG = new PVector(0, 0, 0);
  float _min = 0;
  float _max = 0;
  for (i = 0; i < NUM_ATOMS; i++) {
    PVector pos = my_atoms[i].frames[0];
    if (pos.x < _min) {
      _min = pos.x;
    } else 
    if (pos.x > _max) {
      _max = pos.x;
    }
    POSITION_AVG.add(pos);
  }
  POSITION_AVG.div(NUM_ATOMS);
  POSITION_AVG_SIZE = _max - _min;
  
  // Initialise audio analysis - this == PApplet instance == the sketch
  analysis = new AudioAnalysis(this, 64);
  
  // Set up screen
  
  size(960, 540);
  surface.setResizable(true);
  background(0);
  smooth();
  
}

void update_on_resize () {
  
  // Update scalar and offset
  POSITION_SCALAR = (width / POSITION_AVG_SIZE) * POSITION_ZOOM;
  
  // Update offset based on average positions
  POSITION_OFFSET = new PVector(width / 2, height / 2, 128);
  POSITION_OFFSET.sub(POSITION_AVG.copy().mult(POSITION_SCALAR));
  
  ATOM_SIZE = (width / 500 ) * 4 * POSITION_ZOOM;
 
}

void keyPressed() {
  // Press up key
  if (keyCode == 38) {
   POSITION_ZOOM += 0.1;
  }
  // Pressed down key
  else if (keyCode == 40) {
    POSITION_ZOOM -= 0.1;
  }
  else {
    return;
  }
  update_on_resize();
}

void draw() {
  
  // Check for resize
  
  if (WINDOW_WIDTH != width || WINDOW_HEIGHT != height) {
    update_on_resize();
    WINDOW_WIDTH = width; WINDOW_HEIGHT = height;
  }
  
  background(0);
  
  // Get mapping values from audio analysis
  
  AMPLITUDE = (analysis.getAmplitude() * AMP_SENS) + 1;
  SMOOTHING = analysis.getSmoothing();
  
  // Get frame
  int frame_num = frameCount % my_frames.length;
  Frame frame = my_frames[frame_num];
  PVector position;
  
  // Iterate over atoms in z-axis order
  for (int i = 0; i < NUM_ATOMS; i++){
    
    // Load data point
    FrameDataPoint dp = frame.data[i];
    
    // Get atom
    Atom atom = my_atoms[dp.atom_id];
    
    // Do transformation of x, y, z based on fft / osc messages
    position = transform(atom, frame_num);
    
    // Update location of atom
    atom.update(position);
    
    // Display
    atom.display(ATOM_SIZE);
  }      
}

PVector transform (Atom atom, int frame) {
  
  // Do smoothing to x, y, z point
  PVector data = atom.get_smoothed_position(frame, SMOOTHING);
  
  // Do audio analysis transformation here
  
  data.mult(AMPLITUDE);
  
  // Scale size
  
  data.mult(POSITION_SCALAR);
  
  // Center the positions in the display
  
  data.add(POSITION_OFFSET);
  
  return data; 
}
