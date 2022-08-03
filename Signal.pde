class Signal {
  PVector location;
  Node source;
  Node target;
  //int quantity;
  
  Signal() {
  }
  
  Signal(Node source_node, Node target_node) {
    source = source_node;
    target = target_node;
    //set_quantity(1);
  }
  
  Node get_source() {
    return source;
  }
  
  Node get_target() {
    return target;
  }
  
  //void set_quantity(int num) {
  //  quantity = num;
  //}
  
  //int get_quantity() {
  //  return quantity;
  //}
  
  PVector get_source_location() {
    return source.get_location();
  }
  
  PVector get_target_location() {
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
