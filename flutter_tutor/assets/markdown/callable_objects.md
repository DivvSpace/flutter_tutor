# 可调用对象

要使 Dart 类的实例可以像函数一样调用，请实现 call() 方法。

call() 方法允许定义它的任何类的实例模拟一个函数。该方法支持与普通函数相同的功能，如参数和返回类型。

在下面的例子中，WannabeFunction 类定义了一个 call() 函数，该函数接受三个字符串并将它们连接在一起，每个字符串之间用空格分隔，并在末尾添加一个感叹号。点击运行以执行代码。

```dart
class WannabeFunction {
  String call(String a, String b, String c) => '$a $b $c!';
}

var wf = WannabeFunction();
var out = wf('Hi', 'there,', 'gang');

void main() => print(out);
```
