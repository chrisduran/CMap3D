public static class Utility {
 
  static int fact (int n) {
    if (n <= 1) {
      return 1;
    } else {
      return n * fact(n-1);
    }
  }
 
  static int pascal(int n, int k) {
    return fact(n) / fact(k)/fact(n-k);
  } 
  
}


