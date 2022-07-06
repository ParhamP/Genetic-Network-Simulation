
void draw_sphere(Network network) {
  ArrayList<Node> globe = network.get_nodes();
  strokeWeight(15);
  int total = globe.size();
  stroke(178, 102, 255);
  for (int i = 0; i < total; i++) {
    Node n = globe.get(i);
    PVector v = n.get_location();
    int n_value = n.get_value();
    if (n_value == 0) {
      //stroke(227, 104, 104);
      stroke(202, 51, 255);
    }
    else if (n_value == 1) {
      //stroke(82, 179, 235);
      stroke(255, 249, 51);
    }
    point(v.x, v.y, v.z);
  }
}

void draw_connections(Network network) {
  ArrayList<Node> globe = network.get_nodes();
  strokeWeight(0.8);
  //stroke(202, 51, 255);
  for (int i = 0; i < globe.size(); i++) {
    Node current_node = globe.get(i);
    LinkedHashSet<Signal> current_output_signals = current_node.get_output_signals();
    Iterator<Signal> it = current_output_signals.iterator();
    while (it.hasNext()) {
      Signal current_output_signal = it.next();
      PVector v1 = current_output_signal.get_source_location();
      PVector v2 = current_output_signal.get_target_location();
      if (current_output_signal.get_source_value() == 0) {
        //stroke(227, 104, 104);
        stroke(202, 51, 255);
      } else if (current_output_signal.get_source_value() == 1) {
        //stroke(82, 179, 235);
        stroke(255, 249, 51);
      }
      line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
    }
  }
}
