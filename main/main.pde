void setup() {
  
  // Load .crd file
  // Atom[] my_atoms =
  
  // Load .pdb file
  // Frame[] my_frames =
  
  // Need to know (for each frame) order to draw atoms in z-order
  
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

class Atom {
   int id;
   String element;
   int molecule_id;
   float xpos;
   float ypos;
   float zpos;
   
   // Calculated on load
   float atom_width;
   float atom_height;
   float colour;
   
   Atom (int atom_id, String atom_element, int atom_molecule_id, float atom_x, float atom_y, float atom_z){
     id = atom_id;
     element = atom_element;
     molecule_id = atom_molecule_id;
     xpos = atom_x;
     ypos = atom_y;
     zpos = atom_z;  
   }
   
   void display()  {
     
     stroke(0);
     fill(colour);
     ellipse(xpos, ypos, atom_width, atom_height);
     
   }
}


class Frame {
  // Each frame is a list of atom_id, x, y, z co-ordinates in z-dimension order  
  
}
