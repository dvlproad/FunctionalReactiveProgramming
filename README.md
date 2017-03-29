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

### ReactiveCocoa常见宏

8.1 RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。

    // 只要文本框文字改变，就会修改label的文字
    RAC(self.labelView,text) = _textField.rac_textSignal;
8.2 RACObserve(self, name):监听某个对象的某个属性,返回的是信号。

    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
8.3  @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。

8.4 RACTuplePack：把数据包装成RACTuple（元组类）

    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10,@20);
8.5 RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。

    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@"xmg",@20);

    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"xmg" age = @20
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
    
    
### 其他
