class Population {
  ArrayList<Network> population;
  int n_max;
  Random generator;
  int seed;
  float u;
  int k_max;
  ArrayList<ArrayList<ArrayList<String>>> all_networks_attractors;
  ArrayList<String> S;
  int min_allowed_num_networks;
  
  Population(int max_num_inputs, int max_num_nodes) {
    k_max = max_num_inputs;
    n_max = max_num_nodes;
    u = 0.01;
    seed = 1;
    min_allowed_num_networks = 250;
    generator = new Random(seed);
  }
  
  void initialize_networks(int num_networks, int n, float p, int k_0) {
    if (k_0 > k_max) {
      k_0 = k_max;
    }
    if (n > n_max) {
      n = n_max;
    }
    population = new ArrayList<Network>();
    for (int m = 0; m < num_networks; m++) {
      Network new_network = new Network(n, p, k_max, n_max, generator);
      new_network.create_connections(k_0);
      population.add(new_network);
    }
  }
  
  int size() {
    return population.size();
  }
  
  int current_network_size() {
    Network network_example = population.get(0);
    int network_size = network_example.size();
    return network_size;
  }
  
  void mutate_population() {
    for (Network network : population) {
      ArrayList<Node> nodes = network.get_nodes();
      for (Node node : nodes) {
        // Regulatory Mutation
        int num_regulators = node.num_regulators();
        for (int i = 0; i < num_regulators; i++) {
          Double prob = generator.nextDouble();
          if (prob < (1 - u)) {
            continue;
          } else if (prob < (1 -  (u / 2))) {
            node.regulatory_additive_mutation();
          } else {
            node.regulatory_subtractive_mutation();
          }
        }
        // Coding Mutation
        double num_outputs = (double) node.num_output_connections();
        double b = generator.nextDouble();
        double lb = num_outputs * b;
        int num_affected_targets = round((float) lb);
        Double prob = generator.nextDouble();
        if (prob < (1 - u)) {
          continue;
        } else if (prob < (1 -  (u / 2))) {
          node.coding_additive_mutation(num_affected_targets);
        } else {
          node.coding_subtractive_mutation(num_affected_targets);
        }
      }
    }
  }
  
  void generate_subsets() {
    int example_network_size = current_network_size();
    S = generate_binary_strings(example_network_size, 1000, generator);
  }
  
  ArrayList<ArrayList<ArrayList<String>>> get_all_networks_attractors() {
    all_networks_attractors = new ArrayList<ArrayList<ArrayList<String>>>();
    for (int i = 0; i < population.size(); i++) {
      Network network = population.get(i);
      ArrayList<ArrayList<String>> current_network_attractors = network.get_attractors(S);
      all_networks_attractors.add(current_network_attractors);
    }
    return all_networks_attractors;
  }
  
  void evolve() {
    generate_subsets();
    int num_generations_max = 10;
    for (int g_i = 0; g_i < num_generations_max; g_i++) {
      ArrayList<ArrayList<ArrayList<String>>> pre_attractors = get_all_networks_attractors();
      mutate_population();
      ArrayList<ArrayList<ArrayList<String>>> post_attractors = get_all_networks_attractors();
      ArrayList<Integer> acc_violators = new ArrayList<Integer>();
      //println(pre_attractors.equals(post_attractors));
      //println(pre_attractors.size());
      int count = 0;
      for (int i = 0; i < pre_attractors.size(); i++) {
        ArrayList<ArrayList<String>> current_pre_attractors = pre_attractors.get(i);
        ArrayList<ArrayList<String>> current_post_attractors = post_attractors.get(i);
        if (!current_pre_attractors.equals(current_post_attractors)) {
          count = count + 1;
          acc_violators.add(i);
        }
      }
      Collections.sort(acc_violators, Collections.reverseOrder());
      for (int i : acc_violators) {
        population.remove(i);
      }
      
      if (population.size() < min_allowed_num_networks) {
        
        println(population.size());
      }
      //println(count);
      //println(population.size());
      //for (ArrayList<ArrayList<String>> attractor : post_attractors) {
      //  println(attractor.size());
      //}
    }
  }
  
  int get_num_networks() {
    return population.size();
  }
  
}
