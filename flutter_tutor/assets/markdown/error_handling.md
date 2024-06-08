# Error handling

## Exceptions

你的 Dart 代码可以抛出和捕获异常。异常是表示发生了意外情况的错误。如果异常没有被捕获，抛出异常的隔离区将被挂起，通常该隔离区及其程序将被终止。

与 Java 相比，Dart 的所有异常都是未检查异常。方法不会声明它们可能抛出的异常，你也不需要捕获任何异常。

Dart 提供了 `Exception` 和 `Error` 类型，以及许多预定义的子类型。当然，你也可以定义自己的异常。然而，Dart 程序可以抛出任何非空对象——不仅仅是 Exception 和 Error 对象——作为异常。

### Throw

这是一个抛出或*引发*异常的示例：

```dart
throw FormatException('Expected at least 1 section');
```

你也可以抛出任意对象：

```dart
throw 'Out of llamas!';
```

> note
> 生产质量的代码通常会抛出实现 `Error` 或 `Exception` 的类型。

因为抛出异常是一个表达式，你可以在 => 语句中抛出异常，以及在任何允许表达式的地方：

```dart
void distanceTo(Point other) => throw UnimplementedError();
```

### Catch

捕获异常可以阻止异常传播（除非你重新抛出异常）。捕获异常使你有机会处理它：

```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  buyMoreLlamas();
}
```

要处理可能抛出多种类型异常的代码，你可以指定多个 catch 子句。第一个与抛出对象的类型匹配的 catch 子句将处理异常。如果 catch 子句没有指定类型，则该子句可以处理任何类型的抛出对象：

```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  // A specific exception
  buyMoreLlamas();
} on Exception catch (e) {
  // Anything else that is an exception
  print('Unknown exception: $e');
} catch (e) {
  // No specified type, handles all
  print('Something really unknown: $e');
}
```

如前面的代码所示，你可以使用 `on` 或 `catch` 或两者兼用。当你需要指定异常类型时，使用 `on`。当你的异常处理器需要异常对象时，使用 `catch`。

你可以为 `catch()` 指定一个或两个参数。第一个是抛出的异常，第二个是堆栈跟踪（一个 `StackTrace` 对象）。

```dart
try {
  // ···
} on Exception catch (e) {
  print('Exception details:\n $e');
} catch (e, s) {
  print('Exception details:\n $e');
  print('Stack trace:\n $s');
}
```

要部分处理异常，同时允许它传播，使用 `rethrow` 关键字。

```dart
void misbehave() {
  try {
    dynamic foo = true;
    print(foo++); // Runtime error
  } catch (e) {
    print('misbehave() partially handled ${e.runtimeType}.');
    rethrow; // Allow callers to see the exception.
  }
}

void main() {
  try {
    misbehave();
  } catch (e) {
    print('main() finished handling ${e.runtimeType}.');
  }
}
```

### Finally

要确保某些代码无论是否抛出异常都运行，使用 `finally` 子句。如果没有 `catch` 子句匹配异常，异常将在 `finally` 子句运行后传播：

```dart
try {
  breedMoreLlamas();
} finally {
  // Always clean up, even if an exception is thrown.
  cleanLlamaStalls();
}
```

`finally` 子句在所有匹配的 `catch` 子句之后运行：

```dart
try {
  breedMoreLlamas();
} catch (e) {
  print('Error: $e'); // Handle the exception first.
} finally {
  cleanLlamaStalls(); // Then clean up.
}
```

## Assert

在开发过程中，使用断言语句—— `assert(<condition>, <optionalMessage>);`——如果布尔条件为假，则中断正常执行。

```dart
// Make sure the variable has a non-null value.
assert(text != null);

// Make sure the value is less than 100.
assert(number < 100);

// Make sure this is an https URL.
assert(urlString.startsWith('https'));
```

要为断言附加消息，可以添加一个字符串作为 `assert` 的第二个参数（可选地带一个逗号）：

```dart
assert(urlString.startsWith('https'),
    'URL ($urlString) should start with "https".');
```

`assert` 的第一个参数可以是任何解析为布尔值的表达式。如果表达式的值为真，则断言成功并继续执行。如果为假，则断言失败并抛出异常（`AssertionError`）。

断言究竟何时起作用？
这取决于你使用的工具和框架：

* Flutter 在调试模式下启用断言。
* 仅用于开发的工具（如 `webdev serve`）通常默认启用断言。
* 一些工具（如 `dart run` 和 `dart compile js`）通过命令行标志 `--enable-asserts` 支持断言。

在生产代码中，断言会被忽略，并且不会评估 `assert` 的参数。
