public class CPUIntensiveTask {
    public static void main(String[] args) {
        while (true) {
            fibonacci(30);
        }
    }

    static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}