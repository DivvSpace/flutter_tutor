# Extend a class

使用 `extends` 创建一个子类，并使用 `super` 引用父类：

```dart
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // ···
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // ···
}
```

有关 `extends` 的另一种用法，请参阅泛型页面上的参数化类型讨论。

## Overriding members

子类可以重写实例方法（包括运算符）、getter 和 setter。
您可以使用 `@override` 注解来表明您是有意重写一个成员：

```dart
class Television {
  // ···
  set contrast(int value) {...}
}

class SmartTelevision extends Television {
  @override
  set contrast(num value) {...}
  // ···
}
```

重写方法声明必须在多个方面与它所重写的方法（或方法们）匹配：

* 返回类型必须与被重写方法的返回类型相同，或者是其子类型。
* 参数类型必须与被重写方法的参数类型相同，或者是其超类型。
  在前面的例子中，`SmartTelevision` 的 `contrast` setter 将参数类型从 `int` 改变为一个超类型 `num`。
* 如果被重写方法接受 _n_ 个位置参数，那么重写方法也必须接受 _n_ 个位置参数。
* 泛型方法不能重写非泛型方法，非泛型方法也不能重写泛型方法。

有时您可能希望缩小方法参数或实例变量的类型。
这违反了常规规则，并且类似于向下类型转换，因为它可能在运行时导致类型错误。
尽管如此，如果代码能够保证不会发生类型错误，缩小类型仍然是可能的。
在这种情况下，您可以在参数声明中使用 `covariant` 关键字。
有关详细信息，请参阅 Dart 语言规范。

> warning
> 如果您重写 `==`，您还应该重写 Object 的 `hashCode` getter。
有关重写 `==` 和 `hashCode` 的示例，请查看实现映射键。

## noSuchMethod()

要检测或响应代码尝试使用不存在的方法或实例变量，您可以重写 `noSuchMethod()`：

```dart
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void noSuchMethod(Invocation invocation) {
    print('You tried to use a non-existent member: '
        '${invocation.memberName}');
  }
}
```

除非以下条件之一为真，否则您**不能调用**未实现的方法：

* 接收者具有静态类型 `dynamic`。

* 接收者具有定义未实现方法的静态类型（抽象类型可以），并且接收者的动态类型具有与类 `Object` 中不同的 `noSuchMethod()` 实现。

有关更多信息，请参阅非正式的 noSuchMethod 转发规范。
