class Population {
  ArrayList<Network> population;
  int n_max;
  
  Population(int max_num_networks) {
    n_max = max_num_networks;
  }
  
  void initialize_networks(int m_0, int n, float p, int k_0) {
    population = new ArrayList<Network>();
    for (int m = 0; m < m_0; m++) {
      Network new_network = new Network(n, p);
      new_network.create_connections(k_0);
    }
  }
  
  
  
  
}
