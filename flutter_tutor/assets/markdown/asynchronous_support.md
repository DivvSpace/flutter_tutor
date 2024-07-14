# Asynchrony support

Dart库中充满了返回Future或Stream对象的函数。
这些函数是_异步_的：
它们在设置一个可能耗时的操作（例如I/O）后返回，
而不等待该操作完成。

async和await关键字支持异步编程，
让你编写的异步代码看起来类似于同步代码。

## Handling Futures

当你需要已完成的Future的结果时，你有两个选择：

* 使用`async`和`await`
* 使用Future API

使用`async`和`await`的代码是异步的，但看起来很像同步代码。例如，下面是一些使用`await`等待异步函数结果的代码：

```dart
await lookUpVersion();
```

要使用`await`，代码必须在一个`async`函数中——一个标记为`async`的函数：

```dart
Future<void> checkVersion() async {
  var version = await lookUpVersion();
  // Do something with version
}
```

> note
> 尽管一个`async`函数可能执行耗时的操作，但它不会等待这些操作完成。相反，`async`函数只执行到遇到第一个`await`表达式为止。然后它返回一个`Future`对象，并仅在`await`表达式完成后恢复执行。

使用`try`、`catch`和`finally`来处理使用`await`的代码中的错误和清理工作：

```dart
try {
  version = await lookUpVersion();
} catch (e) {
  // React to inability to look up the version
}
```

在`async`函数中可以多次使用`await`。例如，以下代码多次等待函数的结果：

```dart
var entrypoint = await findEntryPoint();
var exitCode = await runExecutable(entrypoint, args);
await flushThenExit(exitCode);
```

在await expression中，expression的值通常是一个Future；如果不是，那么该值会自动包装在一个Future中。这个Future对象表示一个返回对象的承诺。await expression的值是返回的那个对象。await表达式使执行暂停，直到该对象可用。

**如果在使用`await`时遇到编译时错误，请确保`await`在一个`async`函数中。**
例如，要在应用程序的`main()`函数中使用`await`，`main()`函数的主体必须标记为`async`：

```dart
void main() async {
  checkVersion();
  print('In main: version is ${await lookUpVersion()}');
}
```

> note
> 前面的示例使用了一个`async`函数（`checkVersion()`），但没有等待结果——如果代码假设该函数已执行完毕，这种做法可能会导致问题。为了避免这个问题，可以使用unawaited_futures linter规则。

## 声明异步函数

`async`函数是其主体用`async`修饰符标记的函数。

将`async`关键字添加到函数中会使其返回一个Future。例如，考虑这个返回String的同步函数：

```dart
String lookUpVersion() => '1.0.0';
```

如果你将其更改为`async`函数——例如，因为将来的实现会耗费时间——则返回值是一个Future：

```dart
Future<String> lookUpVersion() async => '1.0.0';
```

注意，函数的主体不需要使用Future API。如果有必要，Dart会创建Future对象。如果你的函数不返回有用的值，请将其返回类型设为`Future<void>`。

## Handling Streams

当你需要从Stream中获取值时，有两种选择：

* 使用`async`和_异步for循环_（`await for`）。
* 使用Stream API，如`dart:async`文档中所述。

> note
> 在使用`await for`之前，确保它能使代码更清晰，并且你确实想等待所有流的结果。例如，对于UI事件监听器，你通常**不**应该使用`await for`，因为UI框架会发送无尽的事件流。

异步for循环的形式如下：

```dart
await for (varOrType identifier in expression) {
  // Executes each time the stream emits a value.
}
```

表达式的值必须是Stream类型。执行过程如下：

1. 等待流发出一个值。
2. 执行for循环的主体，并将变量设置为发出的值。
3. 重复步骤1和2，直到流关闭。

要停止监听流，你可以使用`break`或`return`语句，这会跳出for循环并取消订阅流。

**如果在实现异步for循环时遇到编译时错误，请确保`await for`在一个`async`函数中。**
例如，要在应用的`main()`函数中使用异步for循环，`main()`的主体必须标记为`async`：


```dart
void main() async {
  // ...
  await for (final request in requestServer) {
    handleRequest(request);
  }
  // ...
}
```
