# 变量

这是创建变量并初始化它的例子：

```dart
var name = 'Bob';
```

变量存储引用。名为`name`的变量包含对值为 "Bob" 的`String`对象的引用。

`name`变量的类型被推断为`String`，但你可以通过特定的方式修改这种类型。如果一个对象不仅限于单一类型，你可以指定`Object`类型（如果需要的话，可以选择`dynamic`类型）。

```dart
Object name = 'Bob';
```

另一个选项是显式声明将被推断的类型：

```dart
String name = 'Bob';
```

## 空安全

Dart语言强制实施了健全的空值安全性。

空值安全性防止了由于无意中访问设为`null`的变量而引发的错误。这种错误被称为`null`解引用错误。当你在一个计算结果为`null`的表达式上访问属性或调用方法时，就会发生`null`解引用错误。只有当`null`支持属性或者方法，比如`toString()`或`hashCode`，这个规则才会有例外。有了空值安全性，Dart编译器在编译时就可以检测出这些潜在的错误。

例如，假设你想要找到一个 `int` 变量 `i` 的绝对值。如果 `i` 是 `null`，调用 `i.abs()` 会导致空引用错误。在其他语言中，尝试这样做可能会导致运行时错误，但 Dart 的编译器禁止这些操作。因此，Dart 应用程序不会导致运行时错误。

空安全引入了三个关键变化：

1. 当你为变量、参数或其他相关组件指定一个类型时，你可以控制该类型是否允许 `null`。为了启用可空性，你可以在类型声明的末尾加上一个 `?`。

    ```dart
    String? name  // Nullable type. Can be `null` or string.

    String name   // Non-nullable type. Cannot be `null` but can be string.
    ```

2. 你必须在使用变量之前对其进行初始化。可空变量默认值为 `null`，因此它们默认已初始化。
   Dart 不会为非可空类型设置初始值。它强制你必须设置一个初始值。Dart 不允许你观察未初始化的变量。
   这防止了在接收者类型可能为 `null` 但 `null` 不支持使用的方法或属性的情况下访问属性或调用方法。

3. 你不能在具有可空类型的表达式上访问属性或调用方法。同样的例外也适用于 `null` 支持的属性或方法，如 `hashCode` 或 `toString()`。

空安全将潜在的 **运行时错误** 转变为 **编辑时** 分析错误。
当非空变量遇到以下情况之一时，空安全会进行标记：

* 未初始化为非空值。
* 被赋予了 `null` 值。

此检查允许你在部署应用程序之前修复这些错误。

## 默认值

具有可空类型的未初始化变量的初始值为 `null`。即使是具有数字类型的变量，最初也是 `null`，因为在 Dart 中，数字和其他所有东西一样都是对象。

```dart
int? lineCount;
assert(lineCount == null);
```

在空安全下，必须在使用非空变量之前初始化它们的值：

```dart
int lineCount = 0;
```

不必在局部变量声明时进行初始化，但需要在使用之前为其赋值。例如，以下代码是有效的，因为 Dart 可以检测到 `lineCount` 在传递给 `print()` 时是非空的：

```dart
int lineCount;

if (weLikeToCount) {
  lineCount = countLines();
} else {
  lineCount = 0;
}

print(lineCount);
```

顶级变量和类变量是延迟初始化的；初始化代码在变量首次使用时运行。

## 延迟变量

`late` 修饰符有两种用例：

* 声明一个在声明后初始化的非空变量。
* 延迟初始化变量。

通常，Dart 的控制流分析可以检测到一个非空变量在使用之前被设定为非空值，但有时分析会失败。两个常见的情况是顶级变量和实例变量：Dart 通常无法确定它们是否被设定，因此不会尝试。

如果你确定一个变量在使用之前已经被设定，但 Dart 不认同，你可以通过将变量标记为 `late` 来解决这个错误：

```dart
late String description;

void main() {
  description = 'Feijoada!';
  print(description);
}
```

:::warning 注意
如果你未能初始化一个 late 变量，当使用该变量时会发生运行时错误。
:::

当你标记一个变量为 late 但在其声明时进行初始化时，初始化器会在变量首次使用时运行。这种延迟初始化在一些情况下非常方便：
该变量可能不需要，而初始化它的代价很高。
你在初始化一个实例变量，且它的初始化器需要访问 this。
在以下例子中，如果从未使用 temperature 变量，则不会调用代价高昂的 readThermometer() 函数：

```dart
// This is the program's only call to readThermometer().
late String temperature = readThermometer(); // Lazily initialized.
```

## Final and const

如果你永远不打算更改一个变量的值，使用 final 或 const，可以代替 var 或者附加到一个类型上。一个 final 变量只能被设定一次；一个 const 变量是编译时常量。（Const 变量隐式为 final。）

以下是创建和设定一个 final 变量的示例：

```dart
final name = 'Bob'; // Without a type annotation
final String nickname = 'Bobby';
```

你不能更改一个 final 变量的值：

```dart
name = 'Alice'; // Error: a final variable can only be set once.
```
使用`const`来声明编译时常量变量。如果`const`变量是在类级别声明的，标记为 `static const`。在声明变量时，将其值设为编译时常量，如数字或字符串字面量、`const` 变量或对常量数值的算术操作结果：

```dart
const bar = 1000000; // Unit of pressure (dynes/cm2)
const double atm = 1.01325 * bar; // Standard atmosphere
```

`const`关键字不仅用于声明常量变量。你还可以用它来创建常量 值，并声明创建常量值的构造函数。任何变量都可以有一个常量值。

```dart
var foo = const [];
final bar = const [];
const baz = []; // Equivalent to `const []`
```

你可以省略`const`声明中的初始化表达式，如上面的 baz。
你可以更改一个非 final、非 const 变量的值，即使它以前是 const 值：

```dart
foo = [1, 2, 3]; // Was const []
```

你不能更改一个`const`变量的值：

```dart
baz = [42]; // Error: Constant variables can't be assigned a value.
```

你可以定义使用类型检查和类型转换（`is` 和 `as`）、集合 `if`, 和扩展操作符（`...` 和 `...?`）的常量：

```dart
const Object i = 3; // Where i is a const Object with an int value...
const list = [i as int]; // Use a typecast.
const map = {if (i is int) i: 'int'}; // Use is and collection if.
const set = {if (list is List<int>) ...list}; // ...and a spread.
```

:::note
虽然 `final` 对象不能被修改，但它的字段可以更改。
相比之下，`const` 对象及其字段不能更改：它们是 _不可变的_。
:::