# 苹果登录Flutter插件

## 简介
  一款集成了iOS苹果登录功能的Flutter插件,仅支持iOS系统

## 集成步骤
#### 1、pubspec.yaml
```Dart
sign_in_apple_flutter:
  git: https://github.com/Guardiany/sign_in_apple_flutter.git
```

#### 2、IOS
确保在 [https://developer.apple.com/account/resources/identifiers/list/bundleId](https://developer.apple.com/account/resources/identifiers/list/bundleId)
的列表中设置你要添加苹果登录的Bundle ID，然后在对应的Capabilities中勾选 Sign In with Apple
Xcode 中 TARGETS的Capabilities 同样要添加 Sign In with Apple

## 使用

#### 1、苹果登录
```Dart
SignInAppleFlutter.signInApple(
  success: (info) {
    print(info);
  },
  error: (error) {
    print(error);
  },
);
```

## 联系方式
* Email: 1204493146@qq.com
