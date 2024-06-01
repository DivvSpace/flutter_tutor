# type system

Dart 语言是类型安全的：它结合了静态类型检查和运行时检查，以确保变量的值始终与变量的静态类型匹配，有时也称为健全类型。尽管 _类型_ 是强制的，但由于类型推断，类型 _注解_ 是可选的。

静态类型检查的一个好处是能够在编译时通过 Dart 的静态分析器(analysis)发现错误。

您可以通过向泛型类添加类型注解来修复大多数静态分析错误。最常见的泛型类是集合类型 `List<T>` 和 `Map<K,V>`。

例如，在以下代码中，`printInts()` 函数打印一个整数列表，而 `main()` 创建一个列表并将其传递给 `printInts()`。

```dart
// ✗ static analysis: failure
void printInts(List<int> a) => print(a);

void main() {
  final list = [];
  list.add(1);
  list.add('2');
  printInts(list);
}
```

上述代码在调用 `printInts(list)` 时会导致 `list` 上的类型错误（如上所示）：

```plaintext
error - The argument type 'List<dynamic>' can't be assigned to the parameter type 'List<int>'. - argument_type_not_assignable
```

该错误突出显示了从 `List<dynamic>` 到 `List<int>` 的不健全隐式转换。
`list` 变量的静态类型是 `List<dynamic>`。这是因为初始化声明 `var list = []` 没有为分析器提供足够的信息，使其能够推断出比 `dynamic` 更具体的类型参数。
`printInts()` 函数期望一个 `List<int>` 类型的参数，导致类型不匹配。

在创建列表时添加类型注解 (`<int>`)（如下所示）会导致分析器抱怨字符串参数不能分配给 `int` 参数。
在 `list.add('2')` 中删除引号后，代码通过静态分析并且运行时没有错误或警告。

```dart
// ✔ static analysis: success
void printInts(List<int> a) => print(a);

void main() {
  final list = <int>[];
  list.add(1);
  list.add(2);
  printInts(list);
}
```

## 什么是健全性？

_健全性_ 是关于确保你的程序不会进入某些无效状态。一个健全的 _类型系统_ 意味着你永远不会进入一个表达式求值的值不匹配表达式静态类型的状态。例如，如果一个表达式的静态类型是 `String`，在运行时你可以保证评估它时只会得到一个字符串。

Dart 的类型系统，像 Java 和 C# 的类型系统一样，是健全的。它通过静态检查（编译时错误）和运行时检查的结合来强制执行这种健全性。例如，将一个 `String` 分配给 `int` 是一个编译时错误。如果对象不是 `String`，使用 `as String` 将对象转换为 `String` 会在运行时失败并报错。

## 健全性的好处

一个健全的类型系统有几个好处：

* 在编译时揭示类型相关的错误。
  健全的类型系统强制代码在其类型方面保持明确性，因此在运行时可能难以发现的类型相关错误会在编译时被揭示。

* 更易读的代码。
  代码更容易阅读，因为你可以依赖于一个值实际具有指定的类型。在健全的 Dart 中，类型不会撒谎。

* 更易维护的代码。
  通过健全的类型系统，当你更改一段代码时，类型系统可以警告你其他刚刚被破坏的代码段。

* 更好的预先编译（AOT）。
  虽然没有类型也可以进行 AOT 编译，但生成的代码效率要低得多。

## 通过静态分析的技巧

大多数静态类型规则都容易理解。以下是一些不那么明显的规则：

* 在重写方法时使用健全的返回类型。
* 在重写方法时使用健全的参数类型。
* 不要将动态列表用作类型化列表。

让我们详细了解这些规则，并使用以下类型层次结构的示例：

![alt text](resource:assets/markdown/image.png)

### 在重写方法时使用健全的返回类型

子类中方法的返回类型必须与超类中方法的返回类型相同或为其子类型。
请考虑 `Animal` 类中的 getter 方法：

```dart
class Animal {
  void chase(Animal a) { ... }
  Animal get parent => ...
}
```

`parent` getter 方法返回一个 `Animal`。在 `HoneyBadger` 子类中，你可以将 getter 的返回类型替换为 `HoneyBadger`（或 `Animal` 的任何其他子类型），但不允许使用不相关的类型。

```dart
// ✔ static analysis: success
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) { ... }

  @override
  HoneyBadger get parent => ...
}
```

```dart
// ✗ static analysis: failure
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) { ... }

  @override
  Root get parent => ...
}
```

### 在重写方法时使用健全的参数类型

重写方法的参数必须具有与超类中相应参数相同或其超类型的类型。不要通过将参数类型替换为原始参数的子类型来“收紧”参数类型。

请考虑 `Animal` 类中的 `chase(Animal)` 方法：

```dart
class Animal {
  void chase(Animal a) { ... }
  Animal get parent => ...
}
```

`chase()` 方法接受一个 `Animal`。一个 `HoneyBadger` 会追逐任何东西。因此，可以重写 `chase()` 方法以接受任何类型（`Object`）。

```dart
// ✔ static analysis: success
class HoneyBadger extends Animal {
  @override
  void chase(Object a) { ... }

  @override
  Animal get parent => ...
}
```

以下代码将 `chase()` 方法的参数从 `Animal` 收紧为 `Mouse`，这是 `Animal` 的一个子类。

```dart
// ✗ static analysis: failure
class Mouse extends Animal { ... }

class Cat extends Animal {
  @override
  void chase(Mouse a) { ... }
}
```

这段代码不是类型安全的，因为这样一来就有可能定义一只猫并让它追逐一条鳄鱼：

```dart
Animal a = Cat();
a.chase(Alligator()); // Not type safe or feline safe.
```

### 不要将动态列表用作类型列表

当你想要一个包含不同种类的元素的列表时，`dynamic` 列表是很好的选择。然而，你不能将 `dynamic` 列表用作类型列表。

这个规则也适用于泛型类型的实例。

以下代码创建了一个 `Dog` 的 `dynamic` 列表，并将其赋值给类型为 `Cat` 的列表，这在静态分析期间会生成错误。

```dart tag=fails-sa
void main() {
  List<Cat> foo = <dynamic>[Dog()]; // Error
  List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK
}
```

## 运行时检查

运行时检查处理在编译时无法检测到的类型安全问题。

例如，以下代码在运行时会抛出异常，因为将狗的列表转换为猫的列表是错误的：

```dart tag=runtime-fail
// ✗ runtime: failure

void main() {
  List<Animal> animals = <Dog>[Dog()];
  List<Cat> cats = animals as List<Cat>;
}
```

## 类型推断

分析器可以推断字段、方法、局部变量和大多数泛型类型参数的类型。当分析器没有足够的信息来推断特定类型时，它会使用 `dynamic` 类型。

下面是一个类型推断如何与泛型一起工作的示例。在这个示例中，一个名为 `arguments` 的变量保存了一个将字符串键与各种类型的值配对的映射。

如果你明确地为变量指定类型，你可能会这样写：

```dart
Map<String, dynamic> arguments = {'argA': 'hello', 'argB': 42};
```

或者，你可以使用 `var` 或 `final`，让 Dart 推断类型：

```dart
var arguments = {'argA': 'hello', 'argB': 42}; // Map<String, Object>
```

映射字面量根据其条目推断其类型，然后变量根据映射字面量的类型推断其类型。在这个映射中，键都是字符串，但值具有不同的类型（`String` 和 `int`，它们的上界是 `Object`）。因此，映射字面量的类型是 `Map<String, Object>`，`arguments` 变量也是这种类型。

### 字段和方法推断

没有指定类型且重写了超类字段或方法的字段或方法，将继承超类方法或字段的类型。

没有声明或继承类型但声明了初始值的字段，其类型根据初始值进行推断。

### 静态字段推断

静态字段和变量的类型从它们的初始化器中推断。注意，如果推断过程中遇到循环（即推断变量类型依赖于知道该变量的类型），推断将失败。

### 局部变量推断

局部变量的类型从其初始化器中推断（如果有的话）。随后赋值不会被考虑。这可能意味着推断出的类型过于精确。如果是这样，你可以添加类型注释。

```dart tag=fails-sa
// ✗ static analysis: failure
var x = 3; // x is inferred as an int.
x = 4.0;
```

```dart tag=passes-sa
// ✔ static analysis: success
num y = 3; // A num can be double or int.
y = 4.0;
```

### 类型参数推断

构造函数调用和泛型方法调用的类型参数是根据调用上下文中的向下信息和从构造函数或泛型方法的参数中获取的向上信息推断的。如果推断结果不符合你的期望，你可以始终显式指定类型参数。

```dart tag=passes-sa
// ✔ static analysis: success

// Inferred as if you wrote <int>[].
List<int> listOfInt = [];

// Inferred as if you wrote <double>[3.0].
var listOfDouble = [3.0];

// Inferred as Iterable<int>.
var ints = listOfDouble.map((x) => x.toInt());
```

在最后一个示例中，`x` 使用向下信息被推断为 `double`。闭包的返回类型使用向上信息被推断为 `int`。Dart 在推断 `map()` 方法的类型参数时使用这个返回类型作为向上信息：`<int>`。

## 类型替换

当你重写一个方法时，你用新方法中的某种类型替换了旧方法中的某种类型。类似地，当你向函数传递一个参数时，你用另一种类型（实际参数）替换了具有一种类型（声明了类型的参数）的东西。那么，什么时候可以用一种类型的子类型或超类型替换某种类型的东西呢？

在替换类型时，考虑 _消费者_ 和 _生产者_ 的概念会有所帮助。消费者吸收一种类型，而生产者生成一种类型。

**你可以用超类型替换消费者的类型，用子类型替换生产者的类型。**

让我们来看一些简单的类型赋值和泛型类型赋值的例子。

### 简单类型赋值

在将对象赋值给对象时，什么时候可以用不同的类型替换一种类型？答案取决于对象是消费者还是生产者。

考虑以下类型层次结构：

![alt text](resource:assets/markdown/image-1.png)

考虑以下简单的赋值，其中 Cat c 是一个 消费者，而 Cat() 是一个 生产者：

```dart
Cat c = Cat();
```

在消费位置上，用消费特定类型（`Cat`）的东西替换消费任何东西（`Animal`）的东西是安全的，所以用 `Animal c` 替换 `Cat c` 是允许的，因为 `Animal` 是 `Cat` 的超类型。

```dart tag=passes-sa
Animal c = Cat();
```

但是用 MaineCoon c 替换 Cat c 会破坏类型安全性，因为超类可能会提供具有不同行为的 Cat 类型，比如 Lion：

```dart tag=fails-sa
// ✗ static analysis: failure

MaineCoon c = Cat();
```

在生产位置上，用生成特定类型（Cat）的东西替换为更具体的类型（MaineCoon）是安全的。所以，以下是允许的：

```dart tag=passes-sa
// ✔ static analysis: success

Cat c = MaineCoon();
```

### 泛型类型赋值

泛型类型的规则是否相同？是的。考虑动物列表的层次结构——`Cat` 的 `List` 是 `Animal` 的 `List` 的子类型，也是 `MaineCoon` 的 `List` 的超类型：

![alt text](resource:assets/markdown/image-2.png)

在以下示例中，你可以将 MaineCoon 列表赋值给 myCats，因为 List\<MaineCoon\> 是 List\<Cat\> 的子类型：

```dart tag=passes-sa
// ✔ static analysis: success

List<MaineCoon> myMaineCoons = ...
List<Cat> myCats = myMaineCoons;
```

反过来呢？你能将 Animal 列表赋值给 List\<Cat\> 吗？

```dart tag=fails-sa
// ✗ static analysis: failure

List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals;
```

这种赋值不会通过静态分析，因为它创建了一个隐式向下转换，这是在非 dynamic 类型（如 Animal）中不允许的。

为了使这种类型的代码通过静态分析，你可以使用显式转换。

```dart
List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals as List<Cat>;
```

显式转换在运行时仍可能失败，这取决于被转换列表（myAnimals）的实际类型。

### Methods

当重写方法时，生产者和消费者规则仍然适用。例如：

![alt text](resource:assets/markdown/image-3.png)

对于消费者（例如 chase(Animal) 方法），你可以用超类型替换参数类型。对于生产者（例如 parent 的 getter 方法），你可以用子类型替换返回类型。
