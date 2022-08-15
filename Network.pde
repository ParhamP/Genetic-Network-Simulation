class Network {
  Integer total;
  float p;
  int k_max; // max num of input signals
  int n_max; // max num of nodes
  ArrayList<Node> nodes;
  //int k;
  float r = 700;
  HashMap<Integer, int[][]> binary_functions_archive;
  Random generator;
  float[][] sphere_points;
  int next_sphere_point_index;
  HashSet<HashSet<ArrayList<Integer>>> attractors;
  HashMap<ArrayList<Integer>, Integer> state_attractor_numbers;
  
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
      next_sphere_point_index = 0;
  }
  
  public Network(Network network) {
    this.total = network.total;
    this.p = network.p;
    this.k_max = network.k_max;
    this.n_max = network.n_max;
    ArrayList<Node> new_nodes = new ArrayList<Node>();
    for (Node node : network.nodes) {
      Node new_node = new Node(node, this);
      new_nodes.add(new_node);
    }
    this.nodes = new_nodes;
    for (int i = 0; i < network.nodes.size(); i++) {
      Node old_node = network.nodes.get(i);
      Node new_node = this.nodes.get(i);
      new_node.copy_signals(old_node);
    }
    this.r = network.r;
    this.binary_functions_archive = network.binary_functions_archive;
    this.generator = network.generator;
    float [][] sphere_points_copy = new float[network.sphere_points.length][];
    for(int i = 0; i < network.sphere_points.length; i++) {
      sphere_points_copy[i] = network.sphere_points[i].clone();
    }
    this.sphere_points = sphere_points_copy;
    this.next_sphere_point_index = network.next_sphere_point_index;
    //this.state_attractor_numbers = network.state_attractor_numbers;
    //this.attractors = network.attractors;
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
  
  float[] get_new_node_position() {
    float[] pos = sphere_points[next_sphere_point_index];
    next_sphere_point_index = next_sphere_point_index + 1;
    return pos;
  }
  
  float[][] generate_all_sphere_points() {
    int total_count = ceil(sqrt((float) n_max));
    float[][] res = new float[n_max][3];
    int point_counter = 0;
    for (int i = 0; i < total_count; i++) {
      float lat = map(i, 0, total_count, 1, PI);
      for (int j = 0; j < total_count; j++) {
        float lon = map(j, 0, total_count, 1, TWO_PI);
        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        res[point_counter][0] = x;
        res[point_counter][1] = y;
        res[point_counter][2] = z;
        point_counter = point_counter + 1;
        if (point_counter >= n_max) {
          sphere_points = res;
          return res;
        }
       }
    }
    return res;
  }
  
    ArrayList<Node> create_sphere() {
      generate_all_sphere_points();
      ArrayList<Node> globe = new ArrayList<Node>();
      for (int i = 0; i < total; i++) {
        float[] x_y_z = sphere_points[i];
        float x = x_y_z[0];
        float y = x_y_z[1];
        float z = x_y_z[2];
        Node current_node = new Node(x, y, z, p, k_max, generator);
        current_node.set_my_network(this);
        globe.add(current_node);
      }
      next_sphere_point_index = total;
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
  }
  
  ArrayList<Integer> update_state() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
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
    float avg_k = calculate_average_k();
    return 2 * p * (1 - p) * avg_k;
  }
  
  float calculate_average_k() {
    float k_sum = 0;
    float num_nodes = (float) nodes.size();
    for (Node node : nodes) {
      k_sum = k_sum + node.num_regulators();
    }
    float avg_k = k_sum / num_nodes;
    return avg_k;
  }
  
  float average_gene_expression_variability() {
    // gene expression variability
    float total_alpha = 0;
    float total_count = 0;
    for (HashSet<ArrayList<Integer>> attractor : attractors) {
      for (ArrayList<Integer> state : attractor) {
        float alpha = alpha_fitness(state);
        total_alpha = total_alpha + alpha;
        total_count = total_count + 1;
      }
    }
    float res = total_alpha / total_count;
    return res;
  }
  
  void gene_duplication_and_divergence() {
    int network_size = this.size();
    if (network_size > n_max) {
      return;
    }
    int selected_node_index = getRandomNumber(generator, 0, network_size);
    Node selected_node = nodes.get(selected_node_index);
    float[] duplicated_node_pos = get_new_node_position();
    float x = duplicated_node_pos[0];
    float y = duplicated_node_pos[1];
    float z = duplicated_node_pos[2];
    Node duplicated_node = new Node(x, y, z, p, k_max, generator);
    duplicated_node.set_my_network(this);
    duplicated_node.set_value(selected_node.get_value());
    nodes.add(duplicated_node);
    ArrayList<Signal> selected_input_signals = selected_node.input_signals;
    ArrayList<Integer> selected_input_quantities = selected_node.input_signals_quantities;
    for (int i = 0; i < selected_input_signals.size(); i++) {
      Signal signal = selected_input_signals.get(i);
      Node source = signal.get_source();
      int quantity = selected_input_quantities.get(i);
      for (int j = 0; j < quantity; j++) {
        connect(source, duplicated_node);
      }
    }
    ArrayList<Signal> selected_output_signals = selected_node.output_signals;
    ArrayList<Integer> selected_output_quantities = selected_node.output_signals_quantities;
    for (int i = 0; i < selected_output_signals.size(); i++) {
      Signal signal = selected_output_signals.get(i);
      Node target = signal.get_target();
      int quantity = selected_output_quantities.get(i);
      for (int j = 0; j < quantity; j++) {
        connect(duplicated_node, target);
      }
    }
    Double prob = generator.nextDouble();
    if (prob < 0.5) {
      duplicated_node.regulatory_additive_mutation();
    } else {
      duplicated_node.regulatory_subtractive_mutation();
    }
    int num_affected_targets = duplicated_node.num_affected_targets();
    prob = generator.nextDouble();
    if (prob < 0.5) {
      duplicated_node.coding_additive_mutation(num_affected_targets);
    } else {
      duplicated_node.coding_subtractive_mutation(num_affected_targets);
    }
  }
  
  float alpha_fitness(ArrayList<Integer> state) {
    float num_zeros = 0;
    float num_ones = 0;
    float num_bits = state.size();
    for (int bit : state) {
      if (bit == 0) {
        num_zeros = num_zeros + 1;
      } else {
        num_ones = num_ones + 1;
      }
    }
    float zeros_fraction = num_zeros / num_bits;
    float ones_fraction = num_ones / num_bits;
    float alpha = 0.5 * (1 - Math.abs(ones_fraction - zeros_fraction));
    return alpha;
  }
  
  
  int size() {
    return nodes.size();
  }
  
  ArrayList<Integer> get_network_state() {
    ArrayList<Node> globe = nodes;
    int total = globe.size();
    //int[] results = new int[total];
    ArrayList<Integer> results = new ArrayList<Integer>();
    for (int i = 0; i < total; i++) {
      Node n1 = globe.get(i);
      int current_value = n1.get_value();
      results.add(current_value);
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
  
  HashSet<HashSet<ArrayList<Integer>>> get_attractors(ArrayList<ArrayList<Integer>> S) {
    ArrayList<Integer> orig_state = get_network_state();
    int currentAttractor = 0;
    HashSet<HashSet<ArrayList<Integer>>> resultList =
    new HashSet<HashSet<ArrayList<Integer>>>();
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
          HashSet<ArrayList<Integer>> attractor = new HashSet<ArrayList<Integer>>();
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
    for (HashSet<ArrayList<Integer>> s_a : attractors) {
      for (ArrayList<Integer> s : s_a) {
        if (s.equals(state)) {
          return true;
        }
      }
    }
  return false;
}
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
}
