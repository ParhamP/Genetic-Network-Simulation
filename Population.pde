class Population {
  ArrayList<Network> population;
  int n_max;
  Random generator;
  int seed;
  float u;
  int k_max;
  
  Population(int max_num_inputs, int max_num_nodes) {
    k_max = max_num_inputs;
    n_max = max_num_nodes; // orig 100
    u = 0.01;
    seed = 1;
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
  
  int get_num_networks() {
    return population.size();
  }
  
}
