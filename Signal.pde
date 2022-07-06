class Signal {
  PVector location;
  Node source;
  Node target;
  
  Signal() {
  }
  
  Signal(Node source_node, Node target_node) {
    source = source_node;
    target = target_node;
    //source_value = source.get_value();
  }
  
  Node get_source() {
    return source;
  }
  
  Node get_target() {
    return target;
  }
  
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
}
