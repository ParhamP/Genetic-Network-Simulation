import peasy.*;
PeasyCam cam;
import java.util.*;
Network network;
float time = 0;
float time_increment = 1;
int k_n = 4;
float p = 0.5;


void setup() {
  size(900, 900, P3D); 
  frameRate(40);
  cam = new PeasyCam(this, 2000);
  cam.rotateX(90);
  float r = 700;
  int total = 10;
  network = new Network(r, total, p);
  network.create_connections(k_n);
  //network = create_sphere(r, total, p);
  //create_connections(network, k_n);
}

void draw() {
  time = time + time_increment;
  background(0);
  lights();
  draw_sphere(network);
  draw_connections(network);
  network.update_all_values();
  println(network.average_sensetivity());
  
  //Node node_1 = new Node(1.1, 2.2, 3.3);
  //Node node_2 = new Node(2.2, 3.3, 4.4);
  //Node node_3 = new Node(4.4, 3.3, 5.5);
  //Node node_4 = new Node(6.6, 7.7, 3.3);
  //Node node_5 = new Node(6.6, 7.7, 3.3);
  
  //node_1.add_input(node_2);
  //node_1.add_input(node_3);
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
