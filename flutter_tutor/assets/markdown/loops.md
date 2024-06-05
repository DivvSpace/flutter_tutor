# loops

此页面展示了如何使用循环和支持语句来控制 Dart 代码的流程：

- `for` 循环
- `while` 和 `do while` 循环
- `break` 和 `continue`

你还可以使用以下方式来操作 Dart 中的控制流：

- 分支，例如 `if` 和 `switch`
- 异常处理，例如 `try`、`catch` 和 `throw`

## For loops

你可以使用标准的 `for` 循环进行迭代。例如：

```dart
var message = StringBuffer('Dart is fun');
for (var i = 0; i < 5; i++) {
  message.write('!');
}
```

Dart 的 `for` 循环中的闭包捕获索引的_值_。这避免了 JavaScript 中常见的陷阱。例如，考虑以下代码：

```dart
var callbacks = [];
for (var i = 0; i < 2; i++) {
  callbacks.add(() => print(i));
}

for (final c in callbacks) {
  c();
}
```

输出结果如预期是 `0` 和 `1`。相反，这个例子在 JavaScript 中会打印 `2` 和 `2`。

有时在遍历类似 `List` 或 `Set` 的 `Iterable` 类型时，你可能不需要知道当前的迭代计数器。在这种情况下，可以使用 `for-in` 循环来编写更简洁的代码：

```dart
for (final candidate in candidates) {
  candidate.interview();
}
```

要处理从迭代器中获取的值，还可以在 `for-in` 循环中使用模式：

```dart
for (final Candidate(:name, :yearsExperience) in candidates) {
  print('$name has $yearsExperience of experience.');
}
```

Iterable 类也有一个 forEach() 方法作为另一种选择：

```dart
var collection = [1, 2, 3];
collection.forEach(print); // 1 2 3
```

## While and do-while

`while` 循环在循环之前评估条件：

```dart
while (!isDone()) {
  doSomething();
}
```

`do`-`while` 循环在循环*之后*评估条件：

```dart
do {
  printLine();
} while (!atEndOfPage());
```

## Break and continue

使用 `break` 来停止循环：

```dart
while (true) {
  if (shutDownRequested()) break;
  processIncomingRequests();
}
```

使用 `continue` 来跳到下一个循环迭代：

```dart
for (int i = 0; i < candidates.length; i++) {
  var candidate = candidates[i];
  if (candidate.yearsExperience < 5) {
    continue;
  }
  candidate.interview();
}
```

如果你使用的是 `Iterable`，例如列表或集合，你编写前面示例的方式可能会有所不同：

```dart
candidates
    .where((c) => c.yearsExperience >= 5)
    .forEach((c) => c.interview());
```
