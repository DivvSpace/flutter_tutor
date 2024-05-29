# 注释

Dart 支持单行注释、多行注释和文档注释。

## 单行注释

单行注释以 `//` 开头。`//` 和行尾之间的所有内容都会被 Dart 编译器忽略。

```dart
void main() {
  // TODO: 重构为一个 AbstractLlamaGreetingFactory？
  print('欢迎来到我的羊驼农场！');
}
```

## 多行注释

多行注释以 `/*` 开头，以 `*/` 结束。`/*` 和 `*/` 之间的所有内容都会被 Dart 编译器忽略（除非注释是文档注释；请参见下一节）。多行注释可以嵌套。

```dart
void main() {
  /*
   * This is a lot of work. Consider raising chickens.

  Llama larry = Llama();
  larry.feed();
  larry.exercise();
  larry.clean();
   */
}
```

## 文档注释

文档注释是以 `///` 或 `/**` 开头的多行或单行注释。连续几行使用 `///` 的效果与一个多行文档注释相同。

在文档注释中，分析器会忽略所有文本，除非它被括号包围。使用括号，您可以引用类、方法、字段、顶层变量、函数和参数。括号中的名称在被注释的程序元素的词法范围内解析。

以下是引用其他类和参数的文档注释示例：

```dart
/// A domesticated South American camelid (Lama glama).
///
/// Andean cultures have used llamas as meat and pack
/// animals since pre-Hispanic times.
///
/// Just like any other animal, llamas need to eat,
/// so don't forget to [feed] them some [Food].
class Llama {
  String? name;

  /// Feeds your llama [food].
  ///
  /// The typical llama eats one bale of hay per week.
  void feed(Food food) {
    // ...
  }

  /// Exercises your llama with an [activity] for
  /// [timeLimit] minutes.
  void exercise(Activity activity, int timeLimit) {
    // ...
  }
}
```

在类生成的文档中，`[feed]` 会成为指向 `feed` 方法文档的链接，`[Food]` 会成为指向 `Food` 类文档的链接。
