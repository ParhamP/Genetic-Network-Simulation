class Node {
  PVector location;
  int value;
  //LinkedHashSet<Signal> input_signals;
  //LinkedHashSet<Signal> output_signals;
  ArrayList<Integer> input_signals_quantities;
  ArrayList<Integer> output_signals_quantities;
  
  ArrayList<Signal> input_signals;
  ArrayList<Signal> output_signals;
  float p; // bias
  //int k_max; // max num of input signals
  //HashMap<ArrayList<Integer>, Integer> functions;
  ArrayList<String> functions;
  ArrayList<Integer> function_values;
  //int seed = 0;
  Random generator;
  Network my_network;
  
  Node() {
  }
  
  Node(float x, float y, float z, float bias) {
    set_location(x, y, z);
    p = bias;
    //input_signals = new LinkedHashSet<Signal>();
    //output_signals = new LinkedHashSet<Signal>();
    input_signals_quantities = new ArrayList<Integer>();
    output_signals_quantities = new ArrayList<Integer>();
    input_signals = new ArrayList<Signal>();
    output_signals = new ArrayList<Signal>();
    value = -1; // indicates it hasn't been calculated yet
    generator = new Random();
    boolean val_bool = generator.nextDouble() < 0.5;
    value = val_bool ? 1 : 0;
  }
  
 Node(float x, float y, float z, float bias, Random my_generator) {
    set_location(x, y, z);
    p = bias;
    //input_signals = new LinkedHashSet<Signal>();
    //output_signals = new LinkedHashSet<Signal>();
    input_signals_quantities = new ArrayList<Integer>();
    output_signals_quantities = new ArrayList<Integer>();
    input_signals = new ArrayList<Signal>();
    output_signals = new ArrayList<Signal>();
    value = -1; // indicates it hasn't been calculated yet
    generator = my_generator;
    boolean val_bool = generator.nextDouble() < 0.5;
    value = val_bool ? 1 : 0;
  }
  
  void set_location(float x, float y, float z) {
    location = new PVector(x, y, z);
  }
  
  PVector get_location() {
    return location;
  }
  
  void set_my_network(Network network) {
    my_network = network;
  }
  
  
  ArrayList<Signal> get_output_signals() {
    return output_signals;
  }
  
  ArrayList<Signal> get_input_signals() {
    return input_signals;
  }
  
  int num_regulators() {
    return input_signals.size();
  }
  
  int num_output_connections() {
    return output_signals.size();
  }
  
  void add_input(Node source_node) {
    Signal input_signal = new Signal(source_node, this);
    if (input_signals.isEmpty()) {
      input_signals.add(input_signal);
      input_signals_quantities.add(1);
      generate_functions();
      return;
    }
    if (input_signals.contains(input_signal)) {
      int input_signal_index = input_signals.indexOf(input_signal);
      int input_signal_quantity = input_signals_quantities.get(input_signal_index);
      input_signals_quantities.set(input_signal_index, input_signal_quantity + 1);
      update_functions_after_duplicate_signal_added(input_signal_index);
    } else {
      ArrayList<String> old_functions = (ArrayList) functions.clone();
      ArrayList<Integer> old_function_values = (ArrayList) function_values.clone();
      input_signals.add(input_signal);
      input_signals_quantities.add(1);
      generate_functions();
      update_functions_after_new_signal_added(old_functions, old_function_values);
    }
  }
  
  void add_output(Node target_node) {
    Signal output_signal = new Signal(this, target_node);
    if (output_signals.contains(output_signal)) {
      int output_signal_index = output_signals.indexOf(output_signal);
      int current_output_signal_quantity = output_signals_quantities.get(output_signal_index);
      output_signals_quantities.set(output_signal_index, current_output_signal_quantity + 1);
    } else {
      output_signals.add(output_signal);
      output_signals_quantities.add(1);
    }
  }
  
  void remove_input(Node source_node) {
    Signal input_signal = new Signal(source_node, this);
    int input_signal_index = input_signals.indexOf(input_signal);
    if (input_signal_index == -1) {
      return;
    }
    int input_signal_quantity = input_signals_quantities.get(input_signal_index);
    if (input_signal_quantity > 1) {
      input_signals_quantities.set(input_signal_index, input_signal_quantity - 1);
      update_functions_after_duplicate_signal_removed(input_signal_index);
    } else if (input_signal_quantity == 1 && input_signals.size() > 1) {
      ArrayList<String> old_functions = (ArrayList) functions.clone();
      ArrayList<Integer> old_function_values = (ArrayList) function_values.clone();
      input_signals.remove(input_signal_index);
      input_signals_quantities.remove(input_signal_index);
      generate_functions();
      update_functions_after_singular_signal_removed(input_signal_index, old_functions,
                                                     old_function_values);
    }
  }
  
  void remove_output(Node target_node) {
    Signal output_signal = new Signal(this, target_node);
    int output_signal_index = output_signals.indexOf(output_signal);
    if (output_signal_index == -1) {
      return;
    }
    int output_signal_quantity = output_signals_quantities.get(output_signal_index);
    if (output_signal_quantity > 1) {
      output_signals_quantities.set(output_signal_index, output_signal_quantity - 1);
    } else if(output_signal_quantity == 1)  {
      output_signals.remove(output_signal_index);
      output_signals_quantities.remove(output_signal_index);
    } 
  }
  
  int get_value() {
    return value;
  }
  
  void set_value(int val) {
    value = val;
  }
  
  
  void generate_functions() { // whenever a new input node is added to me, I need to generate functions again
    int k = input_signals.size();
    functions = generate_binary_strings(k);
    function_values = new ArrayList<Integer>();
    for (int i = 0; i < functions.size(); i++) {
      boolean val_bool = generator.nextDouble() < p;
      int val = val_bool ? 1 : 0;
      function_values.add(val);
    }
  }
  
  void generate_functions(ArrayList<String> funcs) { // whenever a new input node is added to me, I need to generate functions again
    //int k = input_signals.size();
    this.functions = funcs;
    function_values = new ArrayList<Integer>();
    for (int i = 0; i < functions.size(); i++) {
      boolean val_bool = generator.nextDouble() < p;
      int val = val_bool ? 1 : 0;
      function_values.add(val);
    }
  }
  
  int calculate_value() throws Exception{
    String val_string = "";
    Iterator<Signal> it = input_signals.iterator();
    while (it.hasNext()) {
      Signal current_signal = it.next();
      int current_input_val = current_signal.get_source_value();
      val_string = val_string + String.valueOf(current_input_val);
    }
    int functions_length = functions.size();
    for (int i = 0; i < functions_length; i++) {
      String current_function = functions.get(i);
      if (val_string.equals(current_function)) {
        int current_function_val = function_values.get(i);
        this.value = current_function_val;
        return current_function_val;
      }
    }
    throw new Exception("Couldn't find the correct function.");
  }
  
  void update_functions_after_duplicate_signal_added(int input_index) {
    for (int i = 0; i < functions.size(); i++) {
      String func = functions.get(i);
      char selected_node_char_value = func.charAt(input_index);
      int selected_node_value = Character.getNumericValue(selected_node_char_value);
      if (selected_node_value == 1) {
        boolean val_bool = generator.nextDouble() < p;
        int val = val_bool ? 1 : 0;
        function_values.set(i, val);
      }
    }
  }
  
  void update_functions_after_duplicate_signal_removed(int selected_signal_index) {
    for (int i = 0; i < functions.size(); i++) {
      String func = functions.get(i);
      char selected_node_char_value = func.charAt(selected_signal_index);
      int selected_node_value = Character.getNumericValue(selected_node_char_value);
      if (selected_node_value == 1) {
        boolean val_bool = generator.nextDouble() < p;
        int val = val_bool ? 1 : 0;
        function_values.set(i, val);
      }
    }
  }
  
  void update_functions_after_singular_signal_removed(int selected_signal_index,
                                                      ArrayList<String> old_functions,
                                                      ArrayList<Integer> old_function_values) {
    for (int i = 0; i < old_functions.size(); i++) {
      String old_func = old_functions.get(i);
      int old_func_value = old_function_values.get(i);
      char selected_node_char_value = old_func.charAt(selected_signal_index);
      int selected_node_value = Character.getNumericValue(selected_node_char_value);
      if (selected_node_value == 0) {
        String new_func_version_part_1 = old_func.substring(0, selected_signal_index);
        String new_func_version_part_2 = old_func.substring(selected_signal_index + 1);
        String new_func_version = new_func_version_part_1 + new_func_version_part_2;
        int new_func_index = functions.indexOf(new_func_version);
        function_values.set(new_func_index, old_func_value);
      }
    }
  }
  
  void update_functions_after_new_signal_added(ArrayList<String> old_functions,
                                               ArrayList<Integer> old_function_values) {
    for (int i = 0; i < functions.size(); i++) {
      String func = functions.get(i);
      char selected_node_char_value = func.charAt(func.length() - 1);
      int selected_node_value = Character.getNumericValue(selected_node_char_value);
      String old_func_version = func.substring(0, func.length() - 1);
      int old_func_index = old_functions.indexOf(old_func_version);
      int old_func_value = old_function_values.get(old_func_index);
      if (selected_node_value == 0) {
        function_values.set(i, old_func_value);
      } else {
        boolean val_bool = generator.nextDouble() < p;
        int val = val_bool ? 1 : 0;
        function_values.set(i, val);
      }
    }
  }
  
  void regulatory_additive_mutation() {
    int my_network_size = my_network.size();
    Node selected_node = this;
    while (selected_node.equals(this)) {
      int selected_node_index = getRandomNumber(generator, 0, my_network_size);
      selected_node = my_network.get_node(selected_node_index);
    }
    my_network.connect(selected_node, this);
  }
  
  void regulatory_subtractive_mutation() {
    int input_signals_size = input_signals.size();
    int selected_signal_index = getRandomNumber(generator, 0, input_signals_size);
    Signal selected_signal = input_signals.get(selected_signal_index);
    Node source_node = selected_signal.get_source();
    my_network.disconnect(source_node, this);
  }
  
  ArrayList<Node> find_network_targets(int num_affected_targets) {
    int my_network_size = my_network.size();
    ArrayList<Node> targets = new ArrayList<Node>();
    ArrayList<Node> already_selected = new ArrayList<Node>();
    already_selected.add(this);
    while (targets.size() < num_affected_targets) {
      int selected_node_index = getRandomNumber(generator, 0, my_network_size);
      Node selected_node = my_network.get_node(selected_node_index);
      while (already_selected.contains(selected_node)) {
        selected_node_index = getRandomNumber(generator, 0, my_network_size);
        selected_node = my_network.get_node(selected_node_index);
      }
      targets.add(selected_node);
      already_selected.add(selected_node);
    }
    return targets;
  }
  
  ArrayList<Node> find_output_targets(int num_affected_targets) {
    int output_size = output_signals.size();
    ArrayList<Node> targets = new ArrayList<Node>();
    ArrayList<Node> already_selected = new ArrayList<Node>();
    while (targets.size() < num_affected_targets) {
      int selected_node_index = getRandomNumber(generator, 0, output_size);
      Signal selected_signal = output_signals.get(selected_node_index);
      Node selected_node = selected_signal.get_target();
      while (already_selected.contains(selected_node)) {
        selected_node_index = getRandomNumber(generator, 0, output_size);
        selected_signal = output_signals.get(selected_node_index);
        selected_node = selected_signal.get_target();
      }
      targets.add(selected_node);
      already_selected.add(selected_node);
    }
    return targets;
  }
  
  void coding_additive_mutation(int num_affected_targets) {
    ArrayList<Node> targets = find_network_targets(num_affected_targets);
    for (int i = 0; i < num_affected_targets; i++) {
      Node target = targets.get(i);
      my_network.connect(this, target);
    }
  }
  
  void coding_subtractive_mutation(int num_affected_targets) {
    ArrayList<Node> targets = find_output_targets(num_affected_targets);
    for (int i = 0; i < num_affected_targets; i++) {
      Node target = targets.get(i);
      my_network.disconnect(this, target); //<>//
    }
  }
  
  
   @Override
   public String toString() {
     int node_num_in_network = my_network.get_node_number(this);
      return String.valueOf(node_num_in_network);
   }
   
  
    @Override
    public boolean equals(Object o) {
      if (o == this) {
        return true;
      }
      if (!(o instanceof Node)) {
            return false;
      }
      Node c = (Node) o;
      return this.get_location().equals(c.get_location());
    }
}
