# extension types

扩展类型是一种编译时抽象，它通过一个不同的、仅限静态的接口“包装”现有类型。它们是静态 JS 互操作的主要组件，因为它们可以轻松修改现有类型的接口（对于任何形式的互操作都是至关重要的），而不会产生实际包装器的成本。

扩展类型对可用于基础类型对象（称为*表示类型*）的一组操作（或接口）实施约束。在定义扩展类型的接口时，可以选择重用表示类型的一些成员，省略其他成员，替换其他成员，并添加新功能。

以下示例包装了 `int` 类型，以创建一个仅允许对 ID 号码有意义的操作的扩展类型：

扩展类型 IdNumber(int id) {
  // 包装 'int' 类型的 '<' 操作符：
  operator <(IdNumber other) => id < other.id;
  // 例如，不声明 '+' 操作符，
  // 因为加法对 ID 号码没有意义。
}

void main() {
  // 如果没有扩展类型的约束，
  // 'int' 会导致 ID 号码暴露于不安全操作：
  int myUnsafeId = 42424242;
  myUnsafeId = myUnsafeId + 10; // 这是可行的，但不应该允许用于 ID。
  
  var safeId = IdNumber(42424242);
  safeId + 10; // 编译时错误：没有 '+' 操作符。
  myUnsafeId = safeId; // 编译时错误：类型错误。
  myUnsafeId = safeId as int; // 可以：运行时转换为表示类型。
  safeId < IdNumber(42424241); // 可以：使用包装的 '<' 操作符。
}

> note
> 扩展类型的作用与**包装类**相同，但不需要创建额外的运行时对象，这在需要包装大量对象时会变得昂贵。由于扩展类型仅限于静态并在运行时被编译掉，它们实际上是零成本的。
> **扩展方法**（也称为“扩展”）是一种类似于扩展类型的静态抽象。然而，扩展方法*直接*向其基础类型的每个实例添加功能。扩展类型则不同；扩展类型的接口*仅*适用于静态类型为该扩展类型的表达式。默认情况下，它们与其基础类型的接口是不同的。

## Syntax

### 声明

使用 `extension type` 声明和名称定义一个新的扩展类型，后跟括号中的*表示类型声明*：

```dart
extension type E(int i) {
  // 定义操作集。
}
```

表示类型声明 `(int i)` 指定扩展类型 `E` 的基础类型是 `int`，并且对*表示对象*的引用命名为 `i`。声明还引入了：

- 一个隐式的表示对象的 getter，其返回类型为表示类型：`int get i`。
- 一个隐式构造函数：`E(int i) : i = i`。

表示对象使扩展类型能够访问基础类型的对象。该对象在扩展类型体内是可见的，并且可以使用其名称作为 getter 进行访问：

- 在扩展类型体内使用 `i`（或在构造函数中使用 `this.i`）。
- 在外部通过属性提取使用 `e.i`（其中 `e` 具有扩展类型作为其静态类型）。

扩展类型声明也可以像类或扩展一样包含类型参数：

```dart
extension type E<T>(List<T> elements) {
  // ...
}
```

### 构造函数

您可以选择在扩展类型的主体中声明构造函数。表示声明本身是一个隐式构造函数，因此默认情况下代替扩展类型的未命名构造函数。任何额外的非重定向生成构造函数必须在其初始化列表或正式参数中使用 `this.i` 初始化表示对象的实例变量。

```dart
extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;
}

void main() {
  E(4); // 隐式未命名构造函数。
  E.n(3); // 命名构造函数。
  E.m(5, "Hello!"); // 带有附加参数的命名构造函数。
}
```

或者，您可以为表示声明构造函数命名，这种情况下主体中有空间用于未命名构造函数：

```dart
extension type const E._(int it) {
  E(): this._(42);
  E.otherName(this.it);
}

void main2() {
  E();
  const E._(2);
  E.otherName(3);
}
```

您也可以完全隐藏构造函数，而不仅仅是定义一个新的构造函数，使用类的相同私有构造函数语法 `_`。例如，如果您只希望客户端使用 `String` 构造 `E`，即使基础类型是 `int`：

```dart
extension type E._(int i) {
  E.fromString(String foo) : i = int.parse(foo);
}
```

您还可以声明转发生成构造函数或工厂构造函数（这些工厂构造函数也可以转发到子扩展类型的构造函数）。

### 成员

在扩展类型的主体中声明成员，以定义其接口，就像为类成员定义接口一样。扩展类型成员可以是方法、获取器、设置器或操作符（不允许使用非 `external` 实例变量和抽象成员）：

```dart
extension type NumberE(int value) {
  // Operator:
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);
  // Getter:
  NumberE get myNum => this;
  // Method:
  bool isValid() => !value.isNegative;
}
```

表示类型的接口成员默认情况下不是扩展类型的接口成员。要在扩展类型中使表示类型的单个成员可用，必须在扩展类型定义中为其编写声明，例如 `NumberE` 中的 `operator +`。您还可以定义与表示类型无关的新成员，例如 `i` 获取器和 `isValid` 方法。

### 实现(Implements)

您可以选择使用 `implements` 子句来：

- 在扩展类型上引入子类型关系,AND
- 将表示对象的成员添加到扩展类型接口中。

`implements` 子句引入了一种适用性关系，就像在扩展方法与其 `on` 类型之间的关系一样。适用于超类型的成员也适用于子类型，除非子类型有一个具有相同成员名称的声明。

一个扩展类型只能实现：

- **它的表示类型**。
  这使得表示类型的所有成员隐式可用于扩展类型。

  ```dart
  extension type NumberI(int i) implements int {
    // 'NumberI' 可以调用 'int' 的所有成员，
    // 以及在此声明的任何其他内容。
  }
  ```
  
- **它的表示类型的超类型**。
  这使得超类型的成员可用，而不一定是表示类型的所有成员。

  ```dart
  extension type Sequence<T>(List<T> _) implements Iterable<T> {
    // 比 List 更好的操作。
  }

  extension type Id(int _id) implements Object {
    // 使扩展类型不可为空。
    static Id? tryParse(String source) => int.tryParse(source) as Id?;
  }
  ```
  
- **另一个扩展类型**，该类型在相同的表示类型上有效。
  这允许您跨多个扩展类型重用操作（类似于多重继承）。
  
  ```dart
  extension type const Opt<T>._(({T value})? _) { 
    const factory Opt(T value) = Val<T>;
    const factory Opt.none() = Non<T>;
  }
  extension type const Val<T>._(({T value}) _) implements Opt<T> { 
    const Val(T value) : this._((value: value));
    T get value => _.value;
  }
  extension type const Non<T>._(Null _) implements Opt<Never> {
    const Non() : this._(null);
  }
  ```

阅读“用法”部分以了解 `implements` 在不同场景下的效果。

#### `@redeclare`

声明一个扩展类型成员，其名称与超类型成员相同，这*不是*像类之间那样的重写关系，而是*重新声明*。扩展类型成员声明*完全取代*任何具有相同名称的超类型成员。无法为同一个函数提供替代实现。

您可以使用 `@redeclare` 注解来告诉编译器，您是*有意*选择使用与超类型成员相同的名称。如果事实并非如此，例如其中一个名称拼写错误，分析器将警告您。

```dart
extension type MyString(String _) implements String {
  // Replaces 'String.operator[]'
  @redeclare
  int operator [](int index) => codeUnitAt(index);
}
```

您还可以启用 lint `annotate_redeclares`，如果您声明了一个扩展类型方法，该方法隐藏了一个超接口成员且*没有*用 `@redeclare` 注解，那么将会收到警告。

## Usage

要使用扩展类型，与使用类相同，创建实例方法是调用构造函数：

```dart
extension type NumberE(int value) {
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);

  NumberE get next => NumberE(value + 1);
  bool isValid() => !value.isNegative;
}

void testE() { 
  var num = NumberE(1);
}
```

然后，您可以像调用类对象一样调用对象上的成员。

扩展类型有两种同样有效但实质上不同的核心用例：

1. 为现有类型提供*扩展*接口。
2. 为现有类型提供*不同*接口。

> note
> 无论在哪种情况下，扩展类型的表示类型从来不是它的子类型，因此在需要扩展类型的地方，表示类型不能互换使用。

### 1. 为现有类型提供*扩展*接口

当扩展类型实现其表示类型时，可以认为它是“透明的”，因为它允许扩展类型“看到”底层类型。

透明扩展类型可以调用表示类型的所有成员（未重新声明的成员），以及它定义的任何辅助成员。这为现有类型创建了一个新的、*扩展的*接口。新接口可用于静态类型为扩展类型的表达式。

这意味着您*可以*调用表示类型的成员（与非透明扩展类型不同），例如：

```dart
extension type NumberT(int value) implements int {
  // 没有显式声明 `int` 类型的任何成员。
  NumberT get i => this;
}

void main () {
  // All OK: 透明性允许在扩展类型上调用 `int` 成员：
  var v1 = NumberT(1); // v1 type: NumberT
  int v2 = NumberT(2); // v2 type: int
  var v3 = v1.i - v1;  // v3 type: int
  var v4 = v2 + v1; // v4 type: int
  var v5 = 2 + v1; // v5 type: int
  // Error: 扩展类型接口对表示类型不可用。
  v2.i;
}
```

您还可以拥有一个“几乎透明”的扩展类型，通过重新声明超类型中的给定成员名称来添加新成员并调整其他成员。这将允许您对某些方法参数使用更严格的类型，或者使用不同的默认值，例如。

另一种几乎透明的扩展类型方法是实现一个作为表示类型超类型的类型。例如，如果表示类型是私有的，但其超类型定义了对客户端重要的接口部分。

### 2. 为现有类型提供*不同的*接口

一个非透明的扩展类型（即不`实现`其表示类型）在静态上被视为一个全新的类型，与其表示类型不同。您不能将其分配给其表示类型，并且它不会暴露其表示类型的成员。

例如，考虑我们在用法中声明的 `NumberE` 扩展类型：

```dart
void testE() { 
  var num1 = NumberE(1);
  int num2 = NumberE(2); // 错误：不能将 'NumberE' 分配给 'int'。
  
  num1.isValid(); // OK：扩展成员调用。
  num1.isNegative(); // 错误：'NumberE' 未定义 'int' 成员 'isNegative'。
  
  var sum1 = num1 + num1; // OK：'NumberE' 定义了 '+'。
  var diff1 = num1 - num1; // 错误：'NumberE' 未定义 'int' 成员 '-'。
  var diff2 = num1.value - 2; // OK：可以通过引用访问表示对象。
  var sum2 = num1 + 2; // 错误：不能将 'int' 分配给参数类型 'NumberE'。
  
  List<NumberE> numbers = [
    NumberE(1), 
    num1.next, // OK：'next' getter 返回类型 'NumberE'。
    1, // 错误：不能将 'int' 元素分配给列表类型 'NumberE'。
  ];
}

```

您可以通过这种方式使用扩展类型来*替换*现有类型的接口。这允许您为新类型的约束建模一个合理的接口（例如引言中的 `IdNumber` 示例），同时也能从简单预定义类型（如 `int`）的性能和便利性中受益。

这个用例与完全封装的包装类最为接近（但实际上只是一个*某种程度上*受保护的抽象）。

## 类型考虑

扩展类型是一种编译时包装构造。在运行时，扩展类型完全没有任何痕迹。任何类型查询或类似的运行时操作都作用于表示类型。

这使得扩展类型成为一种*不安全*的抽象，因为您总是可以在运行时找到表示类型并访问底层对象。

动态类型测试（`e is T`）、强制转换（`e as T`）以及其他运行时类型查询（如 `switch (e) ...` 或 `if (e case ...)`）都对底层表示对象进行评估，并根据该对象的运行时类型进行类型检查。这在 `e` 的静态类型是扩展类型以及对扩展类型进行测试时（如 `case MyExtensionType(): ...`）都成立。

```dart
void main() {
  var n = NumberE(1);

  // Run-time type of 'n' is representation type 'int'.
  if (n is int) print(n.value); // Prints 1.

  // Can use 'int' methods on 'n' at run time.
  if (n case int x) print(x.toRadixString(10)); // Prints 1.
  switch (n) {
    case int(:var isEven): print("$n (${isEven ? "even" : "odd"})"); // Prints 1 (odd).
  }
}
```

类似地，在这个例子中，匹配值的静态类型是扩展类型的类型：

```dart
void main() {
  int i = 2;
  if (i is NumberE) print("It is"); // Prints 'It is'.
  if (i case NumberE v) print("value: ${v.value}"); // Prints 'value: 2'.
  switch (i) {
    case NumberE(:var value): print("value: $value"); // Prints 'value: 2'.
  }
}
```

在使用扩展类型时，意识到这一特性是很重要的。请始终记住，扩展类型在编译时存在并且很重要，但在编译过程中会被擦除。

例如，考虑一个表达式 `e`，其静态类型是扩展类型 `E`，而 `E` 的表示类型是 `R`。那么，`e` 的值的运行时类型是 `R` 的子类型。即使类型本身被擦除，`List<E>` 在运行时与 `List<R>` 完全相同。

换句话说，真正的包装类可以封装一个被包装的对象，而扩展类型只是对被包装对象的编译时视图。虽然真正的包装类更安全，但权衡之下，扩展类型允许您避免使用包装对象，这在某些场景中可以显著提高性能。
