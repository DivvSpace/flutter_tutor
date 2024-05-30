# Libraries & imports

`import` 和 `library` 指令可以帮助您创建一个模块化且可共享的代码库。库不仅提供 API，还作为隐私单元：以下划线 (`_`) 开头的标识符只在库内部可见。*每个 Dart 文件（及其部分）都是一个库*，即使它没有使用 `library` 指令。

库可以通过包进行分发。

## Using libraries

使用 `import` 来指定如何在一个库的作用域中使用另一个库的命名空间。

例如，Dart 网络应用程序通常使用 `dart:html` 库，可以像这样导入：

```dart
import 'dart:html';
```

唯一需要传递给 import 的参数是指定库的 URI。
对于内置库，URI 具有特殊的 dart: 方案。
对于其他库，你可以使用文件系统路径或 package: 方案。package: 方案指定了由包管理工具（如 pub 工具）提供的库。例如：

```dart
import 'package:test/test.dart';
```

> note
> *URI* 代表统一资源标识符。
> *URLs*（统一资源定位符）是一种常见的 URI。

### 指定库前缀

如果您导入的两个库有冲突的标识符，那么您可以为其中一个或两个库指定前缀。例如，如果 library1 和 library2 都有一个 Element 类，那么您的代码可能如下所示：

```dart
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

// Uses Element from lib1.
Element element1 = Element();

// Uses Element from lib2.
lib2.Element element2 = lib2.Element();
```

### 仅导入部分库

如果您只想使用库的一部分，可以选择性地导入该库。例如：

```dart
// Import only foo.
import 'package:lib1/lib1.dart' show foo;

// Import all names EXCEPT foo.
import 'package:lib2/lib2.dart' hide foo;
```

#### 延迟加载库

*延迟加载*（也叫*惰性加载*）允许 Web 应用在需要时按需加载库。遇到以下一种或多种需求时，可以使用延迟加载。

* 减少 Web 应用最初的启动时间。
* 进行 A/B 测试——例如，尝试算法的替代实现。
* 加载很少使用的功能，例如可选的屏幕和对话框。

这并不意味着 Dart 在启动时加载所有延迟组件。Web 应用可以在需要时通过网络下载延迟组件。

`dart` 工具不支持用于 Web 以外目标的延迟加载。

要延迟加载库，首先使用 `deferred as` 导入它。

```dart
import 'package:greetings/hello.dart' deferred as hello;
```

当您需要该库时，使用库的标识符调用 loadLibrary()。

```dart
Future<void> greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
```

在上面的代码中，await 关键字会暂停执行，直到库加载完毕.
您可以多次调用 loadLibrary() 而不会出现问题。该库只会加载一次。
使用延迟加载时，请记住以下几点：
延迟库的常量在导入文件中不是常量。请记住，这些常量在延迟库加载之前是不存在的。
您不能在导入文件中使用延迟库中的类型。相反，可以考虑将接口类型移动到导入延迟库和导入文件的库中。
Dart 会隐式地在您使用 `deferred as namespace` 定义的命名空间中插入 loadLibrary()。
loadLibrary() 函数返回一个 Future。

### `library` 指令

要指定库级别的文档注释或元数据注释，请将它们附加到文件开头的 `library` 声明上。

```dart
/// A really great test library.
@TestOn('browser')
library;
```
