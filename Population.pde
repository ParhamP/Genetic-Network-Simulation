class Population {
  ArrayList<Network> population;
  int n_max;
  Random generator;
  int seed;
  float u;
  int k_max;
  ArrayList<HashSet<HashSet<ArrayList<Integer>>>> all_networks_attractors;
  ArrayList<ArrayList<Integer>> S;
  int min_allowed_num_networks;
  int num_orig_networks;
  
  Population(int max_num_inputs, int max_num_nodes) {
    k_max = max_num_inputs;
    n_max = max_num_nodes;
    u = 0.01;
    seed = 1;
    generator = new Random(seed);
  }
  
  void initialize_networks(int num_networks, int n, float p, int k_0) {
    num_orig_networks = num_networks;
    min_allowed_num_networks = num_orig_networks / 2;
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
  
  void generate_subsets(int amount) {
    int example_network_size = current_network_size();
    S =  generate_random_binary_numbers(example_network_size, amount, generator);
  }
  
  ArrayList<HashSet<HashSet<ArrayList<Integer>>>> get_all_networks_attractors() {
    all_networks_attractors = new ArrayList<HashSet<HashSet<ArrayList<Integer>>>>();
    for (int i = 0; i < population.size(); i++) {
      Network network = population.get(i);
      HashSet<HashSet<ArrayList<Integer>>> current_network_attractors =
      network.get_attractors(S);
      all_networks_attractors.add(current_network_attractors);
    }
    return all_networks_attractors;
  }
  
  boolean a2_contains_a1(HashSet<HashSet<ArrayList<Integer>>> a1,
                                       HashSet<HashSet<ArrayList<Integer>>> a2) {
    if (a1.size() > a2.size()) {
      return false;
    }
    for (HashSet<ArrayList<Integer>> attractor_1 : a1) {
      if (!a2.contains(attractor_1)) {
        return false;
      }
    }
    return true;
  }
  
  void evolve() {
    int num_generations_max = 10;
    for (int g_i = 0; g_i < num_generations_max; g_i++) {
      generate_subsets(500);
      ArrayList<HashSet<HashSet<ArrayList<Integer>>>> pre_attractors =
      get_all_networks_attractors();
      mutate_population();
      ArrayList<HashSet<HashSet<ArrayList<Integer>>>> post_attractors =
      get_all_networks_attractors();
      ArrayList<Integer> acc_violators = new ArrayList<Integer>();
      for (int i = 0; i < pre_attractors.size(); i++) { // looping through networks
        HashSet<HashSet<ArrayList<Integer>>> current_pre_attractors =
        pre_attractors.get(i);
        HashSet<HashSet<ArrayList<Integer>>> current_post_attractors =
        post_attractors.get(i);
        
        //if (!current_pre_attractors.equals(current_post_attractors)) {
        //    acc_violators.add(i);
        //  }
        
        if (current_post_attractors.size() < current_pre_attractors.size()) {
          acc_violators.add(i);
        } else {
          if(!a2_contains_a1(current_pre_attractors, current_post_attractors)) {
          acc_violators.add(i);
          }
        }
      }
      
      Collections.sort(acc_violators, Collections.reverseOrder());
      for (int i : acc_violators) {
        population.remove(i);
      }
      
      //float total = post_attractors.size();
      //float count_l = 0;
      //for (HashSet<HashSet<ArrayList<Integer>>> network_attractors : post_attractors) {
      //  //println(network_attractors.size());
      //  count_l = count_l + network_attractors.size();
      //}
      
      //println(count_l / total);
      
      
      if (population.size() < min_allowed_num_networks) {
        int population_size = population.size();
        float C = 0;
        float[] alphas = new float[population.size()];
        for (int i = 0; i < population_size; i++) {
          Network network = population.get(i);
          float alpha_i = network.average_gene_expression_variability();
          alphas[i] = alpha_i;
          C = C + alpha_i;
        }
        C = 1 / C;
        for (int i = 0; i < population_size; i++) {
          Network network = population.get(i);
          float alpha_i  = alphas[i];
          float m_i_float = C * alpha_i * num_orig_networks;
          int m_i = round(m_i_float);
          for (int j = 0; j < m_i; j++) {
            Network daughter_network = new Network(network);
            population.add(daughter_network);
          }
        }
      }
      
      println(population.size());
      println("-----------");
      
      if (g_i % 2000 == 0) {
        
      }
    }
  }
  
  int get_num_networks() {
    return population.size();
  }
  
}
