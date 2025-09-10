#include <iostream>
#include <vector>
#include <bitset>
using namespace std;

// convirtiendo entero a binario con una cantidad de n bits (soporta negativos con complemento a 2)
string toBinary(int num, int n) {
    return bitset<32>(num).to_string().substr(32 - n, n);
}

// algoritmo de Booth
void boothMultiplication(int M, int Q, int n) {
    int A = 0;
    int Q_1 = 0;
    int count = n;

    cout << "Multiplicando (M) = " << M << " -> " << toBinary(M, n) << endl;
    cout << "Multiplicador (Q) = " << Q << " -> " << toBinary(Q, n) << endl;
    cout << "-------------------------------" << endl;

    while (count > 0) {
        int Q0 = Q & 1; //el bit menos significativo de Q

        // decision segun (Q0, Q-1)
        if (Q0 == 0 && Q_1 == 1) {
            A = A + M;
            cout << "(Q0,Q-1=01) A = A + M -> " << toBinary(A, n) << endl;
        } else if (Q0 == 1 && Q_1 == 0) {
            A = A - M;
            cout << "(Q0,Q-1=10) A = A - M -> " << toBinary(A, n) << endl;
        }

        // desplazamiento aritmetico derecha (A,Q,Q-1)
        int signA = (A >> (n - 1)) & 1; 
        Q_1 = Q & 1;
        Q = (A & 1) << (n - 1) | (Q >> 1); 
        A = (A >> 1) | (signA << (n - 1)); 

        count--;

        cout << "Shift -> A:" << toBinary(A, n)
             << " Q:" << toBinary(Q, n)
             << " Q-1:" << Q_1 << " count=" << count << endl;
    }

    long long result = ((long long)A << n) | (Q & ((1 << n) - 1));
    cout << "Resultado final en binario: " << toBinary(A, n) << " " << toBinary(Q, n) << endl;
    cout << "Resultado decimaal: " << result << endl;
}

int main() {
    int M, Q, n;
    cout << "Ingrese multiplicando (M): ";
    cin >> M;
    cout << "Ingrese multiplicador (Q): ";
    cin >> Q;
    cout << "Ingrese cantidad de bits n: ";
    cin >> n;

    boothMultiplication(M, Q, n);

    return 0;
}
