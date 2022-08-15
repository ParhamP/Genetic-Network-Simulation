class Population {
  ArrayList<Network> population;
  int n_max;
  Random generator;
  int seed;
  float u;
  int k_max;
  ArrayList<HashSet<HashSet<ArrayList<Integer>>>> all_networks_attractors;
  //ArrayList<ArrayList<Integer>> S;
  int min_allowed_num_networks;
  int num_orig_networks;
  
  Population(int max_num_inputs, int max_num_nodes) {
    k_max = max_num_inputs;
    n_max = max_num_nodes;
    u = 0.01;
    seed = 3;
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
  
  void mutate_network(Network network) {
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
      //double num_outputs = (double) node.num_output_connections();
      //double b = generator.nextDouble();
      //double lb = num_outputs * b;
      //int num_affected_targets = round((float) lb);
      int num_affected_targets = node.num_affected_targets(); // double check this
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
  
  ArrayList<ArrayList<Integer>> generate_subsets(int network_size, int amount) {
    //int example_network_size = current_network_size();
    
    ArrayList<ArrayList<Integer>> S =  generate_random_binary_numbers(network_size, amount, generator);
    return S;
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
  
  boolean hashset_contains_attractor(HashSet<ArrayList<Integer>> attractor, HashSet<HashSet<ArrayList<Integer>>> a2) {
    for (HashSet<ArrayList<Integer>> attractor_2 : a2) {
      if (attractor.equals(attractor_2)) {
        return true;
      }
    }
    return false;
  }
  
  boolean a2_contains_a1(HashSet<HashSet<ArrayList<Integer>>> a1,
                                       HashSet<HashSet<ArrayList<Integer>>> a2) {
    if (a1.size() > a2.size()) {
      return false;
    }
    for (HashSet<ArrayList<Integer>> attractor_1 : a1) {
      //println(attractor_1);
      //println(a2);
      //if (!a2.contains(attractor_1)) {
      //  return false;
      //}
      if (!hashset_contains_attractor(attractor_1, a2)) {
        return false;
      }
    }
    return true;
  }
  
  float get_population_average_num_attractors() {
    float total = (float) population.size();
    float count_l = 0;
    for (Network network : population) {
      count_l = count_l + network.attractors.size();
    }
    float res = count_l / total;
    return res;
  }
  
  float get_population_average_num_nodes() {
    float total = (float) population.size();
    float count_l = 0;
    for (Network network : population) {
      count_l = count_l + network.nodes.size();
    }
    float res = count_l / total;
    return res;
  }
  
  float get_population_average_k() {
    float total = 0;
    float count_l = 0;
    for (Network network : population) {
      for (int i = 0; i < network.size(); i++) {
        Node node = network.get_node(i);
        count_l = count_l + node.num_regulators();
        total = total + 1;
      }
    }
    float res = count_l / total;
    return res;
  }
  
  void trim_attractors(HashSet<HashSet<ArrayList<Integer>>> attractors) {
    for (HashSet<ArrayList<Integer>> attractor : attractors) {
      for (ArrayList<Integer> state : attractor) {
        state.remove(state.size() - 1);
      }
    }
  }
  
  ArrayList<ArrayList<Integer>> trim_subsets(ArrayList<ArrayList<Integer>> S) {
    ArrayList<ArrayList<Integer>> trimmed_S =  new ArrayList<ArrayList<Integer>>();
    for (ArrayList<Integer> subset : S) {
      ArrayList<Integer> clone_subset = (ArrayList<Integer>) subset.clone();
      clone_subset.remove(clone_subset.size() - 1);
      trimmed_S.add(clone_subset);
    }
    return trimmed_S;
  }
  
  void evolve() {
    int num_generations_max = 300;
    int num_subsets = 500;
    for (int g_i = 0; g_i < num_generations_max; g_i++) {
      println(g_i);
      ArrayList<Integer> acc_violators = new ArrayList<Integer>();
      for (int i = 0; i < population.size(); i++) {
        Network network = population.get(i);
        ArrayList<ArrayList<Integer>> S = generate_subsets(network.size(), num_subsets);
        HashSet<HashSet<ArrayList<Integer>>> current_pre_attractors =
        network.get_attractors(S);
        mutate_network(network);
        HashSet<HashSet<ArrayList<Integer>>> current_post_attractors =
        network.get_attractors(S);
        //if (!current_pre_attractors.equals(current_post_attractors)) {
        //    acc_violators.add(i);
        //  }
        if (current_post_attractors.size() < current_pre_attractors.size()) { // 
          acc_violators.add(i);
        } else {
          if(!a2_contains_a1(current_pre_attractors, current_post_attractors)) {
          acc_violators.add(i);
          }
        }
      }
      
      //println(acc_violators.size());
      
      
      Collections.sort(acc_violators, Collections.reverseOrder());
      for (int i : acc_violators) {
        population.remove(i);
      }
      
      float average_num_attractors = get_population_average_num_attractors();
      println(average_num_attractors);
      
      float average_num_nodes = get_population_average_num_nodes();
      println(average_num_nodes);
      
      float average_num_k = get_population_average_k();
      println(average_num_k);
      
      
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
      
      //println(population.size());
      
      
      float critic_sum = 0;
      float num_networks = (float) population.size();
      for (Network network : population) {
        critic_sum = critic_sum + network.average_sensetivity();
      }
      float avg_networks_critic = critic_sum / num_networks;
      println(avg_networks_critic);
      
      println(population.size());
      
      ArrayList<Integer> aic_violators = new ArrayList<Integer>();
      if (g_i % 100 == 0) {
        for (int i = 0; i < population.size(); i++) {
          Network network = population.get(i);
          ArrayList<ArrayList<Integer>> post_S = generate_subsets(network.size() + 1, num_subsets);
          ArrayList<ArrayList<Integer>> pre_S = trim_subsets(post_S);
          
          HashSet<HashSet<ArrayList<Integer>>> current_pre_attractors =
          network.get_attractors(pre_S);
          network.gene_duplication_and_divergence();
          HashSet<HashSet<ArrayList<Integer>>> current_post_attractors =
          network.get_attractors(post_S);
          trim_attractors(current_post_attractors);
          if (current_post_attractors.size() <= current_pre_attractors.size()) {
            aic_violators.add(i);
          } else {
            //println(current_pre_attractors);
            //println(current_post_attractors);
            //println(current_pre_attractors.size());
            //println(current_post_attractors.size());
          if(!a2_contains_a1(current_pre_attractors, current_post_attractors)) {
            aic_violators.add(i);
          }
        }
      }
      //println(aic_violators.size());
      Collections.sort(aic_violators, Collections.reverseOrder());
      for (int i : aic_violators) {
        population.remove(i);
      }
    }
    println("________");
  }
}
  
  int get_num_networks() {
    return population.size();
  }
  
}
