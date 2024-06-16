# Mixin

Mixins 是一种定义可在多个类层次结构中重用代码的方法。
它们旨在大规模提供成员实现。

要使用 mixin，使用 `with` 关键字，后跟一个或多个 mixin 名称。以下示例显示了使用（或是 mixins 的子类）的两个类：

```dart
class Musician extends Performer with Musical {
  // ···
}

class Maestro extends Person with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```

要定义一个 mixin，使用 `mixin` 声明。
在极少数情况下需要同时定义 mixin 和类时，可以使用 `mixin class` 声明。

Mixins 和 mixin 类不能有 `extends` 子句，并且不能声明任何生成型构造函数。

For example:

```dart
mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

## 指定 mixin 可以调用的自身成员

有时候，一个 mixin 依赖于调用某个方法或访问字段，但不能自己定义这些成员（因为 mixin 不能使用构造函数参数来实例化它们自己的字段）。

以下部分介绍了确保 mixin 的任何子类定义 mixin 行为所依赖的任何成员的不同策略。

### 在 mixin 中定义抽象成员

在 mixin 中声明一个抽象方法会强制任何使用该 mixin 的类型定义其行为所依赖的抽象方法。

```dart
mixin Musician {
  void playInstrument(String instrumentName); // Abstract method.

  void playPiano() {
    playInstrument('Piano');
  }
  void playFlute() {
    playInstrument('Flute');
  }
}

class Virtuoso with Musician { 
  void playInstrument(String instrumentName) { // Subclass must define.
    print('Plays the $instrumentName beautifully');
  }  
} 
```

#### 访问 mixin 子类中的状态

声明抽象成员还允许你通过调用在 mixin 中定义为抽象的 getter 来访问 mixin 子类中的状态：

```dart
/// Can be applied to any type with a [name] property and provides an
/// implementation of [hashCode] and operator `==` in terms of it.
mixin NameIdentity {
  String get name;

  int get hashCode => name.hashCode;
  bool operator ==(other) => other is NameIdentity && name == other.name;
}

class Person with NameIdentity {
  final String name;

  Person(this.name);
}
```

### 实现一个接口

类似于声明 mixin 为抽象的，在 mixin 上添加一个 `implements` 子句但实际上不实现接口，也可以确保定义 mixin 所需的任何成员依赖。

```dart
abstract interface class Tuner {
  void tuneInstrument();
}

mixin Guitarist implements Tuner {
  void playSong() {
    tuneInstrument();

    print('Strums guitar majestically.');
  }
}

class PunkRocker with Guitarist {
  void tuneInstrument() {
    print("Don't bother, being out of tune is punk rock.");
  }
}
```

### 使用 `on` 子句声明一个超类

`on` 子句用于定义 `super` 调用所解析的类型。因此，只有在需要在 mixin 中进行 `super` 调用时才应使用它。

`on` 子句强制任何使用 mixin 的类也必须是 `on` 子句中类型的子类。如果 mixin 依赖于超类中的成员，这可以确保在使用 mixin 的地方这些成员是可用的：

```dart
class Musician {
  musicianMethod() {
    print('Playing music!');
  }
}

mixin MusicalPerformer on Musician {
  perfomerMethod() {
    print('Performing music!');
    super.musicianMethod();
  }
}

class SingerDancer extends Musician with MusicalPerformer { }

main() {
  SingerDancer().perfomerMethod();
}
```

在这个例子中，只有扩展或实现 `Musician` 类的类才能使用 mixin `MusicalPerformer`。由于 `SingerDancer` 扩展了 `Musician`，`SingerDancer` 可以混入 `MusicalPerformer`。

## `class`, `mixin`, or `mixin class`?

> version-note
> `mixin class` 声明需要至少 3.0 版本的语言。

`mixin` 声明定义了一个 mixin。`class` 声明定义了一个类。`mixin class` 声明定义了一个类，该类可以作为普通类和 mixin 使用，并且具有相同的名称和相同的类型。

```dart
mixin class Musician {
  // ...
}

class Novice with Musician { // Use Musician as a mixin
  // ...
}

class Novice extends Musician { // Use Musician as a class
  // ...
}
```

任何适用于类或 mixin 的限制也适用于 mixin 类：

- Mixin 不能有 `extends` 或 `with` 子句，因此 `mixin class` 也不能有。
- 类不能有 `on` 子句，因此 `mixin class` 也不能有。
