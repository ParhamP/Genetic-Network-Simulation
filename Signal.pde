import java.io.Serializable;
import java.util.*;
public class Signal implements Serializable {
    Node source;
    Node target;

    Signal(Signal signal, Network current_network) {
        Network old_network = signal.source.my_network;
        int source_number = old_network.get_node_number(signal.source);
        int target_number = old_network.get_node_number(signal.target);
        this.source = current_network.get_node(source_number);
        this.target = current_network.get_node(target_number);
    }

    Signal(Node source_node, Node target_node) {
        source = source_node;
        target = target_node;
    }


    Node get_source() {
        return source;
    }

    Node get_target() {
        return target;
    }

    float[] get_source_location() {
        return source.get_location();
    }

    float[] get_target_location() {
        return target.get_location();
    }

    int get_source_value() {
        return source.get_value();
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof Signal)) {
            return false;
        }
        Signal c = (Signal) o;
        return this.source == c.source && this.target == c.target;
    }

    @Override
    public int hashCode() {
        return Objects.hash(source, target);
    }

    @Override
    public String toString() {
        return "[" + String.valueOf(source) + " -> " + String.valueOf(target) + "]";
    }
}
