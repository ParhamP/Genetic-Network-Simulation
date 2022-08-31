import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.util.ArrayList;
import java.util.HashMap;

public class Main {

    public static void main(String[] args) {

//        int total = 10;
//        int seed = 2;
//        float p = (float) 0.5;

//        int k_0 = 6;
//        Random generator = new Random(seed);
//        Network network = new Network(total, p, k_max, n_max, generator);
//        network.initialize_random_connections(k_0);
//        ArrayList<ArrayList<Integer>> S = Utils.generate_random_binary_numbers(total, 1000, generator);
//        HashSet<HashSet<ArrayList<Integer>>> attractors = network.get_attractors(S);
//        System.out.println(attractors);
//        System.out.println(attractors.size());

        int k_max = 12;
        int n_max = 100;
        int num_networks = 1000;
        int num_nodes = 10;
        float p = (float) 0.5;
        int k_0 = 3;
        Population pop = new Population(k_max, n_max);
        pop.initialize_networks(num_networks, num_nodes, p, k_0);
        pop.evolve();
    }
}
