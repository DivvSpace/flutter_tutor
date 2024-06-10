# Classes

Dart 是一种面向对象的语言，具有类和基于混入的继承。每个对象都是一个类的实例，除了 `Null` 之外的所有类都继承自 `Object`。
*基于混入的继承* 意味着尽管每个类（除了 顶级类，即 `Object?`）都有一个唯一的超类，但类可以在多个类层次结构中重复使用。
扩展方法 是一种在不更改类或创建子类的情况下为类添加功能的方法。
类修饰符 允许你控制库如何对一个类进行子类型化。

## Using class members

对象有包含函数和数据的*成员*（分别是*方法*和*实例变量*）。当你调用一个方法时，你是在一个对象上*调用*它：该方法可以访问该对象的函数和数据。

使用点号（`.`）来引用实例变量或方法：

```dart
var p = Point(2, 2);

// Get the value of y.
assert(p.y == 2);

// Invoke distanceTo() on p.
double distance = p.distanceTo(Point(4, 4));
```

当最左边的操作数为 null 时，使用 `?.` 而不是 `.` 以避免异常：

```dart
// If p is non-null, set a variable equal to its y value.
var a = p?.y;
```

## Using constructors

你可以使用*构造函数*创建一个对象。构造函数名称可以是 ClassName 或 ClassName.identifier。例如，以下代码使用 `Point()` 和 `Point.fromJson()` 构造函数创建 `Point` 对象：

```dart
var p1 = Point(2, 2);
var p2 = Point.fromJson({'x': 1, 'y': 2});
```

以下代码具有相同的效果，但在构造函数名称之前使用了可选的 `new` 关键字：

```dart
var p1 = new Point(2, 2);
var p2 = new Point.fromJson({'x': 1, 'y': 2});
```

一些类提供常量构造函数。要使用常量构造函数创建编译时常量，请在构造函数名称之前加上 `const` 关键字：

```dart
var p = const ImmutablePoint(2, 2);
```

构造两个相同的编译时常量会生成一个单一的、规范的实例：

```dart
var a = const ImmutablePoint(1, 1);
var b = const ImmutablePoint(1, 1);

assert(identical(a, b)); // They are the same instance!
```

在一个**常量上下文**中，你可以省略构造函数或字面量前的 `const`。例如，看看这段代码，它创建了一个 const map：

```dart
// Lots of const keywords here.
const pointAndLine = const {
  'point': const [const ImmutablePoint(0, 0)],
  'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
};
```

你可以省略除第一次使用 `const` 关键字之外的所有其他使用：

```dart
// Only one const, which establishes the constant context.
const pointAndLine = {
  'point': [ImmutablePoint(0, 0)],
  'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
};
```

如果常量构造函数在常量上下文之外，并且在调用时没有使用 `const`，它将创建一个**非常量对象**：

```dart
var a = const ImmutablePoint(1, 1); // Creates a constant
var b = ImmutablePoint(1, 1); // Does NOT create a constant

assert(!identical(a, b)); // NOT the same instance!
```

## Getting an object's type

要在运行时获取对象的类型，你可以使用 `Object` 属性 `runtimeType`，它返回一个 `Type` 对象。

```dart
print('The type of a is ${a.runtimeType}');
```

> warning
> 使用类型测试运算符而不是 `runtimeType` 来测试对象的类型。
> 在生产环境中，测试 `object is Type` 比测试 `object.runtimeType == Type` 更稳定。

到目前为止，你已经看到了如何**使用**类。本节的其余部分将展示如何**实现**类。

## 实例变量

以下是声明实例变量的方法：

```dart
class Point {
  double? x; // Declare instance variable x, initially null.
  double? y; // Declare y, initially null.
  double z = 0; // Declare z, initially 0.
}
```

未初始化的用可空类型声明的实例变量的值是 `null`。非空实例变量必须在声明时初始化。

所有实例变量都会生成一个隐式的*getter*方法。非final实例变量和没有初始值的`late final`实例变量也会生成一个隐式的*setter*方法。详情请参阅 Getters and setters。

```dart
class Point {
  double? x; // 声明实例变量 x，初始值为 null。
  double? y; // Declare y, initially null.
}

void main() {
  var point = Point();
  point.x = 4; // Use the setter method for x.
  assert(point.x == 4); // Use the getter method for x.
  assert(point.y == null); // Values default to null.
}
```

在声明处初始化一个非`late`实例变量，会在实例创建时设置该值，在构造函数及其初始化列表执行之前。因此，非`late`实例变量的初始化表达式（在 `=` 之后）不能访问 `this`。

```dart
double initialX = 1.5;

class Point {
  // OK，能访问不依赖于 `this` 的声明：
  double? x = initialX;

  // Error，不能在非`late`初始化器中访问 `this`：
  double? y = this.x;

  // OK，能在 `late` 初始化器中访问 `this`：
  late double? z = this.x;

  // OK，`this.x` 和 `this.y` 是参数声明，不是表达式：
  Point(this.x, this.y);
}
```

实例变量可以是 `final`，在这种情况下它们必须被设置一次。在声明时初始化 `final` 非`late`实例变量，使用构造函数参数，或者使用构造函数的初始化列表：

```dart
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

如果需要在构造函数体开始后为 `final` 实例变量赋值，可以使用以下方法之一：

* 使用工厂构造函数。
* 使用 `late final`，但**请注意：**没有初始化器的 `late final` 会向 API 添加一个 setter。

## 隐式接口

每个类隐式定义了一个接口，该接口包含类的所有实例成员以及它实现的任何接口。如果你想创建一个支持类 B 的 API 但不继承 B 实现的类 A，则类 A 应该实现 B 接口。

一个类通过在 implements 子句中声明它们来实现一个或多个接口，然后提供接口所需的 API。例如：

```dart
// A person. The implicit interface contains greet().
class Person {
  // In the interface, but visible only in this library.
  final String _name;

  // Not in the interface, since this is a constructor.
  Person(this._name);

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Impostor implements Person {
  String get _name => '';

  String greet(String who) => 'Hi $who. Do you know who I am?';
}

String greetBob(Person person) => person.greet('Bob');

void main() {
  print(greetBob(Person('Kathy')));
  print(greetBob(Impostor()));
}
```

下面是一个指定一个类实现多个接口的示例：

```dart
class Point implements Comparable, Location {...}
```

## 类变量和方法

使用 static 关键字实现类范围的变量和方法。

静态变量
静态变量（类变量）对于类范围的状态和常量非常有用：

```dart
class Queue {
  static const initialCapacity = 16;
  // ···
}

void main() {
  assert(Queue.initialCapacity == 16);
}
```

静态变量在使用之前不会被初始化。

## 静态方法

静态方法（类方法）不对实例进行操作，因此无法访问 this。但是，它们可以访问静态变量。如下例所示，你可以直接在类上调用静态方法：

```dart
import 'dart:math';

class Point {
  double x, y;
  Point(this.x, this.y);

  static double distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  var a = Point(2, 2);
  var b = Point(4, 4);
  var distance = Point.distanceBetween(a, b);
  assert(2.8 < distance && distance < 2.9);
  print(distance);
}
```

> note
> 考虑使用顶级函数而不是静态方法来实现常用或广泛使用的实用功能。

你可以将静态方法用作编译时常量。例如，你可以将静态方法作为参数传递给一个常量构造函数。
