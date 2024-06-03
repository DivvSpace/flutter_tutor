# Patterns

> version-note
> Patterns require a language version of at least 3.0.

模式匹配是 Dart 语言中的一个语法类别，类似于语句和表达式。模式表示一组值的形状，它可以与实际值进行匹配。

本页描述了：

- 模式的功能。
- 模式在 Dart 代码中的允许位置。
- 模式的常见使用场景。

要了解不同种类的模式，请访问模式类型页面。

## What patterns do

一般来说，一个模式可以**匹配**一个值、**解构**一个值，或者两者兼有，具体取决于模式的上下文和形状。

首先，_模式匹配_ 允许你检查一个给定的值是否：

- 具有某种形状。
- 是某个特定的常量。
- 等于其他某物。
- 具有某种类型。

然后，_模式解构_ 为你提供了一种方便的声明性语法，用于将该值分解成其组成部分。在此过程中，同一个模式也可以让你将变量绑定到这些部分的某些或全部上。

### Matching

模式总是针对一个值进行测试，以确定该值是否具有你期望的形式。换句话说，你在检查该值是否 _匹配_ 模式。

什么构成匹配取决于你使用的模式种类。例如，如果值等于模式的常量，则常量模式匹配：

```dart
switch (number) {
  // Constant pattern matches if 1 == number.
  case 1:
    print('one');
}
```

许多模式使用子模式，有时分别称为 _外部_ 和 _内部_ 模式。模式在其子模式上递归匹配。例如，任何 集合类型 模式的各个字段都可以是 变量模式 或 常量模式：

```dart
const a = 'a';
const b = 'b';
switch (obj) {
 // 列表模式 [a, b] 首先匹配 obj，如果 obj 是一个具有两个字段的列表，
  // 然后再匹配其字段是否符合常量子模式 'a' 和 'b'。
  case [a, b]:
    print('$a, $b');
}
```

要忽略匹配值的某些部分，可以使用通配符模式作为占位符。在列表模式的情况下，可以使用剩余元素。

### 解构

当一个对象和模式匹配时，模式可以访问对象的数据并将其部分提取。换句话说，模式 _解构_ 了对象：

```dart
var numList = [1, 2, 3];
// 列表模式 [a, b, c] 从 numList 解构出三个元素...
var [a, b, c] = numList;
// ...并将它们赋值给新的变量。
print(a + b + c);
```

你可以在解构模式中嵌套任何类型的模式。例如，这个案例模式匹配并解构了一个其第一个元素为 `'a'` 或 `'b'` 的两元素列表：

```dart
switch (list) {
  case ['a' || 'b', var c]:
    print(c);
}
```

## Places patterns can appear

你可以在 Dart 语言的多个地方使用模式：

- 局部变量声明和赋值
- for 和 for-in 循环
- if-case 和 switch-case
- 集合字面量中的控制流

本节描述了使用模式进行匹配和解构的常见用例。

### 变量声明

你可以在 Dart 允许局部变量声明的任何地方使用 _模式变量声明_。该模式与声明右侧的值进行匹配。一旦匹配成功，它会解构该值并将其绑定到新的局部变量：

```dart
// Declares new variables a, b, and c.
var (a, [b, c]) = ('str', [1, 2]);
```

模式变量声明必须以 `var` 或 `final` 开头，后跟一个模式。

### 变量赋值

_变量赋值模式_ 位于赋值语句的左侧。首先，它会解构匹配的对象。然后，它将值赋给 _现有_ 的变量，而不是绑定新的变量。

使用变量赋值模式来交换两个变量的值，而无需声明第三个临时变量：

```dart
var (a, b) = ('left', 'right');
(b, a) = (a, b); // Swap.
print('$a $b'); // Prints "right left".
```

### Switch 语句和表达式

每个 case 子句都包含一个模式。这适用于 switch 语句 和 表达式，以及 if-case 语句。
你可以在 case 中使用 任何类型的模式。

_Case 模式_ 是 可拒绝的。
它们允许控制流执行以下操作：

- 匹配并解构被切换的对象。
- 如果对象不匹配，继续执行。

在 case 中解构的值会成为局部变量。它们的作用域仅限于该 case 的主体内。

```dart
switch (obj) {
  // Matches if 1 == obj.
  case 1:
    print('one');

  // Matches if the value of obj is between the
  // constant values of 'first' and 'last'.
  case >= first && <= last:
    print('in range');

  // Matches if obj is a record with two fields,
  // then assigns the fields to 'a' and 'b'.
  case (var a, var b):
    print('a = $a, b = $b');

  default:
}
```

逻辑或模式对于在 switch 表达式或语句中让多个 case 共享一个主体非常有用：

```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false
};
```

Switch 语句可以在不使用逻辑或模式的情况下让多个 case 共享一个主体，但它们在允许多个 case 共享一个守卫时仍然是独特且有用的：

```dart
switch (shape) {
  case Square(size: var s) || Circle(size: var s) when s > 0:
    print('Non-empty symmetric shape');
}
```

守卫子句作为 case 的一部分评估一个任意条件，如果条件为假，不会退出 switch
（不像在 case 主体中使用 `if` 语句那样会导致退出）。

```dart
switch (pair) {
  case (int a, int b):
    if (a > b) print('First element greater');
  // If false, prints nothing and exits the switch.
  case (int a, int b) when a > b:
    // If false, prints nothing but proceeds to next case.
    print('First element greater');
  case (int a, int b):
    print('First element not greater');
}
```

### For and for-in loops

你可以在 for 和 for-in 循环中使用模式来迭代和解构集合中的值。

此示例在 for-in 循环中使用对象解构来解构 `<Map>.entries` 调用返回的 `MapEntry` 对象：

```dart
Map<String, int> hist = {
  'a': 23,
  'b': 100,
};

for (var MapEntry(key: key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

对象模式检查 `hist.entries` 是否具有命名类型 `MapEntry`，然后递归到命名字段子模式 `key` 和 `value`。
它在每次迭代中调用 `MapEntry` 上的 `key` getter 和 `value` getter，并分别将结果绑定到局部变量 `key` 和 `count`。

将 getter 调用的结果绑定到同名变量是一个常见的用例，因此对象模式还可以从变量子模式推断 getter 名称。这使你可以将冗余的变量模式从 `key: key` 简化为仅 `:key`：

```dart
for (var MapEntry(:key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

## 模式的使用案例

上一节描述了模式 _如何_ 适应其他 Dart 代码结构。你已经看到了一些有趣的用例作为示例，比如交换两个变量的值，或者在 map 中解构键值对。本节将描述更多使用案例，回答以下问题：

- 你 _何时和为什么_ 可能想要使用模式。
- 它们解决了哪些类型的问题。
- 它们最适合哪些惯用法。

### 解构多个返回值

记录允许通过单个函数调用聚合和返回多个值。模式增加了直接将记录字段解构到局部变量中的能力，与函数调用内联。

不再需要为每个记录字段单独声明新的局部变量，如下所示：

```dart
var info = userInfo(json);
var name = info.$1;
var age = info.$2;
```

你可以使用变量声明或赋值模式，并使用记录模式作为其子模式，将函数返回的记录字段解构到局部变量中：

```dart
var (name, age) = userInfo(json);
```

### 解构类实例

对象模式 与命名对象类型匹配，允许你使用对象类已经公开的 getters 来解构其数据。

要解构类的实例，使用命名类型，后跟要解构的属性并用括号括起来：

```dart
final Foo myFoo = Foo(one: 'one', two: 2);
var Foo(:one, :two) = myFoo;
print('one $one, two $two');
```

### 代数数据类型

对象解构和 switch 语句有助于以代数数据类型的风格编写代码。
在以下情况下使用此方法：

- 你有一组相关的类型。
- 你有一个操作需要对每种类型执行特定行为。
- 你希望将这些行为集中在一个地方，而不是分散在所有不同的类型定义中。

与其为每种类型实现一个实例方法，不如将操作的变体保存在一个函数中，通过子类型进行切换：

```dart
sealed class Shape {}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
      Square(length: var l) => l * l,
      Circle(radius: var r) => math.pi * r * r
    };
```

### 验证传入的 JSON

Map 和列表模式非常适合解构 JSON 数据中的键值对：

```dart
var json = {
  'user': ['Lily', 13]
};
var {'user': [name, age]} = json;
```

如果你知道 JSON 数据具有你期望的结构，那么前面的例子是现实的。
但数据通常来自外部来源，如通过网络。
你需要先验证它以确认其结构。

没有模式的情况下，验证是冗长的：

```dart
if (json is Map<String, Object?> &&
    json.length == 1 &&
    json.containsKey('user')) {
  var user = json['user'];
  if (user is List<Object> &&
      user.length == 2 &&
      user[0] is String &&
      user[1] is int) {
    var name = user[0] as String;
    var age = user[1] as int;
    print('User $name is $age years old.');
  }
}
```

单个 case 模式可以实现相同的验证。
单个 case 最适合作为 if-case 语句使用。
模式提供了一种更具声明性且更简洁的方法来验证 JSON：

```dart
if (json case {'user': [String name, int age]}) {
  print('User $name is $age years old.');
}
```

这个 case 模式同时验证了以下几点：

- `json` 是一个映射，因为它必须首先匹配外部的 映射模式 才能继续。
  - 而且，由于它是一个映射，它也确认了 `json` 不是 null。
- `json` 包含一个键 `user`。
- 键 `user` 配对了一个包含两个值的列表。
- 列表值的类型是 `String` 和 `int`。
- 用于保存这些值的新局部变量是 `name` 和 `age`。
