void evolve() {
  int m_0 = 1000;
  int n = 10;
  float p = 0.5;
  int k_0 = 4;
  
  ArrayList<Network> population = new ArrayList<Network>();
  
  for (int m = 0; m < m_0; m++) {
    Network new_network = new Network(n, p);
    new_network.create_connections(k_0);
  }
  
  
  
}
