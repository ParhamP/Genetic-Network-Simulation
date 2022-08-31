import java.io.*;
import java.util.*;
import java.io.*;
public class Population implements Serializable {
    ArrayList<Network> population;
    int n_max;
    Random generator;
    int seed;
    float u;
    float d_rate;
    int k_max;
    int min_allowed_num_networks;
    int num_orig_networks;
    HashMap<Integer, Integer> network_labels;
    ArrayList<ArrayList<Integer>> label_quantities_list;

    Population(int max_num_inputs, int max_num_nodes) {
        k_max = max_num_inputs;
        n_max = max_num_nodes;
        u = (float) 0.1; // 0.01
//        d_rate = (float) 0.00001;
//        seed = 3;
        generator = new Random(3);
        network_labels = new HashMap<Integer, Integer>();
        label_quantities_list = new ArrayList<>();
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
            new_network.initialize_random_connections(k_0);
            new_network.set_label(m);
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

//    HashSet<LinkedHashSet<ArrayList<Integer>>> duplicate_network(Network network, ArrayList<ArrayList<Integer>> pre_S) {
//        double prob = generator.nextDouble();
//        HashSet<LinkedHashSet<ArrayList<Integer>>> res = new HashSet<LinkedHashSet<ArrayList<Integer>>>();
//        if (prob > (1 - d_rate)) {
//            res = network.get_attractors(pre_S);
//        }
//        return res;
//    }

    void mutate_network(Network network) {
        ArrayList<Node> nodes = network.get_nodes();
        for (Node node : nodes) {
            // Regulatory Mutation
            double prob = generator.nextDouble();
            if (prob > (1 - u)) {
                prob = generator.nextDouble();
                if (prob > 0.5) {
                    prob = generator.nextDouble();
                    if (prob > 0.5) {
                        node.regulatory_subtractive_mutation();
                    } else {
                        node.regulatory_additive_mutation();
                    }
                } else {
                    int num_affected_targets = node.num_affected_targets(); // double check this
                    prob = generator.nextDouble();
                    if (prob > 0.5) {
                        node.coding_subtractive_mutation(num_affected_targets);
                    } else {
                        node.coding_additive_mutation(num_affected_targets);
                    }
                }
            }
//            int num_regulators = node.num_regulators();
//            for (int i = 0; i < num_regulators; i++) {
//                double prob = generator.nextDouble();
//                if (prob > (1 - u)) {
//                    prob = generator.nextDouble();
//                    if (prob > 0.5) {
//                        node.regulatory_subtractive_mutation();
//                    } else {
//                        node.regulatory_additive_mutation();
//                    }
//                }
//            }
//            // Coding Mutation
//            double prob = generator.nextDouble();
//            if (prob > 1 - u) {
//                int num_affected_targets = node.num_affected_targets(); // double check this
//                prob = generator.nextDouble();
//                if (prob > 0.5) {
//                    node.coding_subtractive_mutation(num_affected_targets);
//                } else {
//                    node.coding_additive_mutation(num_affected_targets);
//                }
//            }
        }
    }

    ArrayList<ArrayList<Integer>> generate_subsets(int network_size, int amount) {
        ArrayList<ArrayList<Integer>> S =  Utils.generate_random_binary_numbers(network_size, amount, generator);
        return S;
    }

    boolean hashset_contains_attractor(LinkedHashSet<ArrayList<Integer>> attractor, HashSet<LinkedHashSet<ArrayList<Integer>>> a2) {
        for (LinkedHashSet<ArrayList<Integer>> attractor_2 : a2) {
            if (attractor.equals(attractor_2)) {
                return true;
            }
        }
        return false;
    }

    boolean a2_contains_a1(HashSet<LinkedHashSet<ArrayList<Integer>>> a1,
                           HashSet<LinkedHashSet<ArrayList<Integer>>> a2) {
        if (a1.size() > a2.size()) {
            return false;
        }
        for (LinkedHashSet<ArrayList<Integer>> attractor_1 : a1) {
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

    float get_population_average_criticality() {
        float critic_sum = 0;
        float num_networks = (float) population.size();
        for (Network network : population) {
            critic_sum = critic_sum + network.average_sensitivity();
        }
        float avg_networks_critic = critic_sum / num_networks;
        return avg_networks_critic;
    }

    HashSet<LinkedHashSet<ArrayList<Integer>>> trimmed_attractors(HashSet<LinkedHashSet<ArrayList<Integer>>> attractors) {
        HashSet<LinkedHashSet<ArrayList<Integer>>> copied_attractors = new HashSet<LinkedHashSet<ArrayList<Integer>>>();
        for (LinkedHashSet<ArrayList<Integer>> attractor : attractors) {
            LinkedHashSet<ArrayList<Integer>> copied_attractor = new LinkedHashSet<ArrayList<Integer>>();
            for (ArrayList<Integer> state : attractor) {
                ArrayList<Integer> copied_state = (ArrayList<Integer>) state.clone();
                copied_state.remove(copied_state.size() - 1);
                copied_attractor.add(copied_state);
            }
            copied_attractors.add(copied_attractor);
        }
        return copied_attractors;
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

    void save_population_to_file(String dest) {
//        "network.dat"
        try (FileOutputStream fos = new FileOutputStream(dest);
             ObjectOutputStream oos = new ObjectOutputStream(fos)) {
            // write object to file
            oos.writeObject(this);

        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    void save_label_quantities_to_file(String dest) {
        try (FileOutputStream fos = new FileOutputStream(dest);
             ObjectOutputStream oos = new ObjectOutputStream(fos)) {
            // write object to file
            oos.writeObject(label_quantities_list);

        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    void restore_population() {
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
            int m_i = Math.round(m_i_float);
            for (int j = 0; j < m_i; j++) {
                Network daughter_network = new Network(network);
                population.add(daughter_network);
            }
        }
    }

    ArrayList<ArrayList<Integer>> extend_subsets(ArrayList<ArrayList<Integer>> S) {
        ArrayList<ArrayList<Integer>> extended_S = new ArrayList<ArrayList<Integer>>();
        for (ArrayList<Integer> state : S) {
            ArrayList<Integer> extended_state = (ArrayList<Integer>) state.clone();
            double prob = generator.nextDouble();
            if (prob > 0.5) {
                extended_state.add(0);
            } else {
                extended_state.add(1);
            }
            extended_S.add(extended_state);
        }
        return extended_S;
    }

    void calculate_network_label_quantities() {
        network_labels.replaceAll((l, v) -> 0);
        for (Network network : population) {
            int network_label = network.get_label();
            if (network_labels.containsKey(network_label)) {
                int network_quantity = network_labels.get(network_label);
                network_labels.put(network_label, network_quantity + 1);
            } else {
                network_labels.put(network_label, 1);
            }
        }
    }

    void reset_network_labels() {
        network_labels = new HashMap<Integer, Integer>();
        for (int i = 0; i < population.size(); i++) {
            Network network = population.get(i);
            network.set_label(i);
            network_labels.put(i, 1);
        }
    }

    void reduce_network_label_quantity(int i) {
        Network network = population.get(i);
        int network_label = network.get_label();
        int network_label_quantity = network_labels.get(network_label);
        network_labels.put(network_label, network_label_quantity - 1);
    }

    boolean fixation_time() {
        int quantity_more_than_zero_count = 0;
        for (Integer quantity : network_labels.values()) {
            if (quantity_more_than_zero_count > 1) {
                return false;
            }
            if (quantity > 0) {
                quantity_more_than_zero_count = quantity_more_than_zero_count + 1;
            }
        }
        return true;
    }

    void store_label_quantities(PrintWriter outputWriter) {
        ArrayList<Integer> current_label_quantities = new ArrayList<Integer>(network_labels.values());
//        label_quantities_list.add(current_label_quantities);
        for (int i = 0; i < 1000; i++) {
            outputWriter.print(current_label_quantities.get(i));
            outputWriter.print(", ");
        }
        outputWriter.print(";");
    }

    boolean neighborhood_benefits(int i, ArrayList<Integer> compliers, int range) {
        for (int j = 0; j < population.size(); j = j + range) {
            if (i >= j && i < j + range) {
                for (int c : compliers) {
                    if (c >= j && c < j + range) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    void evolve() {
        String tempFileName = "/Users/parhamp/Documents/projects/attractor_evolution/saved_networks/label_quantities_neighb_benefit_100.txt";
        File outputf = new File(tempFileName);
        PrintWriter outputWriter;

//writer to the output file
        try {
            outputWriter = new PrintWriter(outputf);
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        }

        outputWriter.print("[");

        int num_generations_max = 1000000;
        int acc_num_subsets = 500;
        int aic_num_subsets = 500;
        calculate_network_label_quantities();
        store_label_quantities(outputWriter);
        ArrayList<ArrayList<Integer>> S = generate_subsets(current_network_size(), acc_num_subsets);
        for (int g_i = 1; g_i < num_generations_max; g_i++) {
//            if (population.size() <= 6) {
//                for (Integer quantity : network_labels.values()) {
//                    if (quantity != 0) {
//                        System.out.println(quantity);
//                    }
//                }
//            }
            if (fixation_time()) {
//                for (Integer quantity : network_labels.values()) {
//                    if (quantity != 0) {
//                        System.out.println(quantity);
//                    }
//                }
                System.out.println("Fixation happening...");
                store_label_quantities(outputWriter);
                restore_population();
                reset_network_labels();
            }
            if (population.size() < min_allowed_num_networks) {
                restore_population();
                calculate_network_label_quantities();
            }
            ArrayList<Integer> acc_violators = new ArrayList<>();
            for (int i = 0; i < population.size(); i++) {
                Network network = population.get(i);
                HashSet<LinkedHashSet<ArrayList<Integer>>> current_pre_attractors =
                        network.get_attractors(S);
                mutate_network(network);

                if (!network.attractors_exist(current_pre_attractors)) {
                    acc_violators.add(i);
                }
            }
            Collections.sort(acc_violators, Collections.reverseOrder());
            for (int i : acc_violators) {
                reduce_network_label_quantity(i);
                population.remove(i);
            }
            if (g_i % 25 == 0) {
                store_label_quantities(outputWriter);
            }

            if (g_i % 75 == 0) { // 2000
//                if (population.size() < min_allowed_num_networks) {
//                    restore_population();
//                }
                System.out.println(population.size());
                ArrayList<Integer> aic_violators = new ArrayList<Integer>();
                ArrayList<Integer> aic_compliers = new ArrayList<Integer>();
                System.out.println("AIC in Progress...");
//                S = generate_subsets(current_network_size() + 1,
//                        aic_num_subsets);
                ArrayList<ArrayList<Integer>> post_S = extend_subsets(S);
                for (int i = 0; i < population.size(); i++) {
                    Network network = population.get(i);
//                    ArrayList<ArrayList<Integer>> post_S = generate_subsets(network.size() + 1,
//                            aic_num_subsets);
//                    ArrayList<ArrayList<Integer>> pre_S = trim_subsets(S);
                    HashSet<LinkedHashSet<ArrayList<Integer>>> current_pre_attractors =
                            network.get_attractors(S);
                    network.gene_duplication_and_divergence();
                    HashSet<LinkedHashSet<ArrayList<Integer>>> current_post_attractors =
                            network.get_attractors(post_S);
                    HashSet<LinkedHashSet<ArrayList<Integer>>> current_post_attractors_trimmed =
                            trimmed_attractors(current_post_attractors);
                    if (current_post_attractors_trimmed.size() <= current_pre_attractors.size()) {
                        aic_violators.add(i);
                    } else {
                        if(!a2_contains_a1(current_pre_attractors, current_post_attractors_trimmed)) {
                            aic_violators.add(i);
                        } else {
                            aic_compliers.add(i);
                        }
                    }
//                    if (current_post_attractors_trimmed.size() <= current_pre_attractors.size()) {
//                        int population_size = population.size();
//                        int aic_size = aic_violators.size();
//                        if ((population_size - aic_size) > min_remaining_while_aic) {
//                            aic_violators.add(i);
//                        }
//                    }
                }
                Collections.sort(aic_violators, Collections.reverseOrder());
                for (int i : aic_violators) {
                    if (!neighborhood_benefits(i, aic_compliers, 100)) {
                        reduce_network_label_quantity(i);
                        population.remove(i);
                    }
                }
                store_label_quantities(outputWriter);
                S = post_S;
            }


            if (g_i == 1 || g_i % 25 == 0) {
                System.out.printf("Generation Number: %d%n", g_i);
                float average_num_attractors = get_population_average_num_attractors();
                System.out.printf("Average Number of Attractors per Network: %f%n", average_num_attractors);

                float average_num_nodes = get_population_average_num_nodes();
                System.out.printf("Average Number of Nodes: %f%n", average_num_nodes);

                float average_num_k = get_population_average_k();
                System.out.printf("Average Number of Regulators: %f%n", average_num_k);

                float average_critic = get_population_average_criticality();
                System.out.printf("Average Criticality: %f%n", average_critic);

                System.out.printf("Population size: %d%n", population.size());
                System.out.println("________");
            }
//            if (g_i % (2001) == 0) {
//                String dest = String.format("/Users/parhamp/Documents/projects/attractor_evolution/saved_networks/%d.dat",
//                        g_i);
//                save_population_to_file(dest);
//            }
            if (g_i % 1000 == 0) {
//                String dest = String.format("/Users/parhamp/Documents/projects/attractor_evolution/saved_networks/label_quantities_generation_%d.dat",
//                        g_i);
//                save_label_quantities_to_file(dest);
                outputWriter.print("]");
                outputWriter.println();
                outputWriter.close();
            }
        }
    }

    int get_num_networks() {
        return population.size();
    }

}