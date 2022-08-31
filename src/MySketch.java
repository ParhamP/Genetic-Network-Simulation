import processing.core.*;

import java.io.*;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Random;

public class MySketch extends PApplet {

    float[][] sphere_points;
    Network network;
    Population population;
    float time;
    float w = 900;
    float h = 900;
    Random generator;
//    int total = 100;

    public void settings() {
        size((int) w, (int) h);
        time = 0;
        int seed = 2;
        float p = (float) 0.5;
        int k_max = 12;
        int n_max = 100;
        generator =  new Random(seed);
//        int k_0 = 3;
//        int total = 20;
//        network = new Network(total, p, k_max, n_max, generator);
//        network.initialize_random_connections(k_0);

        import_population("/Users/parhamp/Documents/projects/attractor_evolution/saved_networks/4002.dat"); // 1196
        this.network = population.population.get(generator.nextInt(population.size()));
        println(population.population.size());
    }

    void import_population(String dest) {
        Object obj = new Object();
        try {
            FileInputStream fileIn = new FileInputStream(dest);
            ObjectInputStream objectIn = new ObjectInputStream(fileIn);

            obj = objectIn.readObject();

            System.out.println("The Object has been read from the file");
            objectIn.close();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        Population im_population = (Population) obj;
        this.population = im_population;
    }

    public void draw() {
        background(0);
//        lights();
        draw_sphere(network);
        draw_connections(network);
        if (time % 20 == 0) {
            network.update_state();
        }
        time = time + 1;
    }

    public static void main(String[] args){
        String[] processingArgs = {"MySketch"};
        MySketch mySketch = new MySketch();
        PApplet.runSketch(processingArgs, mySketch);
    }

    void draw_sphere(Network network) {
        strokeWeight(15);
        stroke(178, 102, 255);
        ArrayList<Node> globe = network.get_nodes();
        int total = globe.size();
        if (sphere_points == null || sphere_points.length != total) {
            sphere_points = generate_all_circle_points(total);
        }

        for (int i = 0; i < total; i++) {
            Node n = globe.get(i);
            int n_value = n.get_value();
            float[] n_position = sphere_points[i];
            n.set_location(n_position);

            if (n_value == 0) {
                stroke(202, 51, 255);
            }
            else if (n_value == 1) {
                if (network.is_in_attractor_state()) {
                    stroke(51, 249, 255);
                } else {
                    stroke(255, 249, 51);
                }
            }
            point(n_position[0], n_position[1]);
        }
    }

    void draw_connections(Network network) {
        ArrayList<Node> globe = network.get_nodes();
        strokeWeight((float) 0.8);
        //stroke(202, 51, 255);
        for (int i = 0; i < globe.size(); i++) {
            Node current_node = globe.get(i);
            ArrayList<Signal> current_output_signals = current_node.get_output_signals();
            Iterator<Signal> it = current_output_signals.iterator();
            while (it.hasNext()) {
                Signal current_output_signal = it.next();
                float[] v1 = current_output_signal.get_source_location();
                float[] v2 = current_output_signal.get_target_location();
                if (current_output_signal.get_source_value() == 0) {
                    stroke(202, 51, 255);
                } else if (current_output_signal.get_source_value() == 1) {
                    if (network.is_in_attractor_state()) {
                        stroke(51, 249, 255);
                    } else {
                        stroke(255, 249, 51);
                    }
                }
                line(v1[0], v1[1], v2[0], v2[1]);
            }
        }
    }

//    float[][] generate_all_sphere_points(int num_nodes) {
//        int total_count = ceil(sqrt((float) num_nodes));
//        float[][] res = new float[num_nodes][2];
//        float r = 200;
//        int point_counter = 0;
//        for (int i = 0; i < total_count; i++) {
//            float lat = map(i, 0, total_count, 0, PI);
//            for (int j = 0; j < total_count; j++) {
//                float lon = map(j, 0, total_count, 0, TWO_PI);
//                float x = r * sin(lat) * cos(lon);
//                float y = r * sin(lat) * sin(lon);
//                float z = r * cos(lat);
//                res[point_counter][0] = x;
//                res[point_counter][1] = y;
////                res[point_counter][2] = z;
//                point_counter = point_counter + 1;
//                if (point_counter >= num_nodes) {
//                    return res;
//                }
//            }
//        }
//        return res;
//    }

    float[][] generate_all_rectangle_points(int num_nodes) {
        int space = 70;
        float[][] res = new float[num_nodes][2];
        int point_counter = 0;


        for (int i = space; i < (w - space); i = i + space * 2) {
            for (int j = space; j < (h - space); j = j + space) {
                if (i > (w - space) || j > (h - space)) {
                    println(i);
                    println(j);
                    println("HELLO");
                }
                res[point_counter][0] = i;
                res[point_counter][1] = j;
                point_counter = point_counter + 1;
                if (point_counter >= num_nodes) {
                    return res;
                }
            }
        }
        return res;
    }

    float[][] generate_all_circle_points(int num_nodes) {
        float theta = 0;  // angle that will be increased each loop
        float h = this.h / ((float) 2);      // x coordinate of circle center
        float k = this.w / ((float) 2);      // y coordinate of circle center
        int step = 5;  // amount to add to theta each time (degrees)
        float r = 400;
        int point_counter = 0;
        float[][] res = new float[num_nodes][2];

        while (point_counter < num_nodes) {
            float x = h + r*cos(theta);
            float y = k + r*sin(theta);
            res[point_counter][0] = x;
            res[point_counter][1] = y;
            theta = theta + step;
            point_counter = point_counter + 1;
            if (theta > 360) {
                r = r - 100;
                theta = 0;
            }
        }
        return res;
    }


    public void mousePressed() {
//        println(network.attractors.size());
//        println(network.attractors);
        ArrayList<ArrayList<Integer>> S = Utils.generate_random_binary_numbers(network.size(), 10000, generator);
        network.get_attractors(S);
        println(network.attractors.size());
        ArrayList<ArrayList<Integer>> x = Utils.generate_random_binary_numbers(network.size(), 5000, generator);
        ArrayList<Integer> my_state = x.get(2500);

//        int l = Utils.getRandomNumber(generator, 5000);
//         = x.get(l);
//        int l = Utils.getRandomNumber(generator, network.attractors.size());
//        Iterator<LinkedHashSet<ArrayList<Integer>>> it = network.attractors.iterator();
//        ArrayList<Integer> my_state = new ArrayList<>();
//        while (it.hasNext()) {
//            LinkedHashSet<ArrayList<Integer>> cur_att = it.next();
//            if (l == 0) {
//                Iterator<ArrayList<Integer>> it2 = cur_att.iterator();
//                my_state = it2.next();
//            } else {
//                l = l - 1;
//            }
//        }
        network.set_node_values(my_state);

    }

    public void mouseDragged() {
        this.network = population.population.get(generator.nextInt(population.size()));
    }
}
