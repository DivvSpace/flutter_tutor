# Collections

Dart 内置了对列表、集合和映射 collections 的支持。
要了解更多关于配置集合包含的类型的信息，请查看 Generics。

## Lists

几乎每种编程语言中最常见的集合可能就是 *数组*，或者说是有序的对象组。在 Dart 中，数组是 `List` 对象，所以大多数人直接称它们为 *列表*。

Dart 列表字面量由逗号分隔的表达式或值组成，并用方括号 (`[]`) 括起来。以下是一个简单的 Dart 列表：

```dart
var list = [1, 2, 3];
```

> note
> Dart 推断 `list` 的类型为 `List<int>`。如果你尝试向这个列表添加非整数对象，分析器或运行时会抛出错误.

你可以在 Dart 集合字面量的最后一项后面添加一个逗号。这个 *尾随逗号* 不会影响集合的内容，但它可以帮助防止复制粘贴错误。

```dart
var list = [
  'Car',
  'Boat',
  'Plane',
];
```

列表使用从零开始的索引，其中 0 是第一个值的索引，`list.length - 1` 是最后一个值的索引。你可以使用 `.length` 属性获取列表的长度，并使用下标运算符 (`[]`) 访问列表的值：

```dart
var list = [1, 2, 3];
assert(list.length == 3);
assert(list[1] == 2);

list[1] = 1;
assert(list[1] == 1);
```

要创建一个编译时常量的列表，在列表字面量前加上 `const`：

```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // This line will cause an error.
```

有关列表的更多信息，请参考 `dart:core` 文档中的列表部分。

## Sets

Dart 中的集合是一个无序的唯一项集合。Dart 对集合的支持由集合字面量和 `Set` 类型提供。

下面是一个简单的 Dart 集合，使用集合字面量创建：

```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

> note
> Dart 推断 `halogens` 的类型为 `Set<String>`。如果你尝试向集合中添加错误类型的值，分析器或运行时会抛出错误。有关更多信息，请阅读类型推断。

要创建一个空集合，请使用带有类型参数的 `{}`，或者将 `{}` 赋值给类型为 `Set` 的变量：

```dart
var names = <String>{};
// Set<String> names = {}; // This works, too.
// var names = {}; // Creates a map, not a set.
```

> Set 还是 Map?
> 映射字面量的语法与集合字面量类似。因为映射字面量先出现，所以 `{}` 默认是 `Map` 类型。如果你忘记了 `{}` 的类型注释或它所赋值的变量，那么 Dart 会创建一个类型为 `Map<dynamic, dynamic>` 的对象。

使用 `add()` 或 `addAll()` 方法向已有集合中添加项：

```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
```

使用 `.length` 获取集合中的项数：

```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
assert(elements.length == 5);
```

要创建一个编译时常量集合，在集合字面量前加上 `const`：

```dart
final constantSet = const {
  'fluorine',
  'chlorine',
  'bromine',
  'iodine',
  'astatine',
};
// constantSet.add('helium'); // This line will cause an error.
```

## Maps

一般来说，映射是一个将键和值关联起来的对象。键和值都可以是任何类型的对象。每个*键*只能出现一次，但你可以多次使用同一个*值*。Dart 对映射的支持由映射字面量和 `Map` 类型提供。

以下是使用映射字面量创建的几个简单的 Dart 映射：

```dart
var gifts = {
  // Key:    Value
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings'
};

var nobleGases = {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};
```

> note
> Dart 推断 `gifts` 的类型为 `Map<String, String>`，而 `nobleGases` 的类型为 `Map<int, String>`。如果你尝试向任意一个映射添加错误类型的值，分析器或运行时会报错。欲了解更多信息，请阅读类型推断。

你可以使用 Map 构造函数创建相同的对象：

```dart
var gifts = Map<String, String>();
gifts['first'] = 'partridge';
gifts['second'] = 'turtledoves';
gifts['fifth'] = 'golden rings';

var nobleGases = Map<int, String>();
nobleGases[2] = 'helium';
nobleGases[10] = 'neon';
nobleGases[18] = 'argon';
```

> note
> 如果你来自 C# 或 Java 等语言，你可能会期望看到 `new Map()` 而不是仅仅 `Map()`。在 Dart 中，`new` 关键字是可选的。详情请参阅 使用构造函数

使用下标赋值运算符 (`[]=`) 向现有映射添加新的键值对：

```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds'; // Add a key-value pair
```

使用下标运算符 (`[]`) 从映射中检索值：

```dart
var gifts = {'first': 'partridge'};
assert(gifts['first'] == 'partridge');
```

如果你查找一个不在映射中的键，会返回 `null`：

```dart
var gifts = {'first': 'partridge'};
assert(gifts['fifth'] == null);
```

使用 `.length` 获取映射中键值对的数量：

```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```

要创建一个编译时常量的映射，在映射字面量前添加 `const`：

```dart
final constantMap = const {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};

// constantMap[2] = 'Helium'; // This line will cause an error.
```

## Operators

### Spread operators

Dart 支持在列表、映射和集合字面量中使用 **展开运算符** (`...`) 和 **空安全展开运算符** (`...?`)。
展开运算符提供了一种简洁的方法将多个值插入集合中。

例如，你可以使用展开运算符 (`...`) 将一个列表中的所有值插入到另一个列表中：

```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```

如果展开运算符右侧的表达式可能为 null，你可以使用空安全展开运算符 (`...?`) 来避免异常：

```dart
var list2 = [0, ...?list];
assert(list2.length == 1);
```

### Control-flow operators

Dart 提供了 **集合 if** 和 **集合 for** 用于列表、映射和集合字面量中。你可以使用这些运算符通过条件语句 (`if`) 和循环 (`for`) 来构建集合。

下面是一个使用 **集合 if** 创建包含三或四个项目的列表的示例：

```dart
var nav = ['Home', 'Furniture', 'Plants', if (promoActive) 'Outlet'];
```

Dart 还支持在集合字面量中使用 if-case：

```dart
var nav = ['Home', 'Furniture', 'Plants', if (login case 'Manager') 'Inventory'];
```

下面是一个使用 **集合 for** 在将列表项添加到另一个列表之前对其进行操作的示例：

```dart
var listOfInts = [1, 2, 3];
var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
assert(listOfStrings[1] == '#1');
```
