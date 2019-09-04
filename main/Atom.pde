class Atom {
   
   int id;
   String element;
   int molecule_id;
   PVector position;
   
   // Calculated on load
   float atom_width = 1;
   float atom_height = 1;
   color colour = color(255,255,255);
   
   Atom (int atom_id, String atom_element, int atom_molecule_id, float atom_x, float atom_y, float atom_z){
     id = atom_id;
     element = atom_element;
     molecule_id = atom_molecule_id;
     position = new PVector(atom_x, atom_y, atom_z);
   }
   
   void update(float x, float y, float z) {
     position = new PVector(x, y, z);
   }
   
   void display()  {
     
     stroke(255);
     fill(colour);
     ellipse(position.x * 2, (-height / 2) + position.y * 2, atom_width, atom_height);
     
   }
}
