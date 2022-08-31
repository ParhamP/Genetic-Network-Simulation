class Visualization {
  float[][] sphere_points;
  
  Visualization() {
  }
  
  void draw_sphere(Network network) {
     strokeWeight(15);
    stroke(178, 102, 255);
    ArrayList<Node> globe = network.get_nodes();
    int total = globe.size();
    if (sphere_points == null || sphere_points.length != total) {
      sphere_points = generate_all_sphere_points(total);
    }
    
    for (int i = 0; i < total; i++) {
      Node n = globe.get(i);
      int n_value = n.get_value();
      float[] n_position = sphere_points[i];
      n.set_location(n_position);
      
      if (n_value == 0) {
        stroke(202, 51, 255);
      }
      else if (n_value == 1) {
        if (network.is_in_attractor_state()) {
          stroke(51, 249, 255);
        } else {
        stroke(255, 249, 51);
        }
      }
      point(n_position[0], n_position[1], n_position[2]);
    }
  }
  
  void draw_connections(Network network) {
    ArrayList<Node> globe = network.get_nodes();
    strokeWeight(0.8);
    //stroke(202, 51, 255);
    for (int i = 0; i < globe.size(); i++) {
      Node current_node = globe.get(i);
      ArrayList<Signal> current_output_signals = current_node.get_output_signals();
      Iterator<Signal> it = current_output_signals.iterator();
      while (it.hasNext()) {
        Signal current_output_signal = it.next();
        float[] v1 = current_output_signal.get_source_location();
        float[] v2 = current_output_signal.get_target_location();
        if (current_output_signal.get_source_value() == 0) {
          stroke(202, 51, 255);
        } else if (current_output_signal.get_source_value() == 1) {
          if (network.is_in_attractor_state()) {
            stroke(51, 249, 255);
          } else {
            stroke(255, 249, 51);
          }
        }
        line(v1[0], v1[1], v1[2], v2[0], v2[1], v2[2]);
      }
    }
  }
  
  float[][] generate_all_sphere_points(int num_nodes) {
    int total_count = ceil(sqrt((float) num_nodes));
    float[][] res = new float[num_nodes][3];
    float r = 700;
    int point_counter = 0;
    for (int i = 0; i < total_count; i++) {
      float lat = map(i, 0, total_count, 0, PI);
      for (int j = 0; j < total_count; j++) {
        float lon = map(j, 0, total_count, 0, TWO_PI);
        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        res[point_counter][0] = x;
        res[point_counter][1] = y;
        res[point_counter][2] = z;
        point_counter = point_counter + 1;
        if (point_counter >= num_nodes) {
          return res;
        }
      }
    }
    return res;
  }
}
