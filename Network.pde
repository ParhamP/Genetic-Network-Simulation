class Network {
  //float r;
  Integer total;
  float p;
  ArrayList<Node> nodes;
  int k;
  float r = 700;
  ArrayList<int[]> states;
  ArrayList<Integer> state_attractor_numbers;
  
  Network() {
  }
  
  Network(Integer num_nodes, float bias) {
      total = num_nodes;
      p = bias;
      nodes = create_sphere();
      states = new ArrayList<int[]>();
      state_attractor_numbers = new ArrayList<Integer>();
  }
  
  ArrayList<Node> get_nodes() {
    return nodes;
  }
  
  ArrayList<Node> create_sphere() {
    ArrayList<Node> globe = new ArrayList<Node>();
     int total_count = ceil(sqrt(total.floatValue()));
     int add_count = 0;
     int miss_count = 0;
    for (int i = 0; i < total_count; i++) {
      float lat = map(i, 0, total_count, 0.1, PI);
      for (int j = 0; j < total_count; j++) {
        float lon = map(j, 0, total_count, 0.1, TWO_PI);
        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        Node current_node = new Node(x, y, z, p);
        if (globe.contains(current_node)) {
          miss_count = miss_count + 1;
          println(x);
          println(y);
          println(z);
          println(i);
          println(j);
          println("------------");
          continue;
        }
        globe.add(current_node);
        add_count = add_count + 1;
        if (add_count == total) {
          println("All nodes were added.");
          return globe;
        }
        //total_count = total_count + 1;
        //if (total_count == total) {
        //  return globe;
        //}
       }
     }
     //println(miss_count);
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
  
  int[] update_state() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    int[] results = new int[total];
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
      //int current_value = n1.get_value();
        try {
          n1.calculate_value();
        } catch(Exception e) {
          println(e);
        }
        int current_value = n1.get_value();
        results[i] = current_value;
      }
      return results;
    }
    
  int[] update_state(int[] state) {
    set_node_values(state);
    return update_state();
  }
    
  void set_node_values(int [] state) {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    for (int i = 0; i < total; i++) {
      int current_state_val = state[i]; 
      Node n1 = globe.get(i);
      n1.set_value(current_state_val);
    }
  }
    
    
  float average_sensetivity() {
    return 2 * p * (1 - p) * k;
  }
  
  
  int size() {
    return nodes.size();
  }
  
  int[] get_network_state() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    int[] results = new int[total];
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
      int current_value = n1.get_value();
        results[i] = current_value;
      }
    return results;
  }
  
  ArrayList<ArrayList<Integer>> get_attractors(ArrayList<int[]> S) { // S -> start states
  int currentAttractor = 0;
  ArrayList<ArrayList<Integer>> resultList = new ArrayList<ArrayList<Integer>>();
  
    
    
    
    
    return resultList;
  }
  
  
  void generateAllBinaryStrings(int n,
                            int arr[], int i)
                            {
    if (i == n)
    {
        int[] current_arr = arr.clone();
        states.add(current_arr);
        state_attractor_numbers.add(0);
        return;
    }
    arr[i] = 0;
    generateAllBinaryStrings(n, arr, i + 1);
    arr[i] = 1;
    generateAllBinaryStrings(n, arr, i + 1);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
