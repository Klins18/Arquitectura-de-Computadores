#include <iostream>
#include <bitset>
#include <cstdint>
using namespace std;

// bits de un float
void showBits(string name, float f) {
    uint32_t bits = *reinterpret_cast<uint32_t*>(&f);
    cout << name << " = " << f << " -> " << bitset<32>(bits) << endl;
}

//estructura para partes IEEE 754
struct FloatParts {
    int sign;
    int exponent;
    uint32_t mantissa;
};

FloatParts extractParts(float f) {
    uint32_t bits = *reinterpret_cast<uint32_t*>(&f);
    FloatParts p;
    p.sign = (bits >> 31) & 1;
    p.exponent = (bits >> 23) & 0xFF;
    p.mantissa = bits & 0x7FFFFF; // 23 bits
    return p;
}

int main() {
    float x, y;
    cout << "Ingrese dos numeros float: " << endl;
    cout << "Ingrese el primer float: ";
    cin >> x;
    cout << "Ingrese el segundo float: ";
    cin >> y;

    showBits("X", x);
    showBits("Y", y);

    //verificar cero
    if (x == 0.0f || y == 0.0f) {
        cout << "\nUno de los numeros es 0 -> Resultado: 0.0\n";
        return 0;
    }

    //extraer partes
    FloatParts a = extractParts(x);
    FloatParts b = extractParts(y);

    cout << "\n--- Partes ---" << endl;
    cout << "X -> Signo=" << a.sign << " Exp=" << a.exponent << " Mant=" << bitset<23>(a.mantissa) << endl;
    cout << "Y -> Signo=" << b.sign << " Exp=" << b.exponent << " Mant=" << bitset<23>(b.mantissa) << endl;

    //signo resultado
    int signR = a.sign ^ b.sign;

    //exponente resultado
    int expR = (a.exponent - 127) + (b.exponent - 127) + 127;

    //overflow/underflow
    if (expR >= 255) {
        cout << "\nOverflow -> Resultado = Infinito" << endl;
        return 0;
    }
    if (expR <= 0) {
        cout << "\nUnderflow -> Resultado = 0" << endl;
        return 0;
    }

    //multiplicacion
    uint64_t mantA = (1ULL << 23) | a.mantissa;
    uint64_t mantB = (1ULL << 23) | b.mantissa;
    uint64_t mantR = mantA * mantB;

    //normalizacipn
    if (mantR & (1ULL << 47)) { // si queda 1x.xxxx
        mantR >>= 24;
        expR++;
    } else {
        mantR >>= 23;
    }

    //redondeo
    uint32_t mantissaR = mantR & 0x7FFFFF;

    //reconstruir resultado
    uint32_t resultBits = (signR << 31) | (expR << 23) | mantissaR;
    float result = *reinterpret_cast<float*>(&resultBits);

    cout << "\n--- Resultado ---" << endl;
    showBits("Manual", result);

    float realResult = x * y;
    showBits("C++   ", realResult);

    return 0;
}
