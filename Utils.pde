static void printTheArray(int arr[])
{
    int n = arr.length;
    for (int i = 0; i < n; i++)
    {
        System.out.print(arr[i]+" ");
    }
    System.out.println();
}

ArrayList<String> generate_binary_strings(int k) {
  ArrayList<String> results = new ArrayList<>();
  double num_strings = Math.pow(2, k);
  int num_strings_int = (int) num_strings;
  for (int i=0; i < num_strings_int; i++) {
    String format_string = "%" + String.valueOf(k) + "s";
    String current_binary = String.format(format_string, Integer.toBinaryString(i)).replace(' ', '0');
    results.add(current_binary);
  }
  return results;
}


ArrayList<String> generate_binary_strings(int k, int max_num, Random generator) {
  ArrayList<String> results = new ArrayList<>();
  double num_strings = Math.pow(2, k);
  int num_strings_int = (int) num_strings;
  //ArrayList<Integer> already_rand_nums = new ArrayList<Integer>();
  
  
  for (int i=0; i < max_num; i++) {
    int current_num = getRandomNumber(generator, 0, num_strings_int);
    //println(current_num);
    //while (already_rand_nums.contains(current_num)) {
    //  current_num = getRandomNumber(0, num_strings_int);
    //}
    //already_rand_nums.add(current_num);
    String format_string = "%" + String.valueOf(k) + "s";
    String current_binary = String.format(format_string, Integer.toBinaryString(current_num)).replace(' ', '0');
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
    
//    int current_num = getRandomNumber(0, num_strings_int); //<>//
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
