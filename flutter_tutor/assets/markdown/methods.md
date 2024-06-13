# Methods

方法是为对象提供行为的函数。

## 实例方法

对象上的实例方法可以访问实例变量和 `this`。
以下示例中的 `distanceTo()` 方法是一个实例方法的例子：

```dart
import 'dart:math';

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

## 运算符

大多数运算符是具有特殊名称的实例方法。
Dart 允许你使用以下名称定义运算符：

|       |      |      |      |       |      |
|-------|------|------|------|-------|------|
| `<`   | `>`  | `<=` | `>=` | `==`  | `~`  |
| `-`   | `+`  | `/`  | `~/` | `*`   | `%`  |
| `\|`  | `ˆ`  | `&`  | `<<` | `>>>` | `>>` |
| `[]=` | `[]` |      |      |       |      |

> note
> 你可能已经注意到，一些运算符，比如 `!=`，不在名称列表中。这些运算符不是实例方法。它们的行为是内置在 Dart 中的。

要声明一个运算符，使用内置标识符 `operator`，然后是你要定义的运算符。
以下示例定义了向量加法 (`+`)、减法 (`-`) 和相等 (`==`)：

```dart
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  final v = Vector(2, 3);
  final w = Vector(2, 2);

  assert(v + w == Vector(4, 5));
  assert(v - w == Vector(0, 1));
}
```

## Getters and setters

Getter 和 Setter 是提供读取和写入对象属性的特殊方法。请记住，每个实例变量都有一个隐式的 getter，如果合适的话，还有一个 setter。你可以通过使用 `get` 和 `set` 关键字来实现 getter 和 setter，从而创建额外的属性：

```dart
class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  double get right => left + width;
  set right(double value) => left = value - width;
  double get bottom => top + height;
  set bottom(double value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);
  assert(rect.left == 3);
  rect.right = 12;
  assert(rect.left == -8);
}
```

通过使用 getter 和 setter，你可以从实例变量开始，随后用方法包装它们，而无需更改客户端代码。

> note
> 运算符如递增（++）无论是否显式定义了 getter 都能按预期工作。为了避免任何意外的副作用，运算符会调用 getter 一次，并将其值保存在临时变量中。

## Abstract methods

实例方法、getter 和 setter 方法可以是抽象的，定义接口但将其实现留给其他类。抽象方法只能存在于抽象类或混入中。

要使一个方法成为抽象方法，使用分号 (`;`) 代替方法体：

```dart
abstract class Doer {
  // Define instance variables and methods...

  void doSomething(); // Define an abstract method.
}

class EffectiveDoer extends Doer {
  void doSomething() {
    // Provide an implementation, so the method is not abstract here...
  }
}
```
