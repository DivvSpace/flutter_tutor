# 运算符

Dart 支持以下表格中显示的操作符。表格显示了 Dart 的操作符结合性和从高到低的操作符优先级，这是 Dart 操作符关系的**大致**表示。你可以将其中许多操作符实现为类成员。

| 描述                             | 操作符                                                                                           | 结合性 |
|-----------------------------------------|----------------------------------------------------------------------------------------------------|---------------|
| unary postfix                           | *`expr`*`++`    *`expr`*`--`    `()`    `[]`    `?[]`    `.`    `?.`    `!`                        | None          |
| unary prefix                            | `-`*`expr`*    `!`*`expr`*    `~`*`expr`*    `++`*`expr`*    `--`*`expr`*      `await` *`expr`*    | None          |
| multiplicative                          | `*`    `/`    `%`    `~/`                                                                          | Left          |
| additive                                | `+`    `-`                                                                                         | Left          |
| shift                                   | `<<`    `>>`    `>>>`                                                                              | Left          |
| bitwise AND                             | `&`                                                                                                | Left          |
| bitwise XOR                             | `^`                                                                                                | Left          |
| bitwise OR                              | &#124;                                                                                | Left          |
| relational and type test                | `>=`    `>`    `<=`    `<`    `as`    `is`    `is!`                                                | None          |
| equality                                | `==`    `!=`                                                                                       | None          |
| logical AND                             | `&&`                                                                                               | Left          |
| logical OR                              | &#124;&#124;                                                                          | Left          |
| if-null                                 | `??`                                                                                               | Left          |
| conditional                             | *`expr1`*    `?`    *`expr2`*    `:`    *`expr3`*                                                  | Right         |
| cascade                                 | `..`    `?..`                                                                                      | Left          |
| assignment                              | `=`    `*=`    `/=`    `+=`    `-=`    `&=`    `^=`    *etc.*                                      | Right         |
| spread   | `...`    `...?`                                                                                    | None          |

> warning
> 上表只能用作有用的指南。运算符优先级和结合性的概念是语言语法中事实的近似值。您可以在 Dart 语言规范中定义的语法中找到 Dart 运算符关系的权威行为。

使用运算符时，您会创建表达式。以下是一些运算符表达式的示例：

```dart
a++
a + b
a = b
a == b
c ? a : b
a is T
```

## Operator precedence example

在运算符表中，每个运算符的优先级都高于其后面行的运算符。例如，乘法运算符 `%` 的优先级高于（因此在执行时先于）等于运算符 `==`，而等于运算符的优先级又高于逻辑与运算符 `&&`。这意味着下面两行代码的执行方式相同：

```dart
// 括号提高了可读性。
if ((n % i == 0) && (d % i == 0)) ...

// 难读但效果一样
if (n % i == 0 && d % i == 0) ...
```

> 警告
> 对于需要两个操作数的运算符，最左边的操作数决定使用哪种方法。例如，如果您有一个 `Vector` 对象和一个 `Point` 对象，那么 `aVector + aPoint` 使用的是 `Vector` 加法（`+`）。

## 算术运算符

Dart 支持常见的算术运算符，如下表所示。

| Operator    | Meaning                                                                  |
|-------------|--------------------------------------------------------------------------|
| `+`         | Add                                                                      |
| `-`         | Subtract                                                                 |
| `-`*`expr`* | Unary minus, also known as negation (reverse the sign of the expression) |
| `*`         | Multiply                                                                 |
| `/`         | Divide                                                                   |
| `~/`        | Divide, returning an integer result                                      |
| `%`         | Get the remainder of an integer division (modulo)                        |

Example:

```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Result is a double
assert(5 ~/ 2 == 2); // Result is an int
assert(5 % 2 == 1); // Remainder

assert('5/2 = ${5 ~/ 2} r ${5 % 2}' == '5/2 = 2 r 1');
```

Dart 还支持前缀和后缀的递增和递减运算符。

| 运算符                      | 含义                                               |
|-----------------------------|----------------------------------------------------|
| `++`*`var`*  | *`var`*  `=`  *`var`*  `+ 1` （表达式的值是 *`var`* `+ 1`）          |
| *`var`*`++`  | *`var`*  `=`  *`var`*  `+ 1` （表达式的值是 *`var`*）                |
| `--`*`var`*  | *`var`*  `=`  *`var`*  `- 1` （表达式的值是 *`var`* `- 1`）          |
| *`var`*`--`  | *`var`*  `=`  *`var`*  `- 1` （表达式的值是 *`var`*）                |

Example:

```dart
int a;
int b;

a = 0;
b = ++a; // 在 b 获取其值之前递增 a。
assert(a == b); // 1 == 1

a = 0;
b = a++; // 在 b 获取其值之后递增 a。
assert(a != b); // 1 != 0

a = 0;
b = --a; // 在 b 获取其值之前递减 a。
assert(a == b); // -1 == -1

a = 0;
b = a--; // 在 b 获取其值之后递减 a。
assert(a != b); // -1 != 0
```

## 等式和关系运算符

下表列出了等式和关系运算符的含义。

| 运算符    | 含义                                       |
|-----------|--------------------------------------------|
| `==`      | 等于                          |
| `!=`      | 不等于                                      |
| `>`       | 大于                                        |
| `<`       | 小于                                        |
| `>=`      | 大于或等于                                  |
| `<=`      | 小于或等于                                  |

要测试两个对象 x 和 y 是否代表相同的事物，请使用 `==` 运算符。（在极少数情况下，如果你需要知道两个对象是否完全相同，请改用 [identical()] 函数。）以下是 `==` 运算符的工作原理：

1. 如果 *x* 或 *y* 为 null，则在两者都为 null 时返回 true，如果只有一个为 null 则返回 false。

2. 返回在 *x* 上使用参数 *y* 调用 `==` 方法的结果。没错，诸如 `==` 的运算符实际上是方法，它们在第一个操作数上被调用。

以下是使用每个等式和关系运算符的示例：

```dart
assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
```

## 类型测试运算符

`as`、`is` 和 `is!` 运算符在运行时进行类型检查时非常方便。

| 运算符  | 意思                                              |
|---------|--------------------------------------------------|
| `as`    | 类型转换 |
| `is`    | 如果对象具有指定类型则为真                       |
| `is!`   | 如果对象不具有指定类型则为真                     |

如果 `obj` 实现了 `T` 指定的接口，`obj is T` 的结果为 true。例如，`obj is Object?` 始终为 true。

当且仅当你确定对象是某种特定类型时，使用 `as` 运算符将对象强制转换为该类型。示例：

```dart
(employee as Person).firstName = 'Bob';
```

如果你不确定对象的类型是否为 `T`，那么在使用对象之前，先用 `is T` 检查类型。

```dart
if (employee is Person) {
  // 类型检查
  employee.firstName = 'Bob';
}
```

> note
> 这两段代码并不等价。如果 `employee` 是 null 或不是 `Person` 类型，第一个例子将抛出异常；第二个例子则不会做任何事情。

## 赋值运算符

如你所见，你可以使用 `=` 运算符来赋值。
若仅当待赋值的变量为 null 时进行赋值，可以使用 `??=` 运算符。

```dart
// 给 a 赋值
a = value;
// 若 b 为 null，则将 value 赋给 b；否则，b 保持不变
b ??= value;
```

复合赋值运算符如 `+=` 结合了操作和赋值。

|      |       |       |        |                      |
|------|-------|-------|--------|----------------------|
| `=`  | `*=`  | `%=`  | `>>>=` | `^=`                 |
| `+=` | `/=`  | `<<=` | `&=`   | &#124;= |
| `-=` | `~/=` | `>>=` |        |                      |

复合赋值运算符的工作方式如下：

|                           | 复合赋值运算符       | 等效表达式            |
|---------------------------|---------------------|-----------------------|
| **对于操作符 *op* 来说：** | `a`  *`op`*`= b`   | `a = a` *`op`* `b`  |
| **例如：**                | `a += b`            | `a = a + b`           |

下面的例子使用了赋值和复合赋值运算符：

```dart
var a = 2; // 使用 = 赋值
a *= 3; // 赋值并相乘：a = a * 3
assert(a == 6);
```

## 逻辑运算符

你可以使用逻辑运算符来反转或组合布尔表达式。

| 运算符                     | 含义                                                                 |
|----------------------------|---------------------------------------------------------------------|
| `!`*`表达式`*                | 反转后续表达式（将 false 变为 true，反之亦然）                        |
| &#124;&#124;                | 逻辑或                                                               |
| `&&`                       | 逻辑与                                                               |

下面是一个使用逻辑运算符的例子：

```dart
if (!done && (col == 0 || col == 3)) {
  // ...执行某些操作...
}
```

## 位运算与移位运算符

在 Dart 中你可以操作数字的各个位。通常，你会将这些位运算和移位运算符用于整数。

| 运算符                 | 含义                                                |
|------------------------|----------------------------------------------------|
| `&`                    | 与                                                  |
| &#124;                 | 或                                                  |
| `^`                    | 异或                                                |
| `~`*`表达式`*           | 一元位补码（0 变 1；1 变 0）                         |
| `<<`                   | 左移                                                |
| `>>`                   | 右移                                                |
| `>>>`                  | 无符号右移                                           |

下面是一个使用位运算和移位运算符的例子：

```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR

assert((value << 4) == 0x220); // Shift left
assert((value >> 4) == 0x02); // Shift right

// Shift right example that results in different behavior on web
// because the operand value changes when masked to 32 bits:
assert((-value >> 4) == -0x03);

assert((value >>> 4) == 0x02); // Unsigned shift right
assert((-value >>> 4) > 0); // Unsigned shift right
```

## 条件表达式

Dart 有两个运算符可以让你简洁地评估可能需要 if-else 语句的表达式：

*`条件`* `?` *`表达式1`* `:` *`表达式2`*
: 如果 *条件* 为真，则评估 *表达式1*（并返回其值）；否则，评估并返回 *表达式2* 的值。

*`表达式1`* `??` *`表达式2`*
: 如果 *表达式1* 非空，则返回其值；否则，评估并返回 *表达式2* 的值。

当你需要基于布尔表达式来赋值时，可以考虑使用条件运算符 `?` 和 `:`。

```dart
var visibility = isPublic ? 'public' : 'private';
```

如果布尔表达式测试是否为空，考虑使用空合并运算符 `??`（也称为空值合并运算符）。

```dart
String playerName(String? name) => name ?? 'Guest';
```

前面的例子可以用至少其他两种方式来编写，但没有那么简洁：

```dart
// Slightly longer version uses ?: operator.
String playerName(String? name) => name != null ? name : 'Guest';

// Very long version uses if-else statement.
String playerName(String? name) {
  if (name != null) {
    return name;
  } else {
    return 'Guest';
  }
}
```

## 级联表示法

级联（`..`，`?..`）允许你在同一个对象上进行一系列操作。除了访问实例成员，你还可以调用该对象的实例方法。这通常可以节省创建临时变量的步骤，并使你编写出更加流畅的代码。

请考虑以下代码：

```dart
var paint = Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0;
```

构造函数 `Paint()` 返回一个 `Paint` 对象。紧随其后的级联表示法代码对该对象进行操作，忽略任何可能返回的值。

前面的例子等价于以下代码：

```dart
var paint = Paint();
paint.color = Colors.black;
paint.strokeCap = StrokeCap.round;
paint.strokeWidth = 5.0;
```

如果级联操作的对象可能为空，那么对于第一次操作，请使用 *空值截断* 级联（`?..`）。以 `?..` 开始可以保证不会对空对象进行任何级联操作。

```dart
querySelector('#confirm') // Get an object.
  ?..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'))
  ..scrollIntoView();
```

> version-note
> The `?..` syntax requires a language version of at least 2.12.

前面的代码等同于以下代码：

```dart
var button = querySelector('#confirm');
button?.text = 'Confirm';
button?.classes.add('important');
button?.onClick.listen((e) => window.alert('Confirmed!'));
button?.scrollIntoView();
```

你也可以嵌套级联。例如：

```dart
final addressBook = (AddressBookBuilder()
      ..name = 'jenny'
      ..email = 'jenny@example.com'
      ..phone = (PhoneNumberBuilder()
            ..number = '415-555-0100'
            ..label = 'home')
          .build())
    .build();
```

注意要在返回实际对象的函数上构建级联。例如，以下代码会失败：

```dart
var sb = StringBuffer();
sb.write('foo')
  ..write('bar'); // Error: method 'write' isn't defined for 'void'.
```

`sb.write()` 调用返回 void，不能在 `void` 上构建级联。

> note
> 严格来说，级联的“双点”符号并不是一个运算符。它只是 Dart 语法的一部分。

## 扩展运算符

扩展运算符评估产生集合的表达式，解包结果值，并将它们插入到另一个集合中。

因为它不是一个运算符，该语法没有任何“运算符优先级”。实际上，它具有最低的“优先级”&mdash;任何类型的表达式都可以作为扩展目标，例如：

```dart
[...a + b]
```

## 其他运算符

您在其他示例中已看到了大多数剩余的运算符：

| 运算符   | 名称                         | 含义                                                                                                                                                                                                                                                 |
|----------|------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `()`     | 函数调用                     | 表示一个函数调用                                                                                                                                                                                                                                      |
| `[]`     | 下标访问                     | 表示对可重写的 `[]` 运算符的调用；例如：`fooList[1]` 将 int `1` 传递给 `fooList` 以访问索引 `1` 处的元素                                                                                                                                            |
| `?[]`    | 条件下标访问                 | 类似于 `[]`，但最左边的操作数可以为 null；例如：`fooList?[1]` 将 int `1` 传递给 `fooList` 以访问索引 `1` 处的元素，除非 `fooList` 为 null（在这种情况下，表达式的值为 null）                                                                         |
| `.`      | 成员访问                     | 引用表达式的一个属性；例如：`foo.bar` 从表达式 `foo` 中选择属性 `bar`                                                                                                                                               |
| `?.`     | 条件成员访问                 | 类似于 `.`，但最左边的操作数可以为 null；例如：`foo?.bar` 从表达式 `foo` 中选择属性 `bar`，除非 `foo` 为 null（在这种情况下，`foo?.bar` 的值为 null）                                                       |
| `!`      | 非空断言运算符               | 将表达式转换为其底层的非空类型，如果转换失败则抛出运行时异常；例如：`foo!.bar` 断言 `foo` 非空并选择属性 `bar`，除非 `foo` 为 null，在这种情况下将抛出运行时异常                                                         |
