class Node {
  PVector location;
  int value;
  LinkedHashSet<Signal> input_signals;
  LinkedHashSet<Signal> output_signals;
  float p; // bias
  //int k_max; // max num of input signals
  //HashMap<ArrayList<Integer>, Integer> functions;
  ArrayList<String> functions;
  ArrayList<Integer> function_values;
  
  Node() {
  }
  
  Node(float x, float y, float z, float bias) {
    set_location(x, y, z);
    p = bias;
    input_signals = new LinkedHashSet<Signal>();
    output_signals = new LinkedHashSet<Signal>();
    value = -1; // indicates it hasn't been calculated yet
    boolean val_bool = new Random().nextDouble() < 0.5;
    value = val_bool ? 1 : 0;
    //k_max = 12;
    functions = new ArrayList<String>();
    function_values = new ArrayList<Integer>();
  }
  
  void set_location(float x, float y, float z) {
    location = new PVector(x, y, z);
  }
  
  PVector get_location() {
    return location;
  }
  
  LinkedHashSet<Signal> get_output_signals() {
    return output_signals;
  }
  
  void add_input(Node input_node) {
    Signal input_signal = new Signal(input_node, this);
    input_signals.add(input_signal);
    input_node.add_output(input_signal);
  }
  
  void add_output(Node output_node) {
    Signal output_signal = new Signal(this, output_node);
    output_signals.add(output_signal);
    output_node.add_input(output_signal);
  }
  
  void add_output(Signal output_signal) {
    output_signals.add(output_signal);
  }
  
  void add_input(Signal input_signal) {
    input_signals.add(input_signal);
  }
  
  
  int get_value() {
    return value;
  }
  
  void set_value(int val) {
    value = val;
  }
  
  void generate_functions() {
    int k = input_signals.size();
    functions = generate_binary_strings(k);
    for (int i = 0; i < functions.size(); i++) {
      boolean val_bool = new Random().nextDouble() < p;
      int val = val_bool ? 1 : 0;
      function_values.add(val);
    }
  }
  
  int calculate_value() throws Exception{
    int k = input_signals.size();
    //int[] val_arr = new int[k];
    String val_string = "";
    //int val_arr_index = 0;
    Iterator<Signal> it = input_signals.iterator();
    while (it.hasNext()) {
      Signal current_signal = it.next();
      int current_input_val = current_signal.get_source_value();
      val_string = val_string + String.valueOf(current_input_val);
      //val_arr[val_arr_index] = current_input_val;
      //val_arr_index = val_arr_index + 1;
    }
    //String val_arr_string = Arrays.toString(val_arr);
    int functions_length = functions.size();
    for (int i = 0; i < functions_length; i++) {
      String current_function = functions.get(i);
      if (val_string.equals(current_function)) {
        int current_function_val = function_values.get(i); //<>//
        this.value = current_function_val;
        return current_function_val;
      }
    }
    throw new Exception("Couldn't find the correct function.");
  }
  
  //void generateAllBinaryStrings(int n,
  //                          int arr[], int i)
  //                          {
  //  if (i == n)
  //  {
  //      //printTheArray(arr, n);
  //      boolean val_bool = new Random().nextDouble() < p;
  //      int val = val_bool ? 1 : 0;
  //      int[] current_arr = arr.clone(); 
  //      functions.add(current_arr);
  //      function_values.add(val);
  //      return;
  //  }
  //  arr[i] = 0;
  //  generateAllBinaryStrings(n, arr, i + 1);
  //  arr[i] = 1;
  //  generateAllBinaryStrings(n, arr, i + 1);
  //}
  
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
