# Enums

枚举类型，通常称为_枚举_或_enums_，是一种特殊的类，用于表示固定数量的常量值。

> note
> 所有枚举都自动继承`Enum`类。它们也是封闭的，意味着不能被子类化、实现、混入或以其他方式显式实例化。
> 抽象类和混入类可以显式实现或扩展`Enum`，但除非它们随后被枚举声明所实现或混入，否则没有对象可以实际实现该类或混入类的类型。

## 声明简单枚举

要声明一个简单的枚举类型，使用`enum`关键字并列出你想要枚举的值：

```dart
enum Color { red, green, blue }
```

## 声明增强枚举

Dart 还允许枚举声明类，其中包含字段、方法和常量构造函数，这些类限制为固定数量的已知常量实例。

要声明增强枚举，请遵循类似于普通类的语法，但有一些额外的要求：

* 实例变量必须是`final`，包括那些由混入添加的变量。
* 所有生成构造函数必须是常量的。
* 工厂构造函数只能返回固定的、已知的枚举实例之一。
* 不能扩展其他类，因为`Enum`会自动扩展。
* 不能重写`index`、`hashCode`、相等运算符`==`。
* 枚举中不能声明名为`values`的成员，因为它会与自动生成的静态`values` getter冲突。
* 枚举的所有实例必须在声明的开头声明，并且必须至少声明一个实例。

增强枚举中的实例方法可以使用`this`来引用当前的枚举值。

下面是一个声明增强枚举的示例，其中包含多个实例、实例变量、getter 和已实现的接口：

```dart
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  const Vehicle({
    required this.tires,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonFootprint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
```

＞　version-note
＞　增强枚举要求语言版本至少为 2.17。

## 使用枚举

像访问其他静态变量一样访问枚举值：

```dart
final favoriteColor = Color.blue;
if (favoriteColor == Color.blue) {
  print('Your favorite color is blue!');
}
```

枚举中的每个值都有一个`index` getter，它返回该值在枚举声明中的基于零的位置。例如，第一个值的索引为 0，第二个值的索引为 1。

```dart
assert(Color.red.index == 0);
assert(Color.green.index == 1);
assert(Color.blue.index == 2);
```

要获取所有枚举值的列表，请使用枚举的`values`常量。

```dart
List<Color> colors = Color.values;
assert(colors[2] == Color.blue);
```

你可以在 switch 语句中使用枚举，如果没有处理所有枚举值，将会收到警告：

```dart
var aColor = Color.blue;

switch (aColor) {
  case Color.red:
    print('Red as roses!');
  case Color.green:
    print('Green as grass!');
  default: // Without this, you see a WARNING.
    print(aColor); // 'Color.blue'
}
```

如果你需要访问枚举值的名称，比如从 `Color.blue` 中获取 `'blue'`，请使用 `.name` 属性：

```dart
print(Color.blue.name); // 'blue'
```

你可以像访问普通对象那样访问枚举值的成员：

```dart
print(Vehicle.car.carbonFootprint);
```
