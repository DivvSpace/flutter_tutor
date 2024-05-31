# Built-in types

Dart语言特别支持以下内容：

- Numbers(`int`, `double`)
- Strings (`String`)
- Booleans (`bool`)
- Records (`(value1, value2)`)
- Lists(`List`, also known as *arrays*)
- Sets (`Set`)
- Maps(`Map`)
- Runes (`Runes`; often replaced by the `characters` API)
- Symbols(`Symbol`)
- The value `null` (`Null`)

这种支持包括使用字面值创建对象的能力。
例如，'this is a string'是一个字符串字面值，而true是一个布尔字面值。
因为Dart中的每个变量都指向一个对象——一个类的实例，所以通常可以使用构造函数来初始化变量。一些内置类型有自己的构造函数。例如，你可以使用Map()构造函数来创建一个映射。

还有一些其他类型在Dart语言中也有特殊的角色：

- Object：除Null之外的所有Dart类的超类。
- Enum：所有枚举的超类。
- Future和Stream：用于异步支持。
- Iterable：用于for-in循环和同步生成器函数。
- Never：表明一个表达式永远不会成功完成求值。通常用于总是抛出异常的函数。
- dynamic：表示你希望禁用静态检查。通常应该使用Object或Object?替代。
- void：表示一个值永远不会被使用。经常被用作返回值类型。

`Object`、`Object?`、`Null`和`Never`类在类层次结构中有特殊的角色。

## Numbers

Dart numbers come in two flavors:

Dart的数字有两种形式：

int: 整数值不大于64位，具体取决于平台。在本地平台上，值可以从-2^63 到 2^63 - 1。在Web上，整数值被表示为JavaScript数字（没有小数部分的64位浮点数），可以从-2^53 到 2^53 - 1。

double: 根据IEEE 754标准规定的64位（双精度）浮点数。

int和double都是num的子类型。num类型包括基本操作符如+、-、/和*，也是你会找到abs()、ceil()和floor()等其他方法的地方。（位运算符，如>>，在int类中定义。）如果num及其子类型没有你想要的，dart:math库可能有。

整数是没有小数点的数字。以下是一些定义整数字面量的示例：

```dart
var x = 1;
var hex = 0xDEADBEEF;
```

如果一个数字包含小数点，那么它就是一个双精度浮点数。以下是一些定义双精度浮点数字面量的示例：

```dart
var y = 1.1;
var exponents = 1.42e5;
```

你也可以将一个变量声明为num。如果你这样做，那么这个变量既可以有整数值，也可以有双精度浮点数值。

```dart
num x = 1; // x can have both int and double values
x += 2.5;
```

当需要的时候，整数字面量会自动转换为双精度浮点数：

```dart
double z = 1; // Equivalent to double z = 1.0.
```

以下是如何将字符串转换为数字，或者反过来将数字转换为字符串的方法：

```dart
// String -> int
var one = int.parse('1');
assert(one == 1);

// String -> double
var onePointOne = double.parse('1.1');
assert(onePointOne == 1.1);

// int -> String
String oneAsString = 1.toString();
assert(oneAsString == '1');

// double -> String
String piAsString = 3.14159.toStringAsFixed(2);
assert(piAsString == '3.14');
```

`int` 类型规定了传统的位移操作符（<<，>>，>>>）、补码操作符（~）、逻辑与操作符（&）、逻辑或操作符（|）以及异或操作符（^），它们在操作和遮掩位字段中的标志时非常有用。例如：

```dart
assert((3 << 1) == 6); // 0011 << 1 == 0110
assert((3 | 4) == 7); // 0011 | 0100 == 0111
assert((3 & 4) == 0); // 0011 & 0100 == 0000
```

字面数字是编译时常量。许多算术表达式也是编译时常量，只要它们的操作数是编译时常量并且计算结果为数字。

```dart
const msPerSecond = 1000;
const secondsUntilRetry = 5;
const msUntilRetry = secondsUntilRetry * msPerSecond;
```

## Strings

Dart 字符串（`String` 对象）包含一系列的 UTF-16 代码单元。
你可以使用单引号或双引号来创建字符串：

```dart
var s1 = 'Single quotes work well for string literals.';
var s2 = "Double quotes work just as well.";
var s3 = 'It\'s easy to escape the string delimiter.';
var s4 = "It's even easier to use the other delimiter.";
```

你可以通过使用 `${expression}` 将表达式的值放入字符串中。如果表达式是一个标识符，你可以省略 `{}`。为了获取与对象对应的字符串，Dart 会调用对象的 `toString()` 方法。

```dart
var s = 'string interpolation';

assert('Dart has $s, which is very handy.' ==
    'Dart has string interpolation, '
        'which is very handy.');
assert('That deserves all caps. '
        '${s.toUpperCase()} is very handy!' ==
    'That deserves all caps. '
        'STRING INTERPOLATION is very handy!');
```

> note
> `==` 运算符测试两个对象是否相等。
> 如果两个字符串包含相同的代码单元序列，它们就是相等的。

你可以使用相邻的字符串字面量或 `+` 运算符来连接字符串：

```dart
var s1 = 'String '
    'concatenation'
    " works even over line breaks.";
assert(s1 ==
    'String concatenation works even over '
        'line breaks.');

var s2 = 'The + operator ' + 'works, as well.';
assert(s2 == 'The + operator works, as well.');
```

要创建多行字符串，请使用三个单引号或双引号：

```dart
var s1 = '''
You can create
multi-line strings like this one.
''';

var s2 = """This is also a
multi-line string.""";
```

你可以通过在字符串前加 `r` 来创建一个“raw”字符串：

```dart
var s = r'In a raw string, not even \n gets special treatment.';
```

只要任何插值表达式是编译时常量，并且求值为 null、数字、字符串或布尔值，字面字符串就是编译时常量。

```dart
// These work in a const string.
const aConstNum = 0;
const aConstBool = true;
const aConstString = 'a constant string';

// These do NOT work in a const string.
var aNum = 0;
var aBool = true;
var aString = 'a string';
const aConstList = [1, 2, 3];

const validConstString = '$aConstNum $aConstBool $aConstString';
// const invalidConstString = '$aNum $aBool $aString $aConstList';
```

## Booleans

为了表示布尔值，Dart 有一个名为 `bool` 的类型。
只有两个对象的类型是 bool：布尔字面量 `true` 和 `false`，它们都是编译时常量。

Dart 的类型安全意味着你不能使用类似
`if (nonbooleanValue)` 或`assert (nonbooleanValue)`的代码。
相反，请明确检查值，如下所示：

```dart
// Check for an empty string.
var fullName = '';
assert(fullName.isEmpty);

// Check for zero.
var hitPoints = 0;
assert(hitPoints == 0);

// Check for null.
var unicorn = null;
assert(unicorn == null);

// Check for NaN.
var iMeantToDoThis = 0 / 0;
assert(iMeantToDoThis.isNaN);
```

## Runes and grapheme clusters

在 Dart 中，runes 可以表示字符串的 Unicode 代码点。
你可以使用 characters 包来查看或操作用户感知的字符，也称为 Unicode（扩展）字素簇。

Unicode 为世界上所有书写系统中的每个字母、数字和符号定义了一个唯一的数值。
由于 Dart 字符串是 UTF-16 编码单元的序列，在字符串中表达 Unicode 代码点需要特殊的语法。
表达 Unicode 代码点的常用方法是 `\uXXXX`，其中 XXXX 是一个4位的十六进制值。
例如，心形字符 (♥) 是 `\u2665`。
要指定多于或少于4位的十六进制数字，请将值放在花括号中。例如，笑哭的表情符号 (😆) 是 `\u{1f606}`。

如果你需要读取或写入单个 Unicode 字符，请使用 characters 包在 String 上定义的 `characters` 获取器。
返回的 `Characters` 对象是作为字素簇序列的字符串。
以下是使用 characters API 的示例：

```dart
import 'package:characters/characters.dart';

void main() {
  var hi = 'Hi 🇩🇰';
  print(hi);
  print('The end of the string: ${hi.substring(hi.length - 1)}');
  print('The last character: ${hi.characters.last}');
}
```

The output, depending on your environment, looks something like this:

```console
$ dart run bin/main.dart
Hi 🇩🇰
The end of the string: ???
The last character: 🇩🇰
```

## Symbols

`Symbol` 对象表示在 Dart 程序中声明的操作符或标识符。你可能永远不需要使用符号，但它们对于通过名称引用标识符的 API 来说是非常宝贵的，因为代码压缩会改变标识符的名称，但不会改变标识符的符号。

要获取标识符的符号，使用符号字面量，它只是一个 `#` 加上标识符：

```plaintext
#radix
#bar
```

The code from the following excerpt isn't actually what is being shown in the page

```dart
void main() {
  print(Function.apply(int.parse, ['11'])); // 11
  // 这里使用 int.parse 函数将字符串 '11' 转换为整数。默认情况下，int.parse 将字符串按十进制解析，因此 '11' 被解析为整数 11。

  print(Function.apply(int.parse, ['11'], {#radix: 16})); // 17
  // 这里同样使用 int.parse 函数，但是通过命名参数 radix 指定了基数为 16。因此，字符串 '11' 将按十六进制解析，十六进制的 '11' 相当于十进制的 17。
}
```

符号字面量是编译时常量。
