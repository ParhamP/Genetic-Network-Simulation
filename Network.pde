class Network {
  float r;
  int total;
  float p;
  ArrayList<Node> nodes;
  int k;
  
  Network() {
  }
  
  Network(float radius, int num_nodes, float bias) {
      r = radius;
      total = num_nodes;
      p = bias;
      nodes = create_sphere();
  }
  
  ArrayList<Node> get_nodes() {
    return nodes;
  }
  
  ArrayList<Node> create_sphere() {
    ArrayList<Node> globe = new ArrayList<Node>();
    for (int i = 0; i < total; i++) {
      float lat = map(i, 0, total, 0, PI);
      for (int j = 0; j < total; j++) {
        float lon = map(j, 0, total, 0, TWO_PI);
        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        Node current_node = new Node(x, y, z, p);
        if (globe.contains(current_node)) {
          continue;
        }
        globe.add(current_node);
       }
     }
     return globe;
  }
  
  void create_connections(int k_n) {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
      PVector v1 = n1.get_location();
      // choose k_n random nodes
      ArrayList<Integer> list = new ArrayList<Integer>();
      for (int k = 0; k < total; k++) {
        if (k == i) {
          continue;
        }
        list.add(k);
      }
      Collections.shuffle(list);
      for (int j = 0; j < k_n; j++) {
        int other_node_index = list.get(j);
        Node n2 = globe.get(other_node_index);
        PVector v2 = n2.get_location();
        float dist = v1.dist(v2);
        if (dist < 1.0) {
          continue;
        }
        n1.add_input(n2);
      }
      n1.generate_functions();
    }
    k = k_n;
  }
  
  
  void update_all_values() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
      //int current_value = n1.get_value();
        try {
          n1.calculate_value();
        } catch(Exception e) {
          println(e);
        }
      }
    }
    
  float average_sensetivity() {
    return 2 * p * (1 - p) * k;
  }
}
