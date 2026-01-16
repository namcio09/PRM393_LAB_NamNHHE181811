import 'package:flutter/material.dart';
import 'dart:async';
Future<void> main() async{ // dung await phai co async o ham va tra ve 1 Future
  print("==== Exercise 1 ====");
  // declare
  int a = 2;
  double b = 2.5;
  String c = "yennhi";
  bool d = true;
  //print
  print("a = ${a + 1}");
  print("b = $b");
  print("c = $c");
  print("d = $d");


  print("==== Exercise 2 ====");
  List<int> nums = [1,2,3,4,5];
  //indexing, add(), remove()
  print("Initial list: $nums");
  print("nums[0] = ${nums[0]}"); // indexing

  nums.add(10); // add()
  print("After add(10): $nums");

  nums.remove(4); // remove value 4
  print("After remove(4): $nums");
  // Use arithmetic & comparison operators
  int a_nums = nums[0]; // 10
  int b_nums = nums[1]; // 30 (because 20 was removed)
  int sum = a_nums + b_nums;
  int diff = b_nums - a_nums;

  print("a_nums = $a_nums, b_nums = $b_nums");
  print("a_nums + b_nums = $sum");
  print("b_nums - a_nums = $diff");

  bool isEqual = (a == b);       // ==
  bool isGreater = (b > a);      // comparison
  print("a_nums == b_nums ? $isEqual");
  print("b_nums > a_nums ? $isGreater");

  // && (logical AND) + ? : (ternary)
  bool condition = (sum > 30) && (diff >= 10);
  String result = condition ? "Condition TRUE" : "Condition FALSE";
  print("Condition check: $result");

  // Create a Set (unique values)
  Set<int> uniqueNums = {1, 2, 2, 3, 3, 3};
  print("Set (unique values): $uniqueNums"); // {1, 2, 3}

  uniqueNums.add(4);
  uniqueNums.remove(2);
  print("Set after add(4) & remove(2): $uniqueNums");

  // Create a Map (key-value) + 4) map access
  Map<String, int> scores = {
    "An": 8,
    "Binh": 9,
    "Chi": 7,
  };

  print("Map: $scores");
  print("Score of Binh = ${scores["Binh"]}"); // access by key

  // update / add new key
  scores["An"] = 10;
  scores["Dung"] = 6;
  print("Map after updates: $scores");

  // remove a key
  scores.remove("Chi");
  print("Map after remove('Chi'): $scores");

  print("==== Exercise 3 ====");
  // 1) if/else block to check score
  int score = 78;

  if (score >= 90) {
    print("Score $score: Excellent");
  } else if (score >= 75) {
    print("Score $score: Good");
  } else if (score >= 50) {
    print("Score $score: Pass");
  } else {
    print("Score $score: Fail");
  }

  // 2) switch case for day of week
  int day = 3; // 1..7
  switch (day) {
    case 1:
      print("Day $day: Monday");
      break;
    case 2:
      print("Day $day: Tuesday");
      break;
    case 3:
      print("Day $day: Wednesday");
      break;
    case 4:
      print("Day $day: Thursday");
      break;
    case 5:
      print("Day $day: Friday");
      break;
    case 6:
      print("Day $day: Saturday");
      break;
    case 7:
      print("Day $day: Sunday");
      break;
    default:
      print("Invalid day: $day (must be 1..7)");
  }

  // 3) Loop through a collection using for, for-in, and forEach()
  List<String> names = ["An", "Binh", "Chi"];

  // for (index-based)
  print("Loop with for:");
  for (int i = 0; i < names.length; i++) {
    print("names[$i] = ${names[i]}");
  }

  // for-in
  print("Loop with for-in:");
  for (final n in names) {
    print("name = $n");
  }

  // forEach()
  print("Loop with forEach:");
  names.forEach((n) {
    print("name = $n");
  });

  // 4) Create functions using normal and arrow syntax
  int so1 = 10;
  int so2 = 5;

  int s1 = add(so1, so2); // normal function
  int s2 = subtract(so1, so2); // arrow function

  print("add($so1, $so2) = $s1");
  print("subtract($so1, $so2) = $s2");

  print("==== Exercise 4 ====");
  Car car1 = Car("Toyota");
  print("car1 brand: ${car1.brand}");
  print(car1.drive());

  Car car2 = Car.used("Honda"); // named constructor
  print("car2 brand: ${car2.brand}");
  print(car2.drive());

  ElectricCar e1 = ElectricCar("Tesla", 80);
  print("e1 brand: ${e1.brand}, battery: ${e1.batteryPercent}%");
  print(e1.drive()); // overridden method


  print("==== Exercise 5 ====");
  //asynch using Future + Await
  print("Start");
  String data = await fetchData();
  print ("Fetch data: $data");

  //Null-safety operator
  String? name; // co the null
  print("name length O: ${name?.length}");

  String displayName = name ?? "Guest"; // name null thi lay guest

  name = "hainam";
  print("name length X: ${name?.length}");

  int forcedLength = name!.length; // neu null thi nem ra exception
  print("forcedLength: $forcedLength");

  //Stream of integer and listen
  Stream<int> numberStream = createNumberStream();
  print("Listening to stream....");
  await for (final value in numberStream){
    print("Stream value: $value");
  }



}

Stream<int> createNumberStream() async* {
  for (int i = 0; i <= 5; i++){
    await Future.delayed(const Duration(milliseconds: 500));
    yield i;
  }
}

Future<String> fetchData() async {
  print("Loading...");
  await Future.delayed(const Duration(seconds: 2));
  return "Hello from Future";
}

// Normal function syntax
int add(int x, int y) {
  return x + y;
}

// Arrow function syntax
int subtract(int x, int y) => x - y;

// 1) Class Car with one property and a method
class Car {
  String brand;

  // default constructor
  Car(this.brand);

  // 2) Named constructor
  Car.used(String brand) : brand = "$brand (Used)";

  // method
  String drive() {
    return "Car $brand is driving with gasoline.";
  }
}

// 3) Subclass ElectricCar overrides a method
class ElectricCar extends Car {
  int batteryPercent;

  ElectricCar(String brand, this.batteryPercent) : super(brand);

  @override
  String drive() {
    return "ElectricCar $brand is driving on battery ($batteryPercent%).";
  }
}
