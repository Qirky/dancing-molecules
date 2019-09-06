import java.util.Map;

//HashMap<String, Integer> element_colours = new HashMap<String, Integer>();

IntDict element_colours = new IntDict();

class Atom {
   
   int id;
   String element;
   int molecule_id;
   PVector position;
   
   float x_offset = 250; // derive from frames?
   float y_offset = 0;
   
   // Calculated on load
   float atom_width = 3;
   float atom_height = 3;
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
   
   void update(float x, float y, float z) {
     
     // Could z-value be used to make colours darker?

     position.set(x, y, z);
     
   }
   
   void display()  {
     
     noStroke();
     
     fill(colour);
     
     ellipse(position.x * 2 + x_offset, (height / 2) + position.y * 2 + y_offset, atom_width, atom_height);
     
   }
}
