#include <iostream>

using namespace std;
float mil, cp, tf = 0;
float ddfuel(float b)
{
    if (tf + b < cp)
    {
        tf = tf + b;
        cout << "\nnow totl fuel is=" << tf;
    }
    else
    {
        cout << "\n fuel exceeding cp";
    }
}

float remf(int d, float m, float fu)
{
    float rem;
    rem = fu - (d / m);
    if (rem >= 0)
    {
        tf = rem;
        cout << "\nremining fuel is=" << tf;
    }
    else
    {
        cout << "\ninput error,tf is below zero";
    }
}
float estdis(float m, float fu)
{
    int d;
    d = m * fu;
    cout << "est dis with the fuel is=" << d;
}

int main()
{
    float f;
    int dis, ch;
    cout << "enter the cpcity";
    cin >> cp;
    cout << "\n enter the mil";
    cin >> mil;
    while (1)
    {
        cout << "\n 1.dd fuel";
        cout << "\n 2.est dis";
        cout << "\n 3.remining fuel fter dis trvel";
        cout << "\n 4.exit";
        cout << "\n enter choice";
        cin >> ch;
        switch (ch)
        {
        case 1:
            cout << "\nfuel";
            cin >> f;
            ddfuel(f);
            break;
        case 2:
            cout << "\nest distnce with remining fuel";
            estdis(mil, tf);
            break;
        case 3:
            cout << "\nenter distence";
            cin >> dis;
            remf(dis, mil, tf);
            break;
        case 4:
            return 0;
            break;
        default:
            cout << "enter vlid option";
        }
    }

    return 0;
}