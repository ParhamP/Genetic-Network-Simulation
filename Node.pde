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
  
  
  void add_input(Node source_node) {
    Signal input_signal = new Signal(source_node, this);
    //input_node.add_output(input_signal);
    if (input_signals.contains(input_signal)) {
      int input_signal_index = input_signals.indexOf(input_signal);
      int current_input_signal_quantity = input_signals_quantities.get(input_signal_index);
      input_signals_quantities.set(input_signal_index, current_input_signal_quantity + 1);
    } else {
    input_signals.add(input_signal);
    input_signals_quantities.add(1);
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
  
  //void add_output(Node output_node) { // only used within add_input
  //  Signal output_signal = new Signal(this, output_node);
  //  output_signals.add(output_signal);
  //  output_node.add_input(output_signal);
  //}
  
  //void add_output(Signal output_signal) {
  //  Node output_node = output_signal.target;
  //  add_output(output_node);
  //}
  
  //void add_input(Signal input_signal) {
  //  Node input_node = input_signal.source;
  //  add_input(input_node);
  //}
  
  
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
  
  void additive_mutation() {
    int my_network_size = my_network.size(); //<>//
    Node selected_node = this;
    //println(selected_node);
    while (selected_node.equals(this)) {
      int selected_node_index = getRandomNumber(generator, 0, my_network_size);
      selected_node = my_network.get_node(selected_node_index);
    }
    println(selected_node);
    println(input_signals);
    boolean exists_already = false;
    Iterator<Signal> it = input_signals.iterator();
    int input_index = 0;
    while (it.hasNext()) {
      Signal current_signal = it.next();
      Node source = current_signal.get_source();
      
      if (selected_node.equals(source)) {
        exists_already = true;
        break;
      }
      input_index = input_index + 1;
    }
    if (exists_already) {
      println(input_signals); //<>//
      println(input_signals_quantities);
      my_network.connect(selected_node, this);
      println(input_signals);
      println(input_signals_quantities);
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
    } else {
      println(input_signals); //<>//
      println(input_signals_quantities);
      my_network.connect(selected_node, this);
      println(input_signals);
      println(input_signals_quantities);
      ArrayList<String> old_functions = (ArrayList) functions.clone();
      ArrayList<Integer> old_function_values = (ArrayList) function_values.clone();
      generate_functions();
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
    println(input_signals); //<>//
  }
  
  void removal_mutation() {
    //int input_signals_size = input_signals.size();
    //int selected_signal_index = getRandomNumber(generator, 0, input_signals_size);
    //Signal selected_signal = input_signals.get(selected_signal_index);
    //println(selected_signal);
    //int selected_signal_frequency = Collections.frequency(input_signals, selected_signal);
    //println(selected_signal_frequency);
    //if (selected_signal_frequency > 1) {
      
    //} else {
      
    //}
  }
  
  void regulatory_mutation(float u) {
    Double prob = generator.nextDouble();
    if (prob < (1 - u)) {
      return;
    } else if (prob < (1 -  (u / 2))) {
      additive_mutation();
    } else {
      removal_mutation();
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
