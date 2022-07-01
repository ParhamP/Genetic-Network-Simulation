//ArrayList<Node> create_sphere(float r, int total, float p){
//  //randomSeed(1);
//  ArrayList<Node> globe = new ArrayList<Node>();
//  for (int i = 0; i < total; i++) {
//    float lat = map(i, 0, total, 0, PI);
//    for (int j = 0; j < total; j++) {
//      float lon = map(j, 0, total, 0, TWO_PI);
//      float x = r * sin(lat) * cos(lon);
//      float y = r * sin(lat) * sin(lon);
//      float z = r * cos(lat);
//      Node current_node = new Node(x, y, z, p);
//      if (globe.contains(current_node)) {
//        continue;
//      }
//      globe.add(current_node);
//     }
//   }
//  return globe;
//}

//void create_connections(ArrayList<Node> globe, int k_n) {
//  int total = globe.size();
  
//  //float[] min_max_distances = find_min_max_distance();
//  //float minDistance = min_max_distances[0];
//  //float maxDistance = min_max_distances[1];
  
//  for (int i = 0; i < total; i++) {
//    Node n1 = globe.get(i);
//    PVector v1 = n1.get_location();
//    // choose k_n random nodes
//    ArrayList<Integer> list = new ArrayList<Integer>();
//    for (int k = 0; k < total; k++) {
//      if (k == i) {
//        continue;
//      }
//      list.add(k);
//    }
//    Collections.shuffle(list);
//    for (int j = 0; j < k_n; j++) {
//      int other_node_index = list.get(j);
//      Node n2 = globe.get(other_node_index);
//      PVector v2 = n2.get_location();
//      float dist = v1.dist(v2);
//      if (dist < 1.0) {
//        continue;
//      }
      
//      n1.add_input(n2);
      
//      //if (dist > 400) { // makes it deterministic
//      //  continue;
//      //}
//      //float connection_prob = map(dist, minDistance, maxDistance, 1.0, 0.0);
//      //if (connection_prob > distance_length_connection_prob) {
//      //  if (n1.is_inhibitory()) {
//      //    n1.connect_to(n2, -weight);
//      //  } else {
//      //    n1.connect_to(n2, weight);
//      //  }
//      //}
//    }
//    n1.generate_functions();
//  }
//}


//void update_all_values(ArrayList<Node> globe) {
//  int total = globe.size();
//  for (int i = 0; i < total; i++) {
//    Node n1 = globe.get(i);
//    int current_value = n1.get_value(); //<>//
//      try {
//        int new_value = n1.calculate_value();
//      } catch(Exception e) {
//        println(e);
//      }
//    }
//}

//float average_network_sensetivity(int k, float p) {
//  return 2 * p * (1 - p) * k;
//}
