# Extension methods

扩展方法为现有库添加功能。
你可能在不知不觉中使用了扩展方法。
例如，当你在IDE中使用代码补全时，它会在常规方法旁边建议扩展方法。

## Overview

当你使用别人的API或实现一个广泛使用的库时，通常更改API是不切实际或不可能的。
但你可能仍然想添加一些功能。

例如，考虑以下将字符串解析为整数的代码：

```dart
int.parse('42')
```

将该功能放在`String`上可能会更好——更简短且更易于使用工具：

```dart
'42'.parseInt()
```

To enable that code,you can import a library that contains an extension of the `String` class:

```dart
import 'string_apis.dart';
// ···
print('42'.parseInt()); // Use an extension method.
```

扩展不仅可以定义方法，还可以定义其他成员，如getter、setter和运算符。
此外，扩展可以有名称，这在出现API冲突时会很有用。
以下是你如何实现扩展方法 `parseInt()` 的示例，使用一个作用于字符串的扩展（名为 `NumberParsing`）：

```dart title="lib/string_apis.dart"
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
  // ···
}
```

下一部分描述了如何**使用**扩展方法。
之后是关于**实现**扩展方法的部分。

## Using extension methods

像所有的 Dart 代码一样，扩展方法也在库中。
你已经看到了如何使用扩展方法——只需导入它所在的库，然后像普通方法一样使用：

```dart
// Import a library that contains an extension on String.
import 'string_apis.dart';
// ···
print('42'.padLeft(5)); // Use a String method.
print('42'.parseInt()); // Use an extension method.
```

这就是你通常需要了解的使用扩展方法的全部内容。
在编写代码时，你可能还需要了解扩展方法如何依赖于静态类型（而不是 `dynamic`）以及如何解决 API 冲突。

### Static types and dynamic

你不能在类型为 `dynamic` 的变量上调用扩展方法。
例如，以下代码会导致运行时异常：

```dart
dynamic d = '2';
print(d.parseInt()); // Runtime exception: NoSuchMethodError
```

扩展方法**确实**适用于 Dart 的类型推断。
以下代码是可以的，因为
变量 `v` 被推断为 `String` 类型：

```dart
var v = '2';
print(v.parseInt()); // Output: 2
```

`dynamic` 不起作用的原因是
扩展方法是根据接收者的静态类型解析的。
由于扩展方法是静态解析的，
它们的速度与调用静态函数一样快。

有关静态类型和 `dynamic` 的更多信息，请参见《Dart 类型系统》。

### API 冲突

如果扩展成员与接口或其他扩展成员冲突，那么你有几种选择。

一种选择是更改导入冲突扩展的方式，使用 `show` 或 `hide` 来限制暴露的 API：

```dart
// Defines the String extension method parseInt().
import 'string_apis.dart';

// Also defines parseInt(), but hiding NumberParsing2
// hides that extension method.
import 'string_apis_2.dart' hide NumberParsing2;

// ···
// Uses the parseInt() defined in 'string_apis.dart'.
print('42'.parseInt());
```

另一种选择是显式地应用扩展，这样代码看起来就像扩展是一个包装类：

```dart
// 两个库都定义了包含 parseInt() 的 String 扩展，
// 并且这些扩展有不同的名称。
import 'string_apis.dart'; // Contains NumberParsing extension.
import 'string_apis_2.dart'; // Contains NumberParsing2 extension.

// ···
// print('42'.parseInt()); // Doesn't work.
print(NumberParsing('42').parseInt());
print(NumberParsing2('42').parseInt());
```

如果两个扩展具有相同的名称，那么你可能需要使用前缀来导入：

```dart
// Both libraries define extensions named NumberParsing
// that contain the extension method parseInt(). One NumberParsing
// extension (in 'string_apis_3.dart') also defines parseNum().
import 'string_apis.dart';
import 'string_apis_3.dart' as rad;

// ···
// print('42'.parseInt()); // Doesn't work.

// Use the ParseNumbers extension from string_apis.dart.
print(NumberParsing('42').parseInt());

// Use the ParseNumbers extension from string_apis_3.dart.
print(rad.NumberParsing('42').parseInt());

// Only string_apis_3.dart has parseNum().
print('42'.parseNum());
```

如示例所示，即使使用前缀导入，你也可以隐式调用扩展方法。只有在显式调用扩展时为了避免名称冲突，才需要使用前缀。

## Implementing extension methods

Use the following syntax to create an extension:

```plaintext
extension <extension name>? on <type> { // <extension-name> is optional
  (<member definition>)* // Can provide one or more <member definition>.
}
```

例如，以下是你如何在 `String` 类上实现一个扩展：

```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}
```

扩展的成员可以是方法、getter、setter 或运算符。
扩展也可以有静态字段和静态辅助方法。
要在扩展声明外访问静态成员，像类变量和方法一样通过声明名称调用它们。

### Unnamed extensions

声明扩展时，可以省略名称。
未命名的扩展仅在声明它们的库中可见。
由于它们没有名称，不能显式应用以解决 API 冲突。

```dart
extension on String {
  bool get isBlank => trim().isEmpty;
}
```

> note
> 你只能在扩展声明内调用未命名扩展的静态成员。

## 实现泛型扩展

扩展可以具有泛型类型参数。
例如，以下代码扩展了内置的 `List<T>` 类型，增加了一个 getter、一个运算符和一个方法：

```dart
extension MyFancyList<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];
}
```

类型 `T` 基于调用方法的列表的静态类型绑定。
