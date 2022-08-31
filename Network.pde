import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.*;
import java.lang.Math;

public class Network implements Serializable {
    float p;
    int k_max; // max num of input signals
    int n_max; // max num of nodes
    ArrayList<Node> nodes;
    //HashMap<Integer, int[][]> binary_functions_archive;
    Random generator;
    HashSet<LinkedHashSet<ArrayList<Integer>>> attractors;
    HashMap<ArrayList<Integer>, Integer> state_attractor_numbers;


    Network(Integer num_nodes, float bias, int max_num_inputs,int max_num_nodes,
            Random my_generator) {
        generator = my_generator;
        p = bias;
        k_max = max_num_inputs;
        n_max = max_num_nodes;
        //binary_functions_archive = new HashMap<Integer, int[][]>();
        state_attractor_numbers = new HashMap<ArrayList<Integer>, Integer>();
        initialize_nodes(num_nodes);
    }

    public Network(Network network) {
        this.p = network.p;
        this.k_max = network.k_max;
        this.n_max = network.n_max;
        ArrayList<Node> new_nodes = new ArrayList<Node>();
        for (Node node : network.nodes) {
            Node new_node = new Node(node, this);
            new_nodes.add(new_node);
        }
        this.nodes = new_nodes;
        for (int i = 0; i < network.nodes.size(); i++) {
            Node old_node = network.nodes.get(i);
            Node new_node = this.nodes.get(i);
            new_node.copy_signals(old_node);
        }
        //this.binary_functions_archive = network.binary_functions_archive;
        this.generator = network.generator;
        //this.state_attractor_numbers = network.state_attractor_numbers;
        //this.attractors = network.attractors;
    }

    ArrayList<Node> get_nodes() {
        return nodes;
    }

    Node get_node(int i) {
        return nodes.get(i);
    }

    int get_node_number(Node node) {
        int node_number =  nodes.indexOf(node);
        if (node_number == -1) {
            System.out.println("HI");
        }
        return node_number;
    }

    void initialize_nodes(int num_nodes) {
        ArrayList<Node> my_nodes = new ArrayList<Node>();
        for (int i = 0; i < num_nodes; i++) {
            Node current_node = new Node(p, generator);
            current_node.set_my_network(this);
            my_nodes.add(current_node);
        }
        nodes = my_nodes;
    }

    void connect(Node node_1, Node node_2) { // node_2 receives input node_1
        if (node_2.num_regulators() >= k_max) {
            return;
        }
        node_1.add_output(node_2);
        node_2.add_input(node_1);
    }

    void disconnect(Node node_1, Node node_2) { // node_2 was receiving input node_1
//        if (node_2.num_regulators() <= k_min) {
//            System.out.println("HELLO");
//            return;
//        }
        node_1.remove_output(node_2);
        node_2.remove_input(node_1);
    }

    void initialize_random_connections(int k_n) {
        //if (!binary_functions_archive.containsKey(k_n)) {
        //  int[][] function_matrix = generate_binary_matrix(k_n);
        //  binary_functions_archive.put(k_n, function_matrix);
        //}
        //int[][] functions = binary_functions_archive.get(k_n);
        int num_nodes = nodes.size();
        for (int i = 0; i < num_nodes; i++) {
            Node n1 = nodes.get(i);
            // choose k_n random nodes
            ArrayList<Integer> list = new ArrayList<Integer>();
            for (int k = 0; k < num_nodes; k++) {
                if (k == i) {
                    continue;
                }
                list.add(k);
            }
            Collections.shuffle(list, generator);
            for (int j = 0; j < k_n; j++) {
                int other_node_index = list.get(j);
                Node n2 = nodes.get(other_node_index);
                connect(n2, n1);
            }
            //n1.generate_functions(functions);
        }
    }

    ArrayList<Integer> update_state() {
        ArrayList<Node> globe = nodes;
        int total = globe.size();
        ArrayList<Integer> results = new ArrayList<Integer>();
        for (int i = 0; i < total; i++) {
            Node n1 = globe.get(i);
            try {
                n1.calculate_value();
            } catch(Exception e) {
                System.out.println(e);
            }
            int current_value = n1.get_value();
            results.add(current_value);
        }
        return results;
    }

    ArrayList<Integer> update_state(ArrayList<Integer> state) {
        set_node_values(state);
        return update_state();
    }


    void set_node_values(ArrayList<Integer> state) {
        ArrayList<Node> globe = nodes;
        int total = globe.size();
        for (int i = 0; i < total; i++) {
            int current_state_val = state.get(i);
            Node n1 = globe.get(i);
            n1.set_value(current_state_val);
        }
    }

    float average_sensitivity() {
        float avg_k = calculate_average_k();
        return 2 * p * (1 - p) * avg_k;
    }

    float calculate_average_k() {
        float k_sum = 0;
        float num_nodes = (float) nodes.size();
        for (Node node : nodes) {
            k_sum = k_sum + node.num_regulators();
        }
        float avg_k = k_sum / num_nodes;
        return avg_k;
    }

    float average_gene_expression_variability() {
        float total_alpha = 0;
//        float total_attractors_size = 0;
        float total_count = 0;
        for (LinkedHashSet<ArrayList<Integer>> attractor : attractors) {
            for (ArrayList<Integer> state : attractor) {
                float alpha = alpha_fitness(state);
                total_alpha = total_alpha + alpha;
                total_count = total_count + 1;
            }
//            total_attractors_size = total_attractors_size + attractor.size();
        }
//        float att_avg = total_attractors_size / attractors.size();
        float res = total_alpha / total_count;
//        res = res * att_avg;
        return res;
    }

    void gene_duplication_and_divergence(float additive_chance) {
        int network_size = this.size();
        if (network_size >= n_max) {
            return;
        }
        int selected_node_index = Utils.getRandomNumber(generator, network_size);
        Node selected_node = nodes.get(selected_node_index);
        Node duplicated_node = new Node(p, generator);
        duplicated_node.set_my_network(this);
        duplicated_node.set_value(selected_node.get_value());
        nodes.add(duplicated_node);
        ArrayList<Signal> selected_input_signals = selected_node.input_signals;
        ArrayList<Integer> selected_input_quantities = selected_node.input_signals_quantities;
        for (int i = 0; i < selected_input_signals.size(); i++) {
            Signal signal = selected_input_signals.get(i);
            Node source = signal.get_source();
            int quantity = selected_input_quantities.get(i);
            for (int j = 0; j < quantity; j++) {
                connect(source, duplicated_node);
            }
        }
        ArrayList<Signal> selected_output_signals = selected_node.output_signals;
        ArrayList<Integer> selected_output_quantities = selected_node.output_signals_quantities;
        for (int i = 0; i < selected_output_signals.size(); i++) {
            Signal signal = selected_output_signals.get(i);
            Node target = signal.get_target();
            int quantity = selected_output_quantities.get(i);
            for (int j = 0; j < quantity; j++) {
                connect(duplicated_node, target);
            }
        }

        double prob = generator.nextDouble();
        if (prob > additive_chance) {
            duplicated_node.regulatory_subtractive_mutation();
        } else {
            duplicated_node.regulatory_additive_mutation();
        }

        int num_affected_targets = duplicated_node.num_affected_targets();
        prob = generator.nextDouble();
        if (prob > additive_chance) {
            duplicated_node.coding_subtractive_mutation(num_affected_targets);
        } else {
            duplicated_node.coding_additive_mutation(num_affected_targets);
        }
    }

    float alpha_fitness(ArrayList<Integer> state) {
        float num_zeros = 0;
        float num_ones = 0;
        float num_bits = state.size();
        for (int bit : state) {
            if (bit == 0) {
                num_zeros = num_zeros + 1;
            } else {
                num_ones = num_ones + 1;
            }
        }
        float zeros_fraction = num_zeros / num_bits;
        float ones_fraction = num_ones / num_bits;
        float ones_minus_zeros = ones_fraction - zeros_fraction;
        float alpha = (float) 0.5 * (1 - Math.abs(ones_minus_zeros));
        return alpha;
    }


    int size() {
        return nodes.size();
    }

    ArrayList<Integer> get_network_state() {
        ArrayList<Node> globe = nodes;
        int total = globe.size();
        //int[] results = new int[total];
        ArrayList<Integer> results = new ArrayList<Integer>();
        for (int i = 0; i < total; i++) {
            Node n1 = globe.get(i);
            int current_value = n1.get_value();
            results.add(current_value);
        }
        return results;
    }

    void set_state_attractor(ArrayList<Integer> state, int attractor_num) {
        state_attractor_numbers.put(state, attractor_num);
    }

    Integer get_state_attractor(ArrayList<Integer> state) {
        if (state_attractor_numbers.containsKey(state)) {
            Integer attractor_num = state_attractor_numbers.get(state);
            return attractor_num;
        } else {
            return 0;
        }
    }

    boolean attractors_exist(HashSet<LinkedHashSet<ArrayList<Integer>>> in_attractors) {
        for (LinkedHashSet<ArrayList<Integer>> attractor : in_attractors) {
            if (!attractor_exists(attractor)) {
                return false;
            }
        }
        return true;
    }

    boolean attractor_exists(LinkedHashSet<ArrayList<Integer>> attractor) {
        Iterator<ArrayList<Integer>> it = attractor.iterator();
        ArrayList<Integer> first_attractor = it.next();
        ArrayList<Integer> current_network_state = update_state(first_attractor);
        while (it.hasNext()) {
            ArrayList<Integer> current_attractor = it.next();
            if (!current_attractor.equals(current_network_state)) {
                return false;
            }
            current_network_state = update_state(current_attractor);
        }
        return first_attractor.equals(current_network_state);
    }

    HashSet<LinkedHashSet<ArrayList<Integer>>> get_attractors(ArrayList<ArrayList<Integer>> S) {
        ArrayList<Integer> orig_state = get_network_state();
        int currentAttractor = 0;
        HashSet<LinkedHashSet<ArrayList<Integer>>> resultList =
                new HashSet<LinkedHashSet<ArrayList<Integer>>>();
        state_attractor_numbers = new HashMap<ArrayList<Integer>, Integer>();
        for(ArrayList<Integer> startState : S) {
            if (get_state_attractor(startState) == 0) {
                ArrayList<Integer> current = startState;
                currentAttractor = currentAttractor + 1;
                while (get_state_attractor(current) == 0) {
                    set_state_attractor(current, currentAttractor);
                    current = update_state(current);
                }
                int current_state_attractor = get_state_attractor(current);
                if (current_state_attractor == currentAttractor) {
                    ArrayList<Integer> attractorStart = current;
                    LinkedHashSet<ArrayList<Integer>> attractor = new LinkedHashSet<ArrayList<Integer>>();
                    do {
                        attractor.add(current);
                        current = update_state(current);
                    } while (!current.equals(attractorStart));
                    resultList.add(attractor);
                } else {
                    ArrayList<Integer> attractorStart = current;
                    Integer attractorStartNum = get_state_attractor(attractorStart);
                    current = startState;
                    while (!current.equals(attractorStart)) {
                        set_state_attractor(current, attractorStartNum);
                        current = update_state(current);
                    }
                }
            }
        }
        set_node_values(orig_state);
        attractors = resultList;
        return resultList;
    }

    boolean is_in_attractor_state() {
        ArrayList<Integer> state = get_network_state();
        if (attractors == null || attractors.isEmpty()) {
            return false;
        }
        for (LinkedHashSet<ArrayList<Integer>> s_a : attractors) {
            for (ArrayList<Integer> s : s_a) {
                if (s.equals(state)) {
                    return true;
                }
            }
        }
        return false;
    }
}
