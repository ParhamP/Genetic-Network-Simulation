import peasy.*;
PeasyCam cam;
import java.util.*;
import java.lang.Math;
Network old_network;
Network network;
float time = 0;
float time_increment = 1;
int k_n = 8;
float p = 0.5;
int k_max = 6; // orig 12
int n_max = 50; // orig 100
int[] first_state;
int attractor_count = 0;
int total;
int seed;
Random generator;
ArrayList<ArrayList<Integer>> S;
ArrayList<ArrayList<ArrayList<Integer>>> attractors;



void setup() {
  size(900, 900, P3D); 
  frameRate(60);
  cam = new PeasyCam(this, 2000);
  cam.rotateX(90);
  //noLoop();
}

void draw() {
  
  if (time == 0) {
    total = 5;
    seed = 1;
    generator = new Random(seed);
    
    old_network = new Network(total, p, k_max, n_max, generator);
    old_network.create_connections(4);
    
    
    network = new Network(old_network);
    
    //println(network.average_sensetivity());
    
    //old_network.nodes.clear();
    
    //S = generate_random_binary_numbers(total, 1000, generator);
    //attractors = network.get_attractors(S);
    
    //println(attractors);
    //println(attractors.size());
    
    Population pop = new Population(k_max, n_max);
    
    pop.initialize_networks(500, 35, 0.5, 4);
    
    pop.evolve();
    
    
}
  
  
  background(0);
  lights();
  
  //String temp_state = network.get_network_state();
  //println(temp_state);
  
  
  draw_sphere(network);
  draw_connections(network);
  if (time % 15 == 0) {
  network.update_state();

  }
  time = time + time_increment;
}

void mousePressed() {
  //ArrayList<ArrayList<Integer>> x = generate_random_binary_numbers(total, 1, generator);
  //ArrayList<Integer> my_state = x.get(0);
  //network.set_node_values(my_state);
  
  //network.gene_duplication_and_divergence();
  
}
