# pattern_types

此页面是对不同类型模式的参考。
有关模式如何工作的概述、在 Dart 中可以使用它们的地方以及常见用例，请访问主模式页面。

## 模式优先级

类似于 运算符优先级，模式评估遵循优先级规则。
你可以使用 括号模式 来优先评估低优先级模式。

本文档按优先级升序列出了模式类型：

* 逻辑或 模式的优先级低于 逻辑与 模式，
逻辑与模式的优先级低于 关系 模式，依此类推。

* 后缀一元模式（类型转换、空检查 和 空断言）共享相同的优先级水平。

* 剩余的主要模式共享最高优先级。
集合类型（records、list 和 map）和 Object 模式涵盖其他数据，因此首先作为外部模式进行评估。

## Logical-or

`subpattern1 || subpattern2`

逻辑或模式通过 `||` 分隔子模式，如果任何一个分支匹配则匹配。分支从左到右评估。一旦一个分支匹配，其余的就不会被评估。

```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false
};
```

逻辑或模式中的子模式可以绑定变量，但各个分支必须定义相同的一组变量，因为模式匹配时只会评估一个分支。

## Logical-and

`subpattern1 && subpattern2`

一对由 `&&` 分隔的模式仅在两个子模式都匹配时才匹配。如果左分支不匹配，则不评估右分支。

逻辑与模式中的子模式可以绑定变量，但每个子模式中的变量不能重叠，因为如果模式匹配，它们都将被绑定：

```dart
switch ((1, 2)) {
  // Error, both subpatterns attempt to bind 'b'.
  case (var a, var b) && (var b, var c): // ...
}
```

## Relational

`== expression`

`< expression`

关系模式使用任意相等或关系运算符：`==`、`!=`、`<`、`>`、`<=` 和 `>=` 来比较匹配值与给定常量。

当在匹配值上调用适当的运算符并以常量作为参数返回 `true` 时，该模式匹配。

关系模式对于匹配数值范围非常有用，尤其是与逻辑与模式结合使用时：

```dart
String asciiCharType(int char) {
  const space = 32;
  const zero = 48;
  const nine = 57;

  return switch (char) {
    < space => 'control',
    == space => 'space',
    > space && < zero => 'punctuation',
    >= zero && <= nine => 'digit',
    _ => ''
  };
}
```

## Cast

`foo as String`

类型转换模式允许你在解构的中间插入类型转换，然后将值传递给另一个子模式：

```dart
(num, Object) record = (1, 's');
var (i as int, s as String) = record;
```

如果值不具有声明的类型，类型转换模式将抛出异常。像空值断言模式一样，这允许你强制断言某些解构值的预期类型。

## Null-check

`subpattern?`

空值检查模式首先匹配值是否不为 null，然后将内部模式与该值匹配。它们允许你绑定一个变量，该变量的类型是正在匹配的可空值的非空基类型。

要将 `null` 值视为匹配失败而不抛出异常，请使用空值检查模式。

```dart
String? maybeString = 'nullable with base type String';
switch (maybeString) {
  case var s?:
  // 's' has type non-nullable String here.
}
```

要在值为 null 时匹配，请使用常量模式 `null`。

## Null-assert

`subpattern!`

空值断言模式首先匹配对象是否不为 null，然后匹配该值。它们允许非空值通过，但如果匹配值为 null 则会抛出异常。

要确保 `null` 值不会被默默地视为匹配失败，请在匹配时使用空值断言模式：

```dart
List<String?> row = ['user', null];
switch (row) {
  case ['user', var name!]: // ...
  // 'name' is a non-nullable string here.
}
```

要从变量声明模式中消除 `null` 值，请使用空值断言模式：

```dart
(int?, int?) position = (2, 3);

var (x!, y!) = position;
```

要在值为 null 时匹配，请使用常量模式 `null`。

## Constant

`123, null, 'string', math.pi, SomeClass.constant, const Thing(1, 2), const (1 + 2)`

常量模式在值等于常量时匹配：

```dart
switch (number) {
  // Matches if 1 == number.
  case 1: // ...
}
```

您可以直接使用简单的字面量和命名常量的引用作为常量模式：

* 数字字面量（`123`，`45.56`）

* 布尔字面量（`true`）

* 字符串字面量（`'string'`）

* 命名常量（`someConstant`，`math.pi`，`double.infinity`）

* 常量构造函数（`const Point(0, 0)`）

* 常量集合字面量（`const []`，`const {1, 2}`）

更复杂的常量表达式必须用括号括起来并以 `const` 前缀（`const (1 + 2)`）：

```dart
// List or map pattern:
case [a, b]: // ...

// List or map literal:
case const [a, b]: // ...
```

## Variable

`var bar, String str, final int _`

变量模式将新变量绑定到已匹配或解构的值。它们通常作为解构模式的一部分出现，以捕获解构的值。

这些变量在代码区域内是有作用域的，该区域仅在模式匹配成功时可达。

```dart
switch ((1, 2)) {
  // 'var a' and 'var b' are variable patterns that bind to 1 and 2, respectively.
  case (var a, var b): // ...
  // 'a' and 'b' are in scope in the case body.
}
```

一个 _类型化_ 变量模式只有在匹配的值具有声明的类型时才匹配，否则会失败：

```dart
switch ((1, 2)) {
  // Does not match.
  case (int a, String b): // ...
}
```

您可以使用通配符模式作为变量模式。

## Identifier

`foo, _`

标识符模式的行为可能像常量模式或变量模式，具体取决于它们出现的上下文：

* 声明上下文：使用标识符名称声明一个新变量：
 `var (a, b) = (1, 2);`

* 赋值上下文：赋值给具有标识符名称的现有变量：
 `(a, b) = (3, 4);`

* 匹配上下文：被视为命名常量模式（除非其名称为 `_`）：

  ```dart
  const c = 1;
  switch (2) {
    case c:
      print('match $c');
    default:
      print('no match'); // Prints "no match".
  }
  ```

* 在任何上下文中的通配符标识符：匹配任何值并将其丢弃：
  `case [_, var y, _]: print('The middle element is $y');`

## Parenthesized

`(subpattern)`

与带括号的表达式类似，模式中的括号允许您控制模式的优先级，并在需要更高优先级的地方插入较低优先级的模式。

例如，假设布尔常量 `x`、`y` 和 `z` 分别等于 `true`、`true` 和 `false`。
虽然以下示例类似于布尔表达式的求值，但实际上是模式匹配。

```dart
// ...
x || y => 'matches true',
x || y && z => 'matches true',
x || (y && z) => 'matches true',
// `x || y && z` is the same thing as `x || (y && z)`.
(x || y) && z => 'matches nothing',
// ...
```

Dart 从左到右开始匹配模式。

1. 第一个模式匹配 `true`，因为 `x` 匹配 `true`。
2. 第二个模式匹配 `true`，因为 `x` 匹配 `true`。
3. 第三个模式匹配 `true`，因为 `x` 匹配 `true`。
4. 第四个模式 `(x || y) && z` 没有匹配项。

   * `x` 匹配 `true`，所以 Dart 不会尝试匹配 `y`。
   * 虽然 `(x || y)` 匹配 `true`，但 `z` 不匹配 `true`。
   * 因此，模式 `(x || y) && z` 不匹配 `true`。
   * 子模式 `(x || y)` 不匹配 `false`，所以 Dart 不会尝试匹配 `z`。
   * 因此，模式 `(x || y) && z` 不匹配 `false`。
   * 综上所述，`(x || y) && z` 没有匹配项。

## List

`[subpattern1, subpattern2]`

列表模式匹配实现了 `List` 的值，然后递归地将其子模式与列表的元素进行匹配，以按位置解构它们：

```dart
const a = 'a';
const b = 'b';
switch (obj) {
  // 列表模式 [a, b] 首先匹配 obj，如果 obj 是一个有两个字段的列表，
  // 然后如果它的字段匹配常量子模式 'a' 和 'b'。
  case [a, b]:
    print('$a, $b');
}
```

列表模式要求模式中的元素数量与整个列表匹配。然而，您可以使用剩余元素作为占位符来表示列表中的任意数量元素。

### Rest element

列表模式可以包含一个剩余元素 (`...`)，允许匹配任意长度的列表。

```dart
var [a, b, ..., c, d] = [1, 2, 3, 4, 5, 6, 7];
// 输出 "1 2 6 7"。
print('$a $b $c $d');
```

剩余元素还可以有一个子模式，将不匹配列表中其他子模式的元素收集到一个新列表中：

```dart
var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
// Prints "1 2 [3, 4, 5] 6 7".
print('$a $b $rest $c $d');
```

## Map

`{"key": subpattern1, someConst: subpattern2}`

映射模式匹配实现了 `Map` 的值，然后递归地将其子模式与映射的键进行匹配，以解构它们。

映射模式不要求模式与整个映射匹配。映射模式会忽略映射中不被模式匹配的任何键。

## Record

`(subpattern1, subpattern2)`

`(x: subpattern1, y: subpattern2)`

记录模式匹配一个记录对象并解构其字段。
如果值不是与模式形状相同的记录，匹配将失败。否则，字段子模式将与记录中的相应字段匹配。

Record模式要求模式匹配整个Record。要使用模式解构具有_命名_字段的记录，请在模式中包含字段名称：

```dart
var (myString: foo, myNumber: bar) = (myString: 'string', myNumber: 1);
```

可以省略获取器名称，并从字段子模式中的变量模式或标识符模式推断出来。这些成对的模式是等价的：

```dart
// Record pattern with variable subpatterns:
var (untyped: untyped, typed: int typed) = record;
var (:untyped, :int typed) = record;

switch (record) {
  case (untyped: var untyped, typed: int typed): // ...
  case (:var untyped, :int typed): // ...
}

// Record pattern with null-check and null-assert subpatterns:
switch (record) {
  case (checked: var checked?, asserted: var asserted!): // ...
  case (:var checked?, :var asserted!): // ...
}

// Record pattern with cast subpattern:
var (untyped: untyped as int, typed: typed as String) = record;
var (:untyped as int, :typed as String) = record;
```

## Object

`SomeClass(x: subpattern1, y: subpattern2)`

对象模式根据给定的命名类型检查匹配的值，以使用对象属性上的获取器解构数据。如果值不具有相同类型，则会被拒绝。

```dart
switch (shape) {
  // 如果 shape 的类型是 Rect，则匹配，然后匹配 Rect 的属性。
  case Rect(width: var w, height: var h): // ...
}
```

可以省略获取器名称，并从字段子模式中的变量模式或标识符模式推断出来：

```dart
// 将新的变量 x 和 y 绑定到 Point 的 x 和 y 属性的值。
var Point(:x, :y) = Point(1, 2);
```

对象模式不要求模式匹配整个对象。如果一个对象有模式未解构的额外字段，它仍然可以匹配。

## Wildcard

`_`

名为 `_` 的模式是一个通配符，无论是变量模式还是标识符模式，都不会绑定或分配给任何变量。

当你需要一个子模式来解构后续的位置值时，它作为占位符非常有用：

```dart
var list = [1, 2, 3];
var [_, two, _] = list;
```

带有类型注释的通配符名称在你想测试值的类型但不想将值绑定到名称时非常有用：

```dart
switch (record) {
  case (int _, String _):
    print('第一个字段是 int 类型，第二个是 String 类型。');
}
```
