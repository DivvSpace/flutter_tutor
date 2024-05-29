# Metadata

使用元数据为您的代码提供附加信息。元数据注释以字符 `@` 开头，后面跟一个编译时常量的引用（例如 `deprecated`）或一个常量构造函数的调用。

所有 Dart 代码中都可以使用四种注释：`@Deprecated`, `@deprecated`, `@override`, 和 `@pragma`。

以下是使用 `@Deprecated` 注释的示例：

```dart
class Television {
  /// Use [turnOn] to turn the power on instead.
  [!@Deprecated('Use turnOn instead')!]
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {...}
  // ···
}
```

如果您不想指定消息，可以使用 `@deprecated`。不过，建议始终使用 `@Deprecated` 指定一条消息。

您可以定义自己的元数据注释。下面是定义一个带有两个参数的 `@Todo` 注释的示例：

```dart
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

以下是使用 `@Todo` 注释的示例：

```dart
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

元数据可以出现在库、类、类型定义、类型参数、构造函数、工厂函数、字段、参数或变量声明之前以及导入或导出指令之前。
