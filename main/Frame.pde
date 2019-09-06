class Frame {
  
  FrameDataPoint[] data;
  int atom_count;
  
  Frame (int max_size){
    atom_count = 0;
    data = new FrameDataPoint[max_size];
  }
  
  // Each frame is a list of atom_id, x, y, z co-ordinates in z-dimension order  
    void add_data_point(int atom, float[] pos_data){
    
    data[atom_count] = new FrameDataPoint(atom, pos_data);
    atom_count++;
  
  }
  
  void sort_by_z_axis() {
    // Sort 'data' by z_axis (see FrameDataPoint.compareTo())
    java.util.Arrays.sort(data);
  }
  
  int size(){
    return atom_count;
  }
}

class FrameDataPoint implements Comparable<FrameDataPoint>{
  int atom_id;
  float x;
  float y;
  float z;
  
  FrameDataPoint (int atom, float[] pos) {
    atom_id = atom;
    x = pos[0];
    y = pos[1];
    z = pos[2];
  }
  
  @Override int compareTo(FrameDataPoint point) {
    // could probably done with something like int(point.z - z)
    if (point.z < z) {
      return 1;
    }
    else if (point.z > z) {
      return -1;
    }
    else {
      return 0;
    }
  }
}
