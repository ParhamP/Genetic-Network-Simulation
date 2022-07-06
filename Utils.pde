//// Function to generate all binary strings
//static void generateAllBinaryStrings(int n,
//                            int arr[], int i)
//{
//    if (i == n)
//    {
//        printTheArray(arr, n);
//        println(arr.length);
//        return;
//    }
 
//    // First assign "0" at ith position
//    // and try for all other permutations
//    // for remaining positions
//    arr[i] = 0;
//    generateAllBinaryStrings(n, arr, i + 1);
 
//    // And then assign "1" at ith position
//    // and try for all other permutations
//    // for remaining positions
//    arr[i] = 1;
//    generateAllBinaryStrings(n, arr, i + 1);
//}

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
