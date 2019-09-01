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
   
   void update(float x, float y, float z) {
     
   }
   
   void display()  {
     
     stroke(0);
     fill(colour);
     ellipse(xpos, ypos, atom_width, atom_height);
     
   }
}
