import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.util.ArrayList;

public class label_quantities_experiment {
    ArrayList<ArrayList<Integer>> label_quantities_list;
    label_quantities_experiment() {
        import_quantities_list("/Users/parhamp/Documents/projects/attractor_evolution/saved_networks/label_quantities_generation_200.dat");
    }

    void print_label_quantities() {
        System.out.println(label_quantities_list);
    }

    public static void main(String[] args){
        label_quantities_experiment a = new label_quantities_experiment();
        a.print_label_quantities();
    }
    public void import_quantities_list(String dest) {
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
        label_quantities_list =  (ArrayList<ArrayList<Integer>>) obj;
    }
}
