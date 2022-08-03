class Population {
  ArrayList<Network> population;
  int n_max;
  Random generator;
  int seed;
  float u;
  
  Population(int max_num_networks) {
    n_max = max_num_networks;
    u = 0.01;
    seed = 1;
    generator = new Random(seed);
  }
  
  void initialize_networks(int m_0, int n, float p, int k_0) {
    population = new ArrayList<Network>();
    for (int m = 0; m < m_0; m++) {
      Network new_network = new Network(n, p, generator);
      new_network.create_connections(k_0);
      population.add(new_network);
    }
  }
  
  //void mutate_population() {
  //  for (Network network : population) {
  //    ArrayList<Node> nodes = network.get_nodes();
  //    for (Node node : nodes) {
  //      LinkedHashSet<Signal> output_signals = node.get_output_signals();
  //      Iterator<Signal> it = output_signals.iterator();
  //      while (it.hasNext()) {
  //        Signal current_signal = it.next();
  //        Node target = current_signal.get_target();
  //        target.regulatory_mutation(u);
          
  //      }
  //    }
  //  }
  //}
  
  
  int get_num_networks() {
    return population.size();
  }
  
}
