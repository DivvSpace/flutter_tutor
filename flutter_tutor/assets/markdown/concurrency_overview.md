# Concurrency Overview

本页面包含关于 Dart 中并发编程如何工作的概念概述。它从高层次解释了事件循环、异步语言特性和隔离区。

Dart 中的并发编程指的是异步 API，如 `Future` 和 `Stream`，以及*isolates*，它们允许你将进程移到独立的处理核心上。

所有 Dart 代码都运行在隔离区中，从默认的主隔离区开始，并可选择扩展到你显式创建的后续隔离区。当你生成一个新的隔离区时，它有自己的隔离内存和自己的事件循环。事件循环是使 Dart 中的异步和并发编程成为可能的机制。

## Event Loop

Dart 的运行时模型基于事件循环。事件循环负责执行程序代码、收集和处理事件等。

当你的应用程序运行时，所有事件都会被添加到一个队列中，称为*事件队列*。事件可以是从请求重新绘制 UI，到用户点击和键击，再到磁盘 I/O 的任何内容。因为你的应用程序无法预测事件发生的顺序，事件循环按事件排队的顺序一次处理一个事件。

![alt text](resource:assets/markdown/image-4.png)

事件循环的功能类似于以下代码：

```dart
while (eventQueue.waitForEvent()) {
  eventQueue.processNextEvent();
}
```

这个示例事件循环是同步的，并在单线程上运行。然而，大多数 Dart 应用程序需要同时执行多项任务。例如，一个客户端应用程序可能需要执行一个 HTTP 请求，同时还需要监听用户点击按钮。为了解决这个问题，Dart 提供了许多异步 API，比如 Futures, Streams, 和 async-await。这些 API 都是围绕这个事件循环构建的。

例如，考虑进行一个网络请求：

```dart
http.get('https://example.com').then((response) {
  if (response.statusCode == 200) {
    print('Success!');
  }  
})
```

当这段代码到达事件循环时，它会立即调用第一个子句 `http.get`，并返回一个 `Future`。它还会告诉事件循环在 HTTP 请求解决之前保留 `then()` 子句中的回调。当请求解决时，它应执行该回调，并将请求的结果作为参数传递。

![alt text](resource:assets/markdown/image-5.png)

这种模型通常也是事件循环处理 Dart 中所有其他异步事件的方式，比如 `Stream` 对象。

## 异步编程

本节总结了 Dart 中异步编程的不同类型和语法。如果你已经熟悉 `Future`、`Stream` 和 async-await，那么你可以直接跳到 isolates 部分。

### Futures

`Future` 代表一个异步操作的结果，它最终将以一个值或一个错误完成。

在这个示例代码中，`Future<String>` 的返回类型表示最终将提供一个 `Future<String>` 值（或错误）。

```dart
Future<String> _readFileAsync(String filename) {
  final file = File(filename);

  // .readAsString() returns a Future.
  // .then() registers a callback to be executed when `readAsString` resolves.
  return file.readAsString().then((contents) {
    return contents.trim();
  });
}
```

### async-await 语法

`async` 和 `await` 关键字提供了一种声明性方式来定义异步函数并使用它们的结果。

以下是一个同步代码的示例，该代码在等待文件 I/O 时会阻塞：

```dart
const String filename = 'with_keys.json';

void main() {
  // Read some data.
  final fileData = _readFileSync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

String _readFileSync() {
  final file = File(filename);
  final contents = file.readAsStringSync();
  return contents.trim();
}
```

以下是类似的代码，但进行了更改（高亮显示），使其变为异步：

```dart
const String filename = 'with_keys.json';

void main() async {
  // Read some data.
  final fileData = await _readFileAsync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

Future<String> _readFileAsync() [!async!] {
  final file = File(filename);
  final contents = await file.readAsString();
  return contents.trim();
}
```

`main()` 函数在 `_readFileAsync()` 前使用了 `await` 关键字，以便在本地代码（文件 I/O）执行时让其他 Dart 代码（例如事件处理程序）使用 CPU。使用 `await` 还具有将 `_readFileAsync()` 返回的 `Future<String>` 转换为 `String` 的效果。因此，`contents` 变量具有隐式类型 `String`。

> note
> `await` 关键字仅在函数体前有 `async` 的函数中有效。

如下图所示，当 `readAsString()` 执行非 Dart 代码时，Dart 代码会暂停，无论是在 Dart 运行时还是在操作系统中。一旦 `readAsString()` 返回一个值，Dart 代码的执行将恢复。

![alt text](resource:assets/markdown/image-6.png)

### Streams

Dart 还以流的形式支持异步代码。流在未来和一段时间内反复提供值。提供一系列 `int` 值的类型为 `Stream<int>`。

在以下示例中，使用 `Stream.periodic` 创建的流每秒钟重复发出一个新的 `int` 值。

```dart
Stream<int> stream = Stream.periodic(const Duration(seconds: 1), (i) => i * i);
```

#### await-for and yield

`await-for` 是一种 for 循环，它在提供新值时执行循环的每次后续迭代。换句话说，它用于“遍历”流。在此示例中，当作为参数提供的流发出新值时，函数 `sumStream` 将发出一个新值。在返回值流的函数中，使用 `yield` 关键字而不是 `return`。

```dart
Stream<int> sumStream(Stream<int> stream) async* {
  var sum = 0;
  await for (final value in stream) {
    yield sum += value;
  }
}
```

如果你想了解更多关于使用 `async`、`await`、`Stream` 和 `Future` 的信息，请查看异步编程教程。

## Isolates

除了异步 API 之外，Dart 还通过 isolates 支持并发。大多数现代设备都有多核 CPU。为了利用多个核心，开发人员有时会使用共享内存线程同时运行。然而，共享状态并发容易出错，并且可能导致代码复杂化。

与线程不同，所有 Dart 代码都在 isolates 中运行。使用 isolates，你的 Dart 代码可以同时执行多个独立任务。Isolates 类似于线程或进程，但每个 isolate 都有自己的内存和一个运行事件循环的单线程。

每个 isolate 有自己的全局字段，确保一个 isolate 中的状态无法从任何其他 isolate 访问。Isolates 之间只能通过消息传递进行通信。没有 isolates 之间的共享状态，意味着并发复杂性如互斥锁或锁和数据竞争不会在 Dart 中发生。不过，需要注意的是，isolate 并不会完全防止竞态条件。

使用 isolates，你的 Dart 代码可以同时执行多个独立任务，并在可用时利用额外的处理器核心。Isolates 类似于线程或进程，但每个 isolate 都有自己的内存和一个运行事件循环的单线程。

### The main isolate

在大多数情况下，你根本不需要考虑 isolates。Dart 程序默认在主 isolate 中运行。这是程序开始运行和执行的线程，如下图所示：

![alt text](resource:assets/markdown/image-7.png)

即使是单 isolate 程序也可以顺利执行。在继续执行下一行代码之前，这些应用程序使用 async-await 等待异步操作完成。一个表现良好的应用程序会快速启动，尽快进入事件循环。然后，应用程序及时响应每个排队的事件，根据需要使用异步操作。

### The isolate life cycle

如下面的图示所示，每个 isolate 都通过运行一些 Dart 代码开始，例如 `main()` 函数。这个 Dart 代码可能会注册一些事件监听器——例如响应用户输入或文件 I/O。当 isolate 的初始函数返回时，如果需要处理事件，isolate 会继续存在。处理完事件后，isolate 退出。

![alt text](resource:assets/markdown/image-8.png)

### Event handling

在客户端应用中，主 isolate 的事件队列可能包含重绘请求和点击及其他 UI 事件的通知。例如，下图显示了一个重绘事件，接着是一个点击事件，然后是两个重绘事件。事件循环按先进先出的顺序从队列中取出事件。

![alt text](resource:assets/markdown/image-9.png)

事件处理在 `main()` 退出后在主 isolate 上进行。在下图中，`main()` 退出后，主 isolate 处理第一个重绘事件。之后，主 isolate 处理点击事件，然后是一个重绘事件。

如果一个同步操作耗时过长，应用程序可能会变得无响应。在下图中，点击处理代码耗时过长，因此后续事件处理得太晚。应用程序可能会出现卡顿，并且执行的任何动画可能会变得不流畅。

![A figure showing a tap handler with a too-long execution time](resource:assets/markdown/image-10.png)

在客户端应用中，过长的同步操作通常会导致 卡顿（不流畅）的 UI 动画。更糟的是，UI 可能会完全无响应。

### Background workers

如果你的应用程序的 UI 因耗时操作（例如解析大型 JSON 文件）变得无响应，考虑将该计算装载到一个工作 isolate，通常称为 _后台工作者_。一个常见的情况，如下图所示，是生成一个简单的工作 isolate 来执行计算，然后退出。工作 isolate 在退出时以消息的形式返回其结果。

![A figure showing a main isolate and a simple worker isolate](resource:assets/markdown/image-11.png)

工作 isolate 可以执行 I/O 操作（例如读取和写入文件）、设置定时器等。它有自己的内存，并且不与主 isolate 共享任何状态。工作 isolate 可以阻塞而不影响其他 isolate。

### Using isolates

在 Dart 中，根据使用场景，有两种方式与 isolates 一起工作：

* 使用 `Isolate.run()` 在单独的线程上执行单次计算。
* 使用 `Isolate.spawn()` 创建一个 isolate 来处理多个消息，或用作后台工作者。有关与长期存在的 isolates 一起工作的信息，请阅读 Isolates 页面。

在大多数情况下，`Isolate.run` 是在后台运行进程的推荐 API。

#### `Isolate.run()`

静态方法 `Isolate.run()` 需要一个参数：将在新生成的 isolate 上运行的回调函数。

```dart
int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

// Compute without blocking current isolate.
void fib40() async {
  var result = await Isolate.run(() => slowFib(40));
  print('Fib(40) = $result');
}
```

### Performance and isolate groups

当一个 isolate 调用 `Isolate.spawn()` 时，这两个 isolates 具有相同的可执行代码，并处于同一个 _isolate 组_ 中。Isolate 组可以实现性能优化，例如共享代码；一个新的 isolate 立即运行由 isolate 组拥有的代码。此外，`Isolate.exit()` 仅在 isolates 处于同一个 isolate 组时才能工作。

在某些特殊情况下，你可能需要使用 `Isolate.spawnUri()`，它会使用指定 URI 处的代码副本来设置新的 isolate。然而，`spawnUri()` 比 `spawn()` 慢得多，并且新的 isolate 不在其生成者的 isolate 组中。另一个性能影响是，当 isolates 处于不同的组时，消息传递会较慢。

### Limitations of isolates

#### Isolates aren't threads

如果你是从一个具有多线程的语言转到 Dart，可能会期望 isolates 像线程一样工作，但事实并非如此。每个 isolate 都有自己的状态，确保任何 isolate 中的状态都不能从其他 isolate 访问。因此，isolates 只能访问自己的内存。

例如，如果你的应用程序中有一个全局可变变量，那么在你生成的 isolate 中该变量将是一个独立的变量。如果你在生成的 isolate 中修改该变量，它在主 isolate 中将保持不变。这正是 isolates 的工作方式，当你考虑使用 isolates 时，这一点很重要。

#### Message types

通过 `SendPort` 发送的消息几乎可以是任何类型的 Dart 对象，但有一些例外：

- 具有本地资源的对象，例如 `Socket`。
- `ReceivePort`
- `DynamicLibrary`
- `Finalizable`
- `Finalizer`
- `NativeFinalizer`
- `Pointer`
- `UserTag`
- 使用 `@pragma('vm:isolate-unsendable')` 标记的类的实例

除了这些例外，任何对象都可以发送。有关更多信息，请查看 `SendPort.send` 文档。

请注意，`Isolate.spawn()` 和 `Isolate.exit()` 抽象了 `SendPort` 对象，因此它们也受到相同的限制。

## Web 上的并发

所有 Dart 应用程序都可以使用 `async-await`、`Future` 和 `Stream` 进行非阻塞的交错计算。然而，Dart web 平台不支持 isolates。Dart web 应用程序可以使用 web workers 在后台线程中运行脚本，类似于 isolates。尽管如此，web workers 的功能和能力与 isolates 稍有不同。

例如，当 web workers 在线程之间发送数据时，它们会来回复制数据。数据复制可能非常慢，尤其是对于大型消息。Isolates 也会这样做，但还提供了可以更高效地 _传输_ 存储消息内存的 API。

创建 web workers 和 isolates 也有所不同。你只能通过声明一个单独的程序入口点并单独编译它来创建 web workers。启动 web worker 类似于使用 `Isolate.spawnUri` 启动 isolate。你也可以使用 `Isolate.spawn` 启动 isolate，这需要更少的资源，因为它 重用了生成 isolate 的一些相同代码和数据。Web workers 没有等效的 API。
