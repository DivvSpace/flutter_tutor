# functions

Dart 是一种真正的面向对象语言，因此即使是函数也是对象，并且具有类型 Function。这意味着函数可以赋值给变量或作为参数传递给其他函数。你也可以像调用函数一样调用 Dart 类的实例。详情请参见可调用对象。

以下是实现函数的一个例子：

```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

尽管Effective Dart建议为公共 API 添加类型注释，但即使你省略类型，函数仍然可以工作：

```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

对于只包含一个表达式的函数，可以使用简写语法：

```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

`=> expr` 语法是 `{ return expr; }` 的简写。`=>` 符号有时被称为箭头语法。

> note
> 只有 _表达式_ 可以出现在箭头（`=>`）和分号（`;`）之间。表达式计算结果为值。这意味着在 Dart 期望值的地方，你不能写语句。例如，你可以使用条件表达式，但不能使用 if 语句。在前面的例子中，`_nobleGases[atomicNumber] != null;` 返回一个布尔值。然后函数返回一个布尔值，指示 `atomicNumber` 是否属于惰性气体范围。

## Parameters

一个函数可以有任意数量的 _必需位置_ 参数。它们之后可以跟随 _命名_ 参数或 _可选位置_ 参数（但不能同时使用）。

> note
> 一些 API——尤其是 Flutter 小部件构造函数——仅使用命名参数，即使是对于强制性参数也是如此。详情请参见下一节。

在传递参数给函数或定义函数参数时，可以使用尾随逗号。

### Named parameters

命名参数是可选的，除非它们被明确标记为 `required`。

在定义函数时，使用
{param1, param2, …}
来指定命名参数。如果你不提供默认值或将命名参数标记为 `required`，它们的类型必须是可为空的，因为它们的默认值将是 `null`：

```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool? bold, bool? hidden}) {...}
```

调用函数时，可以使用paramName: value来指定命名参数。例如：

```dart
enableFlags(bold: true, hidden: false);
```

为了为命名参数定义除 `null` 之外的默认值，使用 `=` 来指定默认值。指定的值必须是编译时常量。例如：

```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool bold = false, bool hidden = false}) {...}

// bold will be true; hidden will be false.
enableFlags(bold: true);
```

如果你希望命名参数是必需的，要求调用者为该参数提供一个值，则使用 `required` 注解它们：

```dart
const Scrollbar({super.key, required Widget child});
```

如果有人尝试创建一个 `Scrollbar` 而没有指定 `child` 参数，那么分析器会报告一个问题。

> note
> A parameter marked as `required` can still be nullable:

```dart
const Scrollbar({super.key, required Widget? child});
```

你可能希望先放置位置参数，但 Dart 并不要求这样做。Dart 允许在适合你的 API 时，将命名参数放置在参数列表中的任何位置：

```dart
repeat(times: 2, () {
  ...
});
```

### 可选位置参数

将一组函数参数用 `[]` 包裹起来，将它们标记为可选位置参数。如果你没有提供默认值，它们的类型必须是可为空的，因为它们的默认值将是 `null`：

```dart
String say(String from, String msg, [String? device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}
```

这是一个在没有可选参数的情况下调用此函数的示例：

```dart
assert(say('Bob', 'Howdy') == 'Bob says Howdy');
```

这是一个带第三个参数调用此函数的示例：

```dart
assert(say('Bob', 'Howdy', 'smoke signal') ==
    'Bob says Howdy with a smoke signal');
```

要为可选位置参数定义一个 `null` 以外的默认值，请使用 `=` 指定默认值。指定的值必须是编译时常量。例如：

```dart
String say(String from, String msg, [String device = 'carrier pigeon']) {
  var result = '$from says $msg with a $device';
  return result;
}

assert(say('Bob', 'Howdy') == 'Bob says Howdy with a carrier pigeon');
```

## The main() function

每个应用都必须有一个顶级的 `main()` 函数，它作为应用的入口点。`main()` 函数返回 `void` 并且有一个可选的 `List<String>` 参数用于传递参数。

这是一个简单的 `main()` 函数：

```dart
void main() {
  print('Hello, World!');
}
```

这是一个带参数的命令行应用的 `main()` 函数示例：

```dart
// Run the app like this: dart run args.dart 1 test
void main(List<String> arguments) {
  print(arguments);

  assert(arguments.length == 2);
  assert(int.parse(arguments[0]) == 1);
  assert(arguments[1] == 'test');
}
```

你可以使用 args 库来定义和解析命令行参数。

## Functions as first-class objects

你可以将一个函数作为参数传递给另一个函数。例如：

```dart
void printElement(int element) {
  print(element);
}

var list = [1, 2, 3];

// Pass printElement as a parameter.
list.forEach(printElement);
```

你也可以将一个函数赋值给一个变量，例如：

```dart
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
assert(loudify('hello') == '!!! HELLO !!!');
```

这个例子使用了一个匿名函数。关于匿名函数的更多内容将在下一节介绍。

## 匿名函数

虽然你会为大多数函数命名，例如 `main()` 或 `printElement()`，你也可以创建没有名字的函数。这些函数被称为_匿名函数_、_lambda_ 或 _闭包_。

一个匿名函数类似于一个命名函数，因为它具有：

* 零个或多个用逗号分隔的参数
* 可选的类型注解在括号之间

下面的代码块包含了函数的主体：

```dart
([[Type]] param1[, ...]) {
  codeBlock;
}
```

下面的例子定义了一个带有无类型参数 `item` 的匿名函数。匿名函数将它传递给 `map` 函数。`map` 函数为列表中的每个项调用，将每个字符串转换为大写。然后，传递给 `forEach` 的匿名函数打印每个转换后的字符串及其长度。

```dart
const list = ['apples', 'bananas', 'oranges'];

var uppercaseList = list.map((item) {
  return item.toUpperCase();
}).toList();
// Convert to list after mapping

for (var item in uppercaseList) {
  print('$item: ${item.length}');
}
```

如果函数仅包含一个表达式或返回语句，你可以使用箭头符号来简化它。

```dart
var uppercaseList = list.map((item) => item.toUpperCase()).toList();
uppercaseList.forEach((item) => print('$item: ${item.length}'));
```

## 词法作用域

Dart 根据代码的布局来确定变量的作用域。具有此功能的编程语言被称为词法作用域语言。你可以“沿着大括号向外查找”以查看变量是否在作用域内。

**示例：** 一系列嵌套函数，每个作用域级别都有变量：

```dart
bool topLevel = true;

void main() {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);
    }
  }
}
```

`nestedFunction()` 方法可以使用每个级别的变量，一直到顶级变量。

## 词法闭包

一个函数对象在其所在的作用域之外访问其词法作用域中的变量时，被称为 _闭包_。

函数可以闭合其周围作用域中定义的变量。在以下示例中，`makeAdder()` 捕获了变量 `addBy`。无论返回的函数走到哪里，它都会记住 `addBy`。

```dart
/// Returns a function that adds [addBy] to the
/// function's argument.
Function makeAdder(int addBy) {
  return (int i) => addBy + i;
}

void main() {
  // Create a function that adds 2.
  var add2 = makeAdder(2);

  // Create a function that adds 4.
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```

## 截取

当你引用一个函数、方法或命名构造函数而不带括号时，Dart 会创建一个 _截取_。这是一个闭包，它接受与函数相同的参数，并在调用时调用底层函数。如果你的代码需要一个闭包来调用一个接受相同参数的命名函数，不要将调用包装在 lambda 中。使用截取。

```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();
```

```dart tag=good
//  good
// Function tear-off
charCodes.forEach(print);

// Method tear-off
charCodes.forEach(buffer.write);
```

```dart tag=bad
// bad
// Function lambda
charCodes.forEach((code) {
  print(code);
});

// Method lambda
charCodes.forEach((code) {
  buffer.write(code);
});
```

## 测试函数的相等性

以下是测试顶级函数、静态方法和实例方法相等性的示例：

```dart
void foo() {} // A top-level function

class A {
  static void bar() {} // A static method
  void baz() {} // An instance method
}

void main() {
  Function x;

  // Comparing top-level functions.
  x = foo;
  assert(foo == x);

  // Comparing static methods.
  x = A.bar;
  assert(A.bar == x);

  // Comparing instance methods.
  var v = A(); // Instance #1 of A
  var w = A(); // Instance #2 of A
  var y = w;
  x = w.baz;

  // These closures refer to the same instance (#2),
  // so they're equal.
  assert(y.baz == x);

  // These closures refer to different instances,
  // so they're unequal.
  assert(v.baz != w.baz);
}
```

## Return values

所有函数都会返回一个值。如果没有指定返回值，语句 `return null;` 会被隐式地添加到函数体中。

```dart
foo() {}

assert(foo() == null);
```

要在函数中返回多个值，可以将这些值聚合在一个记录中。

```dart
(String, int) foo() {
  return ('something', 42);
}
```

## 生成器

当你需要惰性地产生一系列值时，考虑使用 _生成器函数_。Dart 内置支持两种生成器函数：

* **同步**生成器：返回一个 [`Iterable`] 对象。
* **异步**生成器：返回一个 [`Stream`] 对象。

要实现一个 **同步** 生成器函数，将函数体标记为 `sync*`，并使用 `yield` 语句来传递值：

```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

要实现一个 **异步** 生成器函数，将函数体标记为 `async*`，并使用 `yield` 语句来传递值：

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

如果你的生成器是递归的，可以通过使用 `yield*` 来提高其性能：

```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

## 外部函数

外部函数是一种其函数体与声明分开实现的函数。在函数声明前包含 `external` 关键字，如下所示：

```dart
external void someFunc(int i);
```

外部函数的实现可以来自另一个 Dart 库，或者更常见的是来自另一种语言。在互操作性上下文中，`external` 为外部函数或值引入类型信息，使其在 Dart 中可用。实现和使用在很大程度上依赖于平台。

外部函数可以是顶级函数、实例方法、getter 或 setter，或 非重定向构造函数。实例变量 也可以是 `external`，这相当于一个外部 getter 和（如果变量不是 `final`）一个外部 setter。
