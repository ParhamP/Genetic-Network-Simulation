class Network {
  //float r;
  Integer total;
  float p;
  int k_max; // max num of input signals
  int n_max; // max num of nodes
  ArrayList<Node> nodes;
  int k;
  float r = 700;
  HashMap<ArrayList<Integer>, Integer> state_attractor_numbers;
  HashMap<Integer, int[][]> binary_functions_archive;
  Random generator;
  ArrayList<ArrayList<ArrayList<Integer>>> attractors;
  
  Network() {
  }
  
  Network(Integer num_nodes, float bias, int max_num_inputs, int max_num_nodes,
          Random my_generator) {
      generator = my_generator;
      total = num_nodes;
      p = bias;
      k_max = max_num_inputs;
      n_max = max_num_nodes;
      nodes = create_sphere();
      binary_functions_archive = new HashMap<Integer, int[][]>();
      state_attractor_numbers = new HashMap<ArrayList<Integer>, Integer>();
  }
  
  ArrayList<Node> get_nodes() {
    return nodes;
  }
  
  Node get_node(int i) {
    return nodes.get(i);
  }
  
  int get_node_number(Node node) {
    return nodes.indexOf(node);
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
        
        Node current_node = new Node(x, y, z, p, k_max, generator);
        current_node.set_my_network(this);
        
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
          //println("All nodes were added.");
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
  
  void connect(Node node_1, Node node_2) { // node_2 receives input node_1
    node_1.add_output(node_2);
    node_2.add_input(node_1);
  }
  
  void disconnect(Node node_1, Node node_2) { // node_2 was receiving input node_1
    node_1.remove_output(node_2);
    node_2.remove_input(node_1);
  }
  
  
  void create_connections(int k_n) {
    ArrayList<Node> globe = nodes;
    if (!binary_functions_archive.containsKey(k_n)) {
      int[][] function_matrix = generate_binary_matrix(k_n);
      binary_functions_archive.put(k_n, function_matrix);
    }
    int[][] functions = binary_functions_archive.get(k_n);
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
      
      Collections.shuffle(list, generator);
      for (int j = 0; j < k_n; j++) {
        int other_node_index = list.get(j);
        Node n2 = globe.get(other_node_index);
        PVector v2 = n2.get_location();
        float dist = v1.dist(v2);
        if (dist < 1.0) {
          continue;
        }
        //n1.receive_input(n2);// fix this
        connect(n2, n1);
      }
      n1.generate_functions(functions);
    }
    k = k_n;
  }
  
  ArrayList<Integer> update_state() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    //int[] results = new int[total];
    ArrayList<Integer> results = new ArrayList<Integer>();
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
        try {
          n1.calculate_value();
        } catch(Exception e) {
          println(e);
        }
        int current_value = n1.get_value();
        results.add(current_value);
      }
      return results;
    }
    
  ArrayList<Integer> update_state(ArrayList<Integer> state) {
    set_node_values(state);
    return update_state();
  }
    
  void set_node_values(ArrayList<Integer> state) {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    for (int i = 0; i < total; i++) {
      int current_state_val = state.get(i);
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
  
  ArrayList<Integer> get_network_state() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    //int[] results = new int[total];
    ArrayList<Integer> results = new ArrayList<Integer>();
    //String results = "";
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
      int current_value = n1.get_value();
      results.add(current_value);
      //results = results + String.valueOf(current_value);
      }
    return results;
  }
  
  void set_state_attractor(ArrayList<Integer> state, int attractor_num) {
    state_attractor_numbers.put(state, attractor_num);
  }
  
  Integer get_state_attractor(ArrayList<Integer> state) {
    if (state_attractor_numbers.containsKey(state)) {
      Integer attractor_num = state_attractor_numbers.get(state);
      return attractor_num;
    } else {
      return 0;
    }
  }
  
  ArrayList<ArrayList<ArrayList<Integer>>> get_attractors(ArrayList<ArrayList<Integer>> S) {
    ArrayList<Integer> orig_state = get_network_state();
    int currentAttractor = 0;
    ArrayList<ArrayList<ArrayList<Integer>>> resultList = new ArrayList<ArrayList<ArrayList<Integer>>>();
    state_attractor_numbers = new HashMap<ArrayList<Integer>, Integer>();
    for(ArrayList<Integer> startState : S) {
      if (get_state_attractor(startState) == 0) {
        ArrayList<Integer> current = startState;
        currentAttractor = currentAttractor + 1;
        while (get_state_attractor(current) == 0) {
          set_state_attractor(current, currentAttractor);
          current = update_state(current);
        }
        int current_state_attractor = get_state_attractor(current);
        if (current_state_attractor == currentAttractor) {
          ArrayList<Integer> attractorStart = current;
          ArrayList<ArrayList<Integer>> attractor = new ArrayList<ArrayList<Integer>>();
          do {
            attractor.add(current);
            current = update_state(current);
          } while (!current.equals(attractorStart));
          resultList.add(attractor);
        } else {
          ArrayList<Integer> attractorStart = current;
          Integer attractorStartNum = get_state_attractor(attractorStart);
          current = startState;
          while (!current.equals(attractorStart)) {
            set_state_attractor(current, attractorStartNum);
            current = update_state(current);
          }
        }
      }
    }
    set_node_values(orig_state);
    attractors = resultList;
    return resultList;
  }
  
  boolean is_in_attractor_state() {
    ArrayList<Integer> state = get_network_state();
    if (attractors == null || attractors.isEmpty()) {
      return false;
    }
    for (ArrayList<ArrayList<Integer>> s_a : attractors) {
      for (ArrayList<Integer> s : s_a) {
        if (s.equals(state)) {
          return true;
        }
      }
    }
  return false;
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
