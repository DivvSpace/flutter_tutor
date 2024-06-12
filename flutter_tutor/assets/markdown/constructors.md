# Constructors

构造函数是创建类实例的特殊函数。

Dart 实现了多种类型的构造函数。
除了默认构造函数之外，
这些函数使用与其类相同的名称。

* 生成型构造函数：创建新实例并初始化实例变量。
* 默认构造函数：用于在未指定构造函数时创建新实例。它不接受参数且没有名称。
* 命名构造函数：明确构造函数的用途或允许为同一类创建多个构造函数。
* 常量构造函数：创建作为编译时常量的实例。
* 工厂构造函数：可以创建子类型的新实例或从缓存中返回现有实例。
* 重定向构造函数：将调用转发到同一类中的另一个构造函数。

## Types of constructors

### Generative constructors

要实例化一个类，请使用生成型构造函数。

```dart
class Point {
  // Initializer list of variables and values
  double x = 2.0;
  double y = 2.0;

  // Generative constructor with initializing formal parameters:
  Point(this.x, this.y);
}
```

### Default constructors

如果你不声明构造函数，Dart 会使用默认构造函数。
默认构造函数是一个没有参数和名称的生成型构造函数。

### Named constructors

使用命名构造函数来为一个类实现多个构造函数或提供额外的清晰度：

```dart
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  // Named constructor
  Point.origin()
      : x = xOrigin,
        y = yOrigin;
}
```

子类不会继承超类的命名构造函数。
要创建一个带有在超类中定义的命名构造函数的子类，需要在子类中实现该构造函数。

### Constant constructors

如果你的类生成不变的对象，使这些对象成为编译时常量。
要使对象成为编译时常量，定义一个 `const` 构造函数，并将所有实例变量设置为 `final`。

```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

常量构造函数并不总是创建常量。
它们可能在非 `const` 上下文中被调用。
要了解更多，请参阅使用构造函数的部分。

### 重定向构造函数

构造函数可能会重定向到同一个类中的另一个构造函数。
重定向构造函数有一个空的函数体。
该构造函数在冒号 (:) 之后使用 `this` 而不是类名。

```dart
class Point {
  double x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
```

### Factory constructors

遇到以下两种实现构造函数的情况时，使用 `factory` 关键字：

* 构造函数并不总是创建其类的新实例。虽然工厂构造函数不能返回 `null`，但它可能返回：

  * 来自缓存的现有实例，而不是创建一个新的实例
  * 子类型的新实例

* 在构造实例之前需要执行重要的工作。这可能包括检查参数或执行初始化列表中无法处理的任何其他处理。

> tip
> 你也可以使用 `late final`（小心使用！）来处理最终变量的延迟初始化。

以下示例包含两个工厂构造函数。

* `Logger` 工厂构造函数从缓存中返回对象。
* `Logger.fromJson` 工厂构造函数从 JSON 对象初始化一个最终变量。

```dart
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
```

> warning
> 工厂构造函数不能访问 `this`。

像使用其他构造函数一样使用工厂构造函数：

```dart
var logger = Logger('UI');
logger.log('Button clicked');

var logMap = {'name': 'UI'};
var loggerJson = Logger.fromJson(logMap);
```

### 重定向工厂构造函数

重定向工厂构造函数指定调用另一个类的构造函数，以便在有人调用重定向构造函数时使用。

```dart
factory Listenable.merge(List<Listenable> listenables) = _MergingListenable
```

看起来普通的工厂构造函数可以创建并返回其他类的实例。
这会使重定向工厂变得不必要。
但是，重定向工厂有几个优点：

* 抽象类可能提供一个使用另一个类的常量构造函数的常量构造函数。
* 重定向工厂构造函数避免了转发器重复形式参数及其默认值的需要。

### Constructor tear-offs

Dart 允许你将构造函数作为参数传递而不调用它。这被称为 _tear-offs_（因为你tear off括号），它作为一个闭包，用相同的参数调用构造函数。

如果tear-offs是一个具有相同签名和返回类型的构造函数，且方法接受这个类型，你可以将tear-offs作为参数或变量使用。

tear-offs不同于 lambda 或匿名函数。Lambda 作为构造函数的包装器，而tear-offs就是构造函数。

**Use Tear-Offs**

```dart tag=good
// Use a tear-off for a named constructor: 
var strings = charCodes.map(String.fromCharCode);  

// Use a tear-off for an unnamed constructor: 
var buffers = charCodes.map(StringBuffer.new); 
```

**Not Lambdas**

```dart tag=bad
// Instead of a lambda for a named constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Instead of a lambda for an unnamed constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```

## 实例变量初始化

Dart 可以通过三种方式初始化变量。

### 在声明时初始化实例变量

在声明变量时初始化实例变量。

```dart
class PointA {
  double x = 1.0;
  double y = 2.0;

// 隐式默认构造函数将这些变量设置为 (1.0,2.0)
// PointA();

  @override
  String toString() {
    return 'PointA($x,$y)';
  }
}
```

### 使用初始化形式参数

为了简化将构造函数参数赋值给实例变量的常见模式，Dart 提供了*初始化形式参数*。

在构造函数声明中，包括 `this.<propertyName>` 并省略函数体。`this` 关键字指的是当前实例。

当存在名称冲突时，使用 `this`。否则，Dart 风格会省略 `this`。对于生成构造函数，必须用 `this` 前缀初始化形式参数的名称，这是一个例外。

如本指南前面所述，某些构造函数和构造函数的某些部分无法访问 `this`。这些包括：

* 工厂构造函数
* 初始化列表的右侧
* 超类构造函数的参数

初始化形式参数还允许你初始化不可为空或 `final` 实例变量。这两种类型的变量都需要初始化或默认值。

```dart
class PointB {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  PointB(this.x, this.y);

  // Initializing formal parameters can also be optional.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
```

私有字段不能用作命名的初始化形式参数。

不要将以下示例附加到代码摘录中。它有意不工作，并将在 CI 中引发错误。

```dart
class PointB {
// ...

  PointB.namedPrivate({required double x, required double y})
      : _x = x,
        _y = y;

// ...
}
```

这也适用于命名变量。

```dart
class PointC {
  double x; // must be set in constructor
  double y; // must be set in constructor

  // Generative constructor with initializing formal parameters
  // with default values
  PointC.named({this.x = 1.0, this.y = 1.0});

  @override
  String toString() {
    return 'PointC.named($x,$y)';
  }
}

// Constructor using named variables.
final pointC = PointC.named(x: 2.0, y: 2.0);
```

通过初始化形式参数引入的所有变量都是final的，并且仅在已初始化变量的范围内有效。

要执行无法在初始化列表中表达的逻辑，可以创建带有该逻辑的工厂构造函数或静态方法。然后你可以将计算出的值传递给普通构造函数。

构造函数参数可以设置为可为空且不被初始化。

```dart
class PointD {
  double? x; // null if not set in constructor
  double? y; // null if not set in constructor

  // Generative constructor with initializing formal parameters
  PointD(this.x, this.y);

  @override
  String toString() {
    return 'PointD($x,$y)';
  }
}
```

### Use an initializer list

在构造函数体运行之前，你可以初始化实例变量。用逗号分隔初始化器。

```dart
// 初始化列表在构造函数体运行之前设置实例变量。
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

> warning
> 初始化列表的右侧不能访问 `this`。

要在开发过程中验证输入，请在初始化列表中使用 `assert`。

```dart
Point.withAssert(this.x, this.y) : assert(x >= 0) {
  print('In Point.withAssert(): ($x, $y)');
}
```

## 构造函数继承

子类不从它们的超类（或直接父类）继承构造函数。如果一个类没有声明构造函数，它只能使用默认构造函数。

一个类可以继承超类的参数。这些参数称为超级参数。

构造函数的工作方式有点类似于调用一系列静态方法。每个子类可以调用其超类的构造函数来初始化一个实例，就像子类可以调用超类的静态方法一样。这个过程不会“继承”构造函数的主体或签名。

### 非默认的超类构造函数

Dart 按以下顺序执行构造函数：

1. 初始化列表
2. 超类的无命名、无参数构造函数
3. 主类的无参数构造函数

如果超类没有无命名、无参数构造函数，调用超类中的一个构造函数。在构造函数体（如果有的话）之前，在冒号（`:`）之后指定超类构造函数。

在以下示例中，`Employee` 类的构造函数调用了其超类 `Person` 的命名构造函数。

```dart
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson().
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  var employee = Employee.fromJson({});
  print(employee);
  // Prints:
  // in Person
  // in Employee
  // Instance of 'Employee'
}
```

由于 Dart 在调用构造函数之前评估传递给超类构造函数的参数，因此参数可以是像函数调用这样的表达式。

```dart
class Employee extends Person {
  Employee() : super.fromJson(fetchDefaultData());
  // ···
}
```

> warning
> 传递给超类构造函数的参数不能访问 `this`。例如，参数可以调用*静态*方法，但不能调用*实例*方法。

### 超参数

为了避免在构造函数的超级调用中传递每个参数，可以使用超级初始化参数将参数转发到指定的或默认的超类构造函数。重定向构造函数不能使用此功能。超级初始化参数的语法和语义类似于初始化形式参数。

> version-note
> 使用超级初始化参数需要语言版本至少为 2.17。如果您使用的是较早的语言版本，必须手动传递所有超类构造函数参数。

如果超类构造函数调用包含位置参数，超级初始化参数不能是位置参数。

```dart
class Vector2d {
  final double x;
  final double y;

  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the x and y parameters to the default super constructor like:
  // Vector3d(final double x, final double y, this.z) : super(x, y);
  Vector3d(super.x, super.y, this.z);
}
```

为了进一步说明，请考虑以下示例。

```dart
// 如果你在调用超类构造函数（`super(0)`）时使用了任何位置参数，
// 使用超级参数（`super.x`）会导致错误。
  Vector3d.xAxisError(super.x): z = 0, super(0); // BAD
```

这个命名构造函数尝试两次设置 `x` 值：一次在超类构造函数中，另一次作为位置超级参数。由于两者都涉及 `x` 位置参数，这会导致错误。

当超类构造函数具有命名参数时，您可以将它们分配到命名超级参数（在下一个示例中为 `super.y`）和超类构造函数调用的命名参数（`super.named(x: 0)`）。

```dart
class Vector2d {
  // ...
  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the y parameter to the named super constructor like:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
```
