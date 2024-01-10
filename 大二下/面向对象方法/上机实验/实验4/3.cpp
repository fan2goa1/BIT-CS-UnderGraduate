#include <iostream>
#include <string>

using namespace std;

class CTyre{
    public:
        friend istream& operator>>(istream &is, CTyre &tyre);             //重载每个类的输入输出
        friend ostream& operator<<(ostream &os, const CTyre &tyre);
    private:
        int number;
};
class CCarDoor{
    public:
        friend istream& operator>>(istream &is, CCarDoor &door);
        friend ostream& operator<<(ostream &os, const CCarDoor &door);
    private:
        int number;
        string color;
};
class CFrame{
    public:
        friend istream& operator>>(istream &is, CFrame &frame);
        friend ostream& operator<<(ostream &os, const CFrame &frame);
    private:
        string id;
        int weight;
};
istream& operator>>(istream &is, CTyre &tyre){
    cout << "请输入Tyre数量: " << endl;
    int num;
    cin >> tyre.number;
    return is;
}
ostream& operator<<(ostream &os, const CTyre &tyre){
    cout << "Tyre数量为: " << tyre.number << ".";
    return os;
}
istream& operator>>(istream &is, CCarDoor &door){
    cout << "请输入door数量: " << endl;
    cin >> door.number;
    cout << "请输入door的颜色: " << endl;
    cin >> door.color;
    return is;
}
ostream& operator<<(ostream &os, const CCarDoor &door){
    cout << "door数量为: " << door.number << ", 颜色为: " << door.color << ".";
    return os;
}
istream& operator>>(istream &is, CFrame &frame){
    cout << "请输入frame的id: " << endl;
    cin >> frame.id;
    cout <<"请输入frame的重量" << endl;
    cin >> frame.weight;
    return is;
}
ostream& operator<<(ostream &os, const CFrame &frame){
    cout << "frame的id为: " << frame.id << ", 重量为: " << frame.weight << ".";
    return os;
}

class CVehicle{
    public:
        CVehicle();
        friend ostream& operator<<(ostream &os, const CVehicle &vehicle);
    private:
        CFrame frame;                           //将每个类的对象作为 Vehicle 类的成员变量, 为composition
        CCarDoor door;
        CTyre tyre;
};
CVehicle::CVehicle(){
    cin >> frame >> door >> tyre;
    cout << "Vehicle created!" << endl;
}
ostream& operator<<(ostream &os, const CVehicle &vehicle) {
    cout << vehicle.frame << endl;
    cout << vehicle.door << endl;
    cout << vehicle.tyre << endl;
}

int main(){
    CVehicle vehicle;
    cout << vehicle << endl;
    return 0;
}