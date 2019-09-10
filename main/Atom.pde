import java.util.Map;

//HashMap<String, Integer> element_colours = new HashMap<String, Integer>();

IntDict element_colours = new IntDict();

class Atom {
   
   int id;
   String element;
   int molecule_id;
   
   // Current position
   PVector position;
   
   // Store the frame data
   PVector[] frames;
   
   // Calculated on load
   float atom_width = 4;
   float atom_height = 4;
   color colour;
   
   Atom (int atom_id, String atom_element, int atom_molecule_id, float atom_x, float atom_y, float atom_z){
     id = atom_id;
     element = atom_element;
     molecule_id = atom_molecule_id;
     
     // Adds a colour for an element if it doesn't exist - so far just random colours
     
     if (!element_colours.hasKey(element)){
     
       element_colours.set(element, color(int(random(100, 255)), int(random(100, 255)), int(random(100, 255))));
     
     }
     
     colour = element_colours.get(element);
     
     position = new PVector(atom_x, atom_y, atom_z);
     
   }
   
   void setup_frames(int num_frames){
     frames = new PVector[num_frames];
   }
   
   void add_frame(int frame_id, float[] pos){
     frames[frame_id] = new PVector(pos[0], pos[1], pos[2]);
   }
   
   void update(PVector new_position) {
     
     // Could z-value be used to make colours darker?

     position.set(new_position);
     
   }
   
   PVector get_smoothed_position (int start, int window) {
     // Returns the average position over the next "window" of frames
     PVector pos = new PVector(0, 0, 0);
     for (int i = 0; i < window; i ++) {
       pos.add(frames[(start + i) % frames.length]);
     }
     pos.div(window);   
     return pos;
   }
   
   void display(float size)  {
     
     noStroke();
     
     fill(colour, max(0, position.z) + 128); // set min alpha values to 128
     
     ellipse(position.x, position.y,  size, size);
     
   }
}
