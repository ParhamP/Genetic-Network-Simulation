//static void printTheArray(int arr[])
//{
//    int n = arr.length;
//    for (int i = 0; i < n; i++)
//    {
//        System.out.print(arr[i]+" ");
//    }
//    System.out.println();
//}

//ArrayList<String> generate_binary_strings(int k) {
//  ArrayList<String> results = new ArrayList<>();
//  double num_strings = Math.pow(2, k);
//  int num_strings_int = (int) num_strings;
//  for (int i=0; i < num_strings_int; i++) {
//    String format_string = "%" + String.valueOf(k) + "s";
//    String current_binary = String.format(format_string, Integer.toBinaryString(i)).replace(' ', '0');
//    results.add(current_binary);
//  }
//  return results;
//}


//ArrayList<String> generate_binary_strings(int k, int max_num, Random generator) {
//  ArrayList<String> results = new ArrayList<>();
//  double num_strings = Math.pow(2, k);
//  int num_strings_int = (int) num_strings;
//  //ArrayList<Integer> already_rand_nums = new ArrayList<Integer>();
  
  
//  for (int i=0; i < max_num; i++) {
//    int current_num = getRandomNumber(generator, 0, num_strings_int);
//    //println(current_num);
//    //while (already_rand_nums.contains(current_num)) {
//    //  current_num = getRandomNumber(0, num_strings_int);
//    //}
//    //already_rand_nums.add(current_num);
//    String format_string = "%" + String.valueOf(k) + "s";
//    String current_binary = String.format(format_string, Integer.toBinaryString(current_num)).replace(' ', '0');
//    results.add(current_binary);
//  }
//  return results;
//}

ArrayList<ArrayList<Integer>> generate_random_binary_numbers(int k, int max_num, Random generator) {
  ArrayList<ArrayList<Integer>> results = new ArrayList<ArrayList<Integer>>();
  double num_strings = Math.pow(2, k);
  int num_strings_int = (int) num_strings;
  for (int i=0; i < max_num; i++) {
    int current_num = getRandomNumber(generator, 0, num_strings_int);
    //int[] current_binary = new int[k];
    ArrayList<Integer> current_binary = new ArrayList<Integer>();
    for (int j = 0; j < k; j++) {
      current_binary.add(0);
    }
    for (int pos = k - 1 ; pos != -1; pos--) {
        int m = (current_num & (1 << pos)) != 0 ? 1 : 0;
        current_binary.set((k - 1) - pos, m);
    }
    results.add(current_binary);
  }
  return results;
}


//ArrayList<String> generate_binary_strings(int k, int max_num) {
//  ArrayList<String> results = new ArrayList<>();
//  double num_strings = Math.pow(2, k);
//  int num_strings_int = (int) num_strings;
//  ArrayList<Integer> already_rand_nums = new ArrayList<Integer>();
  
//  for (int i=0; i < max_num; i++) {
    
//    int current_num = getRandomNumber(0, num_strings_int);
//    while (already_rand_nums.contains(current_num)) {
//      current_num = getRandomNumber(0, num_strings_int);
//    }
//    already_rand_nums.add(current_num);
//    String format_string = "%" + String.valueOf(k) + "s";
//    String current_binary = String.format(format_string, Integer.toBinaryString(current_num)).replace(' ', '0');
//    results.add(current_binary);
//  }
//  return results;
//}

//public int getRandomNumber(int min, int max) {
//    return (int) ((Math.random() * (max - min)) + min);
//}

public int getRandomNumber(Random generator, int min, int max) {
  Integer random = generator.nextInt(min, max);
  return random;
}


public int[][] generate_binary_matrix(int b) {
  int[][] r = new int[(int)Math.pow(2,b)][b];
  int i = 1;
  while (i < r.length) {
    for (int pos = b - 1 ; pos != -1 ; pos--) {
        r[i][(b - 1) - pos] = (i & (1 << pos)) != 0 ? 1 : 0;
    }
     i += 1;
   }
   return r;
 }


public int matrix_index_of_array(int[][] matrix, int[] item) {
  for (int i = 0; i < matrix.length; i++) {
    int[] current_item = matrix[i];
    if (Arrays.equals(current_item, item)) {
      return i;
    }
  }
  println("couldn't match function");
  return -1;
}


public int generate_random_binary_with_prob(Random generator, double prob) {
  boolean val_bool = generator.nextDouble() < prob;
  int value = val_bool ? 1 : 0;
  return value;
}


public int[] concatWithArrayCopy(int[] array1, int[] array2) {
    int[] result = Arrays.copyOf(array1, array1.length + array2.length);
    System.arraycopy(array2, 0, result, array1.length, array2.length);
    return result;
}
