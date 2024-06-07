# branches

本页面展示了如何使用分支控制 Dart 代码的流程：

- `if` 语句和元素
- `if-case` 语句和元素
- `switch` 语句和表达式

你还可以通过以下方式在 Dart 中操作控制流：

- 循环，如 `for` 和 `while`
- 异常，如 `try`、`catch` 和 `throw`

## If

Dart 支持带有可选 `else` 子句的 `if` 语句。
`if` 后面的括号中的条件必须是
一个评估为布尔值的表达式：

```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

要了解如何在表达式上下文中使用 `if`，请查看条件表达式。

### If-case

Dart 的 `if` 语句支持 `case` 子句，后面跟随一个模式：

```dart
if (pair case [int x, int y]) return Point(x, y);
```

如果模式匹配值，
那么该分支将使用模式在作用域中定义的任何变量执行。

在前面的示例中，列表模式 `[int x, int y]` 匹配值 `pair`，因此分支 `return Point(x, y)` 将使用模式定义的变量 `x` 和 `y` 执行。

否则，控制流将进展到 `else` 分支执行（如果有的话）：

```dart
if (pair case [int x, int y]) {
  print('Was coordinate array $x,$y');
} else {
  throw FormatException('Invalid coordinates.');
}
```

if-case 语句提供了一种针对单个模式进行匹配和解构的方法。
要将一个值与多个模式进行测试，请使用 switch。

> version-note
> if 语句中的 case 子句要求语言版本至少为 3.0。

## Switch statements

`switch` 语句将一个值表达式与一系列 case 进行匹配。
每个 `case` 子句都是一个模式，用于匹配该值。
你可以在 case 中使用任何类型的模式。

当值匹配某个 case 的模式时，该 case 的主体将执行。
非空的 `case` 子句在完成后会跳到 switch 的末尾。
它们不需要 `break` 语句。
其他结束非空 `case` 子句的有效方法包括 `continue`、`throw` 或 `return` 语句。

使用 `default` 或通配符 `_` 子句
来在没有 `case` 子句匹配时执行代码：

```dart
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    executeClosed();
  case 'PENDING':
    executePending();
  case 'APPROVED':
    executeApproved();
  case 'DENIED':
    executeDenied();
  case 'OPEN':
    executeOpen();
  default:
    executeUnknown();
}
```

空的 case 会贯通到下一个 case，允许多个 case 共享一个主体。
对于不贯通的空 case，可以在其主体中使用 `break`。
对于非连续的贯通，你可以使用 `continue` 语句和标签：

```dart
switch (command) {
  case 'OPEN':
    executeOpen();
    continue newCase; // Continues executing at the newCase label.

  case 'DENIED': // Empty case falls through.
  case 'CLOSED':
    executeClosed(); // Runs for both DENIED and CLOSED,

  newCase:
  case 'PENDING':
    executeNowClosed(); // Runs for both OPEN and PENDING.
}
```

你可以使用逻辑或模式来允许多个 case 共享一个主体或守卫。
要了解更多关于模式和 case 子句的信息，
请查看关于 Switch 语句和表达式的模式文档。

### Switch expressions

`switch` 表达式根据匹配的 case 的表达式主体生成一个值。
你可以在 Dart 允许表达式的任何地方使用 switch 表达式，
_除了_ 在表达式语句的开头。例如：

```dart
var x = switch (y) { ... };

print(switch (x) { ... });

return switch (x) { ... };
```

如果你想在表达式语句的开头使用 switch，请使用 switch 语句。

Switch 表达式允许你将 switch 语句重写成这样：

```dart
// Where slash, star, comma, semicolon, etc., are constant variables...
switch (charCode) {
  case slash || star || plus || minus: // Logical-or pattern
    token = operator(charCode);
  case comma || semicolon: // Logical-or pattern
    token = punctuation(charCode);
  case >= digit0 && <= digit9: // Relational and logical-and patterns
    token = number();
  default:
    throw FormatException('Invalid');
}
```

转换成 _表达式_，像这样：

```dart
token = switch (charCode) {
  slash || star || plus || minus => operator(charCode),
  comma || semicolon => punctuation(charCode),
  >= digit0 && <= digit9 => number(),
  _ => throw FormatException('Invalid')
};
```

`switch` 表达式的语法与 `switch` 语句的语法不同：

- case _不_ 以 `case` 关键字开头。
- case 主体是一个单一表达式，而不是一系列语句。
- 每个 case 必须有主体；空的 case 没有隐式贯通。
- case 模式与其主体使用 `=>` 而不是 `:` 分隔。
- case 之间使用 `,` 分隔（允许可选的尾随 `,`）。
- 默认 case _只能_ 使用 `_`，而不是允许 `default` 和 `_`。

> 版本说明
> Switch 表达式要求语言版本至少为 3.0。

### 穷尽性检查

穷尽性检查是一种特性，如果一个值可能进入 switch 但不匹配任何 case 时，会报告编译时错误。

```dart
// 非穷尽性的 switch 针对 bool?，缺少匹配 null 可能性的 case：
switch (nullableBool) {
  case true:
    print('yes');
  case false:
    print('no');
}
```

默认 case（`default` 或 `_`）涵盖了所有可能通过 switch 的值。
这使得任何类型的 switch 都是穷尽性的。

枚举和密封类型对于 switch 特别有用，因为即使没有默认 case，它们的可能值也是已知且完全可枚举的。
在类上使用 `sealed` 修饰符，可以在切换该类的子类型时启用穷尽性检查：

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

如果有人添加了一个新的 `Shape` 子类，这个 `switch` 表达式将是不完整的。
穷尽性检查会通知您缺少的子类型。
这允许您以某种功能代数数据类型的风格使用 Dart。

## 守卫子句

要在 `case` 子句之后设置可选的守卫子句，请使用关键字 `when`。
守卫子句可以跟在 `if case` 之后，并且适用于 `switch` 语句和表达式。

```dart
// Switch statement:
switch (something) {
  case somePattern when some || boolean || expression:
    //             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
    body;
}

// Switch expression:
var value = switch (something) {
  somePattern when some || boolean || expression => body,
  //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
}

// If-case statement:
if (something case somePattern when some || boolean || expression) {
  //                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
  body;
}
```

守卫会在匹配之后评估一个任意的布尔表达式。
这允许您在决定是否执行 case 体时添加进一步的约束。
当守卫子句评估为 false 时，执行将继续到下一个 case，而不是退出整个 switch。
