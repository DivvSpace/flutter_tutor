# modifier-reference

## 有效组合

类修饰符的有效组合及其结果能力如下：

| Declaration                 | Construct? | Extend? | Implement? | Mix in? | Exhaustive? |
|-----------------------------|----------------|-------------|----------------|-------------|-----------------|
| `class`                     | **Yes**        | **Yes**     | **Yes**        | No          | No              |
| `base class`                | **Yes**        | **Yes**     | No             | No          | No              |
| `interface class`           | **Yes**        | No          | **Yes**        | No          | No              |
| `final class`               | **Yes**        | No          | No             | No          | No              |
| `sealed class`              | No             | No          | No             | No          | **Yes**         |
| `abstract class`            | No             | **Yes**     | **Yes**        | No          | No              |
| `abstract base class`       | No             | **Yes**     | No             | No          | No              |
| `abstract interface class`  | No             | No          | **Yes**        | No          | No              |
| `abstract final class`      | No             | No          | No             | No          | No              |
| `mixin class`               | **Yes**        | **Yes**     | **Yes**        | **Yes**     | No              |
| `base mixin class`          | **Yes**        | **Yes**     | No             | **Yes**     | No              |
| `abstract mixin class`      | No             | **Yes**     | **Yes**        | **Yes**     | No              |
| `abstract base mixin class` | No             | **Yes**     | No             | **Yes**     | No              |
| `mixin`                     | No             | No          | **Yes**        | **Yes**     | No              |
| `base mixin`                | No             | No          | No             | **Yes**     | No              |

## 无效组合

某些修饰符的组合是不允许的：

| 组合                                        | 原因                                                                                                                                      |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `base`、`interface` 和 `final`              | 都控制相同的两个能力（`extend` 和 `implement`），因此是互斥的。                                                                                 |
| `sealed` 和 `abstract`                      | 两者都不能被构造，所以一起使用是多余的。                                                                                                      |
| `sealed` 与 `base`、`interface` 或 `final`  | `sealed` 类型已经不能从另一个库中混入、扩展或实现，所以与所列修饰符结合是多余的。                                                              |
| `mixin` 和 `abstract`                       | 两者都不能被构造，所以一起使用是多余的。                                                                                                      |
| `mixin` 与 `interface`、`final` 或 `sealed` | `mixin` 或 `mixin class` 声明旨在被混入，而所列修饰符阻止了这种情况。                                                                          |
| `enum` 和任何修饰符                         | `enum` 声明不能被扩展、实现、混入，并且总是可以被实例化，所以没有修饰符适用于 `enum` 声明。                                                   |
| `extension type` 和任何修饰符               | `extension type` 声明不能被扩展或混入，并且只能由其他 `extension type` 声明实现。                                                             |
