# FunctionalReactiveProgramming
响应式编程

### Cocoapods导入ReactiveCocoa5.0
参考：

1、[Cocoapods导入ReactiveCocoa5.0以上版本注意事项](http://www.tuicool.com/articles/Qju6fme)

2、[ReactiveCocoa 5.0 初窥：可能是最痛的一次升级](http://www.cocoachina.com/ios/20161116/18104.html)

ReactiveCocoa发布了重大的更新，所以如果想使用最新版本的框架，我们需要注意一下问题。

1.如果你只是纯 swift 项目，你继续使用 ReactiveCocoa 。但是 RAC 依赖于 ReactiveSwift ，等于你引入了两个库。这种情况下的podfile的文件如下:

```
use_frameworks!
target 'Target名称' do
	pod 'ReactiveCocoa', '~> 5.0.0'
end
```

2.如果你的项目是纯 OC 项目，你需要使用的是 ReactiveObjC 。这个库里面包含原来 RAC 2 的全部代码。这种情况下的podfile的文件如下:

```
use_frameworks!
target 'Target名称' do
	pod 'ReactiveObjC', '~> 2.1.0'
end
```

3.如果你的项目是 swift 和 OC 混编，你需要同时引用ReactiveCocoa 和 ReactiveObjCBridge 。但是 ReactiveObjCBridge 依赖于 ReactiveObjC ，所以你就等于引入了 4 个库。 其中，ReactiveObjCBridge暂不支持cocoapods导入，需要手动导入！！

这种情况下的podfile的文件如下（注意，ReactiveObjCBridge手动导入就好啦）:

```
use_frameworks!
target 'Target名称' do
	pod 'ReactiveObjC', '~> 2.1.0'
	pod 'ReactiveCocoa', '~> 5.0.0'
end
```

等后期ReactiveObjCBridge支持cocoapods导入后，我会第一时间更新这篇文章，感谢大家~

### 