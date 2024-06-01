# Typedefs

类型别名——通常称为 _typedef_，因为它是用关键字 `typedef` 声明的——是一种简洁的引用类型的方法。
以下是声明和使用名为 `IntList` 的类型别名的示例：

```dart
typedef IntList = List<int>;
IntList il = [1, 2, 3];
```

类型别名可以有类型参数：

```dart
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {}; // Verbose.
ListMapper<String> m2 = {}; // 更简洁、更清晰。
```

> version-note
> 在 2.13 之前，typedefs 仅限于函数类型。
> 使用新的 typedefs 需要至少 2.13 的 语言版本。

我们建议在大多数情况下使用 内联函数类型 而不是函数 typedefs。
然而，函数 typedefs 仍然有用处：

```dart
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare<int>); // True!
}
```
