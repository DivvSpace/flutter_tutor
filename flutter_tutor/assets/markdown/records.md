# Records

> 版本说明
> 记录（Records）需要至少 3.0 的语言版本

记录（Records）是一种匿名的、不可变的聚合类型。像其他集合类型一样，它们允许你将多个对象打包成一个单一对象。与其他集合类型不同，记录是固定大小的、异质的，并且是有类型的。

记录是真实的值；你可以将它们存储在变量中，嵌套它们，将它们传递给函数或从函数中传递出来，并将它们存储在诸如列表、映射和集合等数据结构中。

## Record syntax

_记录表达式_ 是用逗号分隔的命名字段或位置字段列表，括在圆括号中：

```dart
var record = ('first', a: 2, b: true, 'last');
```

_记录类型注解_ 是用逗号分隔的类型列表，括在圆括号中。你可以使用记录类型注解来定义返回类型和参数类型。例如，以下 `(int, int)` 语句是记录类型注解：

```dart
(int, int) swap((int, int) record) {
  var (a, b) = record;
  return (b, a);
}
```

记录表达式和类型注解中的字段反映了参数和实参在函数中的工作方式。位置字段直接放在圆括号内：

```dart
// Record type annotation in a variable declaration:
(String, int) record;

// Initialize it with a record expression:
record = ('A string', 123);
```

在记录类型注解中，命名字段放在大括号分隔的类型和名称对的部分内，位于所有位置字段之后。在记录表达式中，名称位于每个字段值之前，并使用冒号分隔：

```dart
// Record type annotation in a variable declaration:
({int a, bool b}) record;

// Initialize it with a record expression:
record = (a: 123, b: true);
```

记录类型中命名字段的名称是记录类型定义的一部分，或者称为其_形状_。两个具有不同命名字段的记录具有不同的类型：

```dart
({int a, int b}) recordAB = (a: 1, b: 2);
({int x, int y}) recordXY = (x: 3, y: 4);

// Compile error! These records don't have the same type.
// recordAB = recordXY;
```

在记录类型注解中，你也可以为_位置_字段命名，但这些名称纯粹是为了文档记录，不会影响记录的类型：

```dart
(int a, int b) recordAB = (1, 2);
(int x, int y) recordXY = (3, 4);

recordAB = recordXY; // OK.
```

这类似于函数声明或函数类型定义中的位置参数可以有名称，但这些名称不会影响函数的签名。

## Record fields

记录字段可以通过内置的getter方法访问。记录是不可变的，因此字段没有setter方法。

命名字段暴露同名的getter方法。位置字段暴露名为`$<position>`的getter方法，跳过命名字段：

```dart
var record = ('first', a: 2, b: true, 'last');

print(record.$1); // Prints 'first'
print(record.a); // Prints 2
print(record.b); // Prints true
print(record.$2); // Prints 'last'
```

## Record types

对于单个记录类型没有类型声明。记录是基于其字段类型的结构类型。记录的_形状_（字段集、字段类型及其名称（如果有的话））唯一决定了记录的类型。

记录中的每个字段都有其自己的类型。同一记录中的字段类型可以不同。类型系统在从记录中访问字段时知道每个字段的类型：

```dart
(num, Object) pair = (42, 'a');

var first = pair.$1; // Static type `num`, runtime type `int`.
var second = pair.$2; // Static type `Object`, runtime type `String`.
```

考虑两个不相关的库，它们创建具有相同字段集的记录。即使这些库彼此没有耦合，类型系统也能理解这些记录是相同类型的。

## Record equality

如果两个记录具有相同的_形状_（字段集），并且它们对应的字段具有相同的值，则它们是相等的。由于命名字段的_顺序_不是记录形状的一部分，因此命名字段的顺序不会影响相等性。

For example:

```dart
(int x, int y, int z) point = (1, 2, 3);
(int r, int g, int b) color = (1, 2, 3);

print(point == color); // Prints 'true'. 
// point.$1 == color.$1; // true
// point.$2 == color.$2; // true
// point.$3 == color.$3; // true
```

```dart
({int x, int y, int z}) point = (x: 1, y: 2, z: 3);
({int r, int g, int b}) color = (r: 1, g: 2, b: 3);

print(point == color); // Prints 'false'. Lint: Equals on unrelated types.
```

记录会根据其字段的结构自动定义`hashCode`和`==`方法。

## Multiple returns

记录允许函数返回捆绑在一起的多个值。要从返回中获取记录值，
使用模式匹配将值解构到局部变量中。

```dart
// Returns multiple values in a record:
(String name, int age) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

final json = <String, dynamic>{
  'name': 'Dash',
  'age': 10,
  'color': 'blue',
};

// Destructures using a record pattern with positional fields:
var (name, age) = userInfo(json);

/* Equivalent to:
  var info = userInfo(json);
  var name = info.$1;
  var age  = info.$2;
*/
```

你也可以使用命名字段解构记录，
使用冒号 `:` 语法，你可以在模式类型页面上阅读更多相关内容：

```dart
({String name, int age}) userInfo(Map<String, dynamic> json)
// ···
// Destructures using a record pattern with named fields:
final (:name, :age) = userInfo(json);
```

你可以在没有记录的情况下从函数返回多个值，但其他方法有缺点。
例如，创建类会更加冗长，而使用其他集合类型如 `List` 或 `Map` 则会失去类型安全性。

> note
> 记录的多重返回和异构类型特性使得不同类型的未来可以并行化，你可以在 `dart:async` 文档中阅读相关内容。
