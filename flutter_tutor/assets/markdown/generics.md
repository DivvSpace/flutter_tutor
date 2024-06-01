# Generics(泛型)

如果你查看基本数组类型 `List` 的 API 文档，你会发现该类型实际上是 `List<E>`。\<...\> 符号表示 List 是一种*泛型*（或*参数化*）类型——一种具有正式类型参数的类型。按照惯例，大多数类型变量都有单字母名称，例如 E、T、S、K 和 V。

## Why use generics?

泛型通常是类型安全所必需的，但它们的好处不仅仅是使你的代码能够运行：

* 正确指定泛型类型可以生成更好的代码。
* 你可以使用泛型来减少代码重复。

如果你打算让一个列表只包含字符串，你可以将其声明为 `List<String>`（读作“字符串列表”）。这样，你、你的同事以及你的工具都可以检测到将非字符串赋值给列表可能是一个错误。下面是一个示例：

```dart
var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);
names.add(42); // Error
```

使用泛型的另一个原因是减少代码重复。泛型允许你在多种类型之间共享单个接口和实现，同时仍然可以利用静态分析的优势。例如，假设你创建了一个用于缓存对象的接口：

```dart
abstract class ObjectCache {
  Object getByKey(String key);
  void setByKey(String key, Object value);
}
```

你发现你需要这个接口的特定字符串版本，于是你创建了另一个接口：

```dart
abstract class StringCache {
  String getByKey(String key);
  void setByKey(String key, String value);
}
```

后来，你决定需要这个接口的特定数字版本……你懂的。

泛型类型可以省去创建所有这些接口的麻烦。相反，你可以创建一个带有类型参数的单个接口：

```dart
abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}
```

在这段代码中，T 是替代类型。它是一个占位符，你可以将其视为开发人员稍后定义的类型。

## 使用集合字面量

列表、集合和映射字面量可以被参数化。参数化字面量与您已经见过的字面量类似，只是您需要在左尖括号前添加 `<type>`（用于列表和集合）或 `<keyType, valueType>`（用于映射）。以下是使用类型化字面量的示例：

```dart
var names = <String>['Seth', 'Kathy', 'Lars'];
var uniqueNames = <String>{'Seth', 'Kathy', 'Lars'};
var pages = <String, String>{
  'index.html': 'Homepage',
  'robots.txt': 'Hints for web robots',
  'humans.txt': 'We are people, not machines'
};
```

## 在构造函数中使用参数化类型

在使用构造函数时，如果需要指定一个或多个类型，请将这些类型放在类名之后的尖括号 (`<...>`) 中。例如：

```dart
var nameSet = Set<String>.from(names);
```

以下代码创建了一个具有整数键和 View 类型值的映射：

```dart
var views = Map<int, View>();
```

## 泛型集合及其包含的类型

Dart 的泛型类型是*具体化*的，这意味着它们在运行时携带其类型信息。例如，您可以测试一个集合的类型：

```dart
var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);
print(names is List<String>); // true
```

> note
> 相对而言，Java 中的泛型使用*擦除*，这意味着泛型类型参数在运行时会被移除。在 Java 中，您可以测试一个对象是否是一个 List，但不能测试它是否是 `List<String>`。

## 限制参数化类型

在实现泛型类型时，您可能希望限制可以作为参数提供的类型，使参数必须是特定类型的子类型。您可以使用 `extends` 来实现这一点。

一个常见的用例是通过将类型设为 `Object` 的子类型（而不是默认的 `Object?`），以确保类型是非空的。

```dart
class Foo<T extends Object> {
  // Any type provided to Foo for T must be non-nullable.
}
```

您可以将 `extends` 与其他类型一起使用，不仅限于 `Object`。以下是扩展 `SomeBaseClass` 的示例，这样 `SomeBaseClass` 的成员就可以在类型为 `T` 的对象上调用：

```dart
class Foo<T extends SomeBaseClass> {
  // Implementation goes here...
  String toString() => "Instance of 'Foo<$T>'";
}

class Extender extends SomeBaseClass {...}
```

可以使用 `SomeBaseClass` 或其任何子类型作为泛型参数：

```dart
var someBaseClassFoo = Foo<SomeBaseClass>();
var extenderFoo = Foo<Extender>();
```

It's also OK to specify no generic argument:

```dart
var foo = Foo();
print(foo); // Instance of 'Foo<SomeBaseClass>'
```

指定任何非 `SomeBaseClass` 类型会导致错误：

```dart
// ❌ static analysis: failure
var foo = Foo<Object>(); // Error
```

## Using generic methods

方法和函数也允许类型参数：

```dart
T first<T>(List<T> ts) {
  // Do some initial work or error checking, then...
  T tmp = ts[0];
  // Do some additional checking or processing...
  return tmp;
}
```

这里，`first` 方法上的泛型类型参数 (`<T>`) 允许您在多个地方使用类型参数 `T`：

* 在函数的返回类型中 (`T`)。
* 在参数的类型中 （`List<T>`）。
* 在局部变量的类型中 (`T tmp`)。
