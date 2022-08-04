import peasy.*;
PeasyCam cam;
import java.util.*;
import java.lang.Math;
Network network;
float time = 0;
float time_increment = 1;
int k_n = 3;
float p = 0.5;
int[] first_state;
int attractor_count = 0;
int total;
int seed;
Random generator;
ArrayList<String> S;
ArrayList<ArrayList<String>> attractors;



void setup() {
  size(900, 900, P3D); 
  frameRate(60);
  cam = new PeasyCam(this, 2000);
  cam.rotateX(90);


  
  //ArrayList<String> x = generate_binary_strings(10, 500);
  
  //println(x.size());
  
  
  //int[] x = new int[(int) Math.pow(2, 25)];
  
  //for (int i = 0; i < Math.pow(2, 25); i++) {
  //  x[i] = i;
  //}
  
  //println(network.binary_functions_archive);
  //println(network.get_state_attractor("0110"));
  //network.set_state_attractor("0110", 12);
  //println(network.get_state_attractor("0110"));
  //network.set_state_attractor("0110", 4);
  //println(network.get_state_attractor("0110"));
  //println(network.state_attractor_numbers);
  //network = create_sphere(r, total, p);
  //create_connections(network, k_n);
  //evolve();
  //noLoop();
}

void draw() {
  
  if (time == 0) {
    total = 50;
    seed = 2;
    generator = new Random(seed);
    
    
    network = new Network(total, p, generator);
    network.create_connections(k_n);
    
    //Node first_node = network.get_node(3);
    //Node second_node = network.get_node(4);
    //network.connect(second_node, first_node);
    //network.disconnect(network.get_node(2), network.get_node(3));
    //network.disconnect(network.get_node(5), network.get_node(3));
    //first_node.removal_mutation();
    //network.connect(network.get_node(1), network.get_node(4));
    //first_node.additive_mutation();
    //first_node.removal_mutation();
    //first_node.regulatory_mutation(0.99);
    
    //S = generate_binary_strings(total, (int) 1000, generator);
    
    //println(S.size());
  
    //attractors = network.get_attractors(S);
    //println(attractors.size());
    //println(attractors);
    
    
    Population p = new Population(100);
    
    p.initialize_networks(100, 10, 0.5, 4);
    
    p.mutate_population();
    
}
  
  //Population p = new Population(75);
  //p.initialize_networks(1000, 10, 0.5, 4);
  
  //println(p.get_num_networks());
  
  //ArrayList<String> S;
  //if (total <= 10) {
  //  S = generate_binary_strings(total);
  //} else {
  //  S = generate_binary_strings(total, 5000);
  //}
  
  //Network copiedStd = (Network) network.clone();
  //Network cloned_network = new Network(network);
  
  
  //println(S);
  
  
  //println("done");
  //println(S.size());
  
  //println("---------");
  
  
  
  //println(attractors.size());
  //println(attractors);
  
  
  background(0);
  lights();
  
  //String temp_state = network.get_network_state();
  //println(temp_state);
  
  
  draw_sphere(network);
  draw_connections(network);
  
  if (time % 15 == 0) {
  //println("hello");
  network.update_state();
  //println(network_state);
  println(time);

  }
  time = time + time_increment;
  

  if (time == 100) {
  //Node first_node = network.get_node(2);
  //first_node.additive_mutation();
  }
  
  
  
  
  //println("-------------------------");
  
  //println(network.binary_functions_archive);
  
  //network.create_connections(k_n + 1);
  
  //println(network.binary_functions_archive);
  
  //generate_binary_strings(20);
  //println(Integer.toBinaryString(10));
  //ArrayList<String> binaries = new ArrayList<String>();
  
  //String hi = String.format("%4s", Integer.toBinaryString(31)).replace(' ', '0');
  
  //binaries.add(hi);
  
  //println(hi);
  
  //ArrayList<String> res = generate_binary_strings(10);

  
  //int[] a = {1, 0, 0, 1};
  //String aa = Arrays.toString(a);
  //println(aa);
  
  
  
  //double d_k = Math.pow(2, network.size());
  //int k = (int) d_k;
  //int[] arr = new int[k];
  //println(k);
  //network.generateAllBinaryStrings(k, arr, 0);
  
  //println(network.states.size());
  
  //int[] myArr = {1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0};
  
  
  
  //String myArr = "1010110010";
  
  //String updated_myArr = network.update_state(myArr);
  
  //println(updated_myArr); // expected: 0010001110
  //println("-------------------------");
  
  
  //updated_myArr = network.update_state(temp_state);
  //println(updated_myArr);
  
  
  
  //if (time % 1 == 0) {
  //  network.update_all_values();
  //  attractor_count = attractor_count + 1;
  //  if (time == 500) {
  //    first_state = network.get_network_state();
  //    printTheArray(first_state);
  //  } else if (time > 500) {
  //    if (Arrays.equals(first_state, network.get_network_state())) {
  //      println(attractor_count);
  //    }
  //  }
  //}
  
  
  
  //println(network.average_sensetivity());
  
  //Node node_1 = new Node(1.1, 2.2, 3.3, p);

  //println(node_1.get_value());
  //node_1.set_value(1);
  //println(node_1.get_value());
  //Node node_2 = new Node(2.2, 3.3, 4.4, p);
  //Node node_3 = new Node(4.4, 3.3, 5.5, p);
  //Node node_4 = new Node(6.6, 7.7, 3.3, p);
  //Node node_5 = new Node(6.6, 7.7, 3.3, p);
  
  ////node_2.value = 1;
  ////node_3.value = 0;
  
  //println(node_2.value);
  //println(node_3.value);
  //println(node_4.value);
  
  //println("---------------");
  
  //node_1.add_input(node_2);
  //node_1.add_input(node_3);
  //node_1.add_input(node_4);
  //node_1.add_input(node_5);
  //node_1.generate_functions();
  //println(node_1.functions);
  //println(node_1.function_values);
  
  //node_1.generate_functions();
  //ArrayList<int[]> functions = node_1.functions;
  //for (int i = 0; i < functions.size(); i++) {
  //  int[] current_function = functions.get(i);
  //  printTheArray(current_function);
  //}
  // println("---------------");
  //println(node_1.function_values);
  //try {
  //  //println(node_1.value);
  //   println("---------------");
  //  node_1.calculate_value();
  //  println(node_1.value);
  //  } catch(Exception e) {
  //    println(e);
  //  }
  
  //node_2.value = 0;
  //node_3.value = 1;
  //node_4.value = 0;
  //println("---------------");
  //println(node_2.value);
  //println(node_3.value);
  //println(node_4.value);
  // println("---------------");
  
  //try {
  //  println(node_1.calculate_value());
  //  //println(node_1.value);
  //  } catch(Exception e) {
  //    println(e);
  //  }
  
  
  
  //node_1.add_input(node_4);
  //node_1.add_input(node_5);
  //node_1.generate_functions();
  //int node_1_val = -1;
  //try {
  //node_1_val = node_1.calculate_value();
  //} catch(Exception e) {
  //  println(e);
  //}
  //println("---------------");
  //println(node_2.value);
  //println(node_3.value);
  //println(node_4.value);
  //println(node_5.value);
  //println("---------------");
  //println(node_1_val);
  //println("---------------");
  //printArray(node_1.functions);
  //println("---------------");
  //println(node_1.function_values);
}

void mousePressed() {
  //time = time + time_increment;
  //ArrayList<String> x = generate_binary_strings(total, 1, generator);
  //String my_state = x.get(0);
  //network.set_node_values(my_state);
}
