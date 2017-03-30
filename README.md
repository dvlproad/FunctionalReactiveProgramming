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

### ReactiveCocoa常见类/协议
参考自：[最快让你上手ReactiveCocoa之基础篇](http://www.jianshu.com/p/87ef6720a096)
###### 1、RACSiganl信号类
RACSiganl信号类，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。

如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。

###### 2、RACSubscriber订阅者协议
RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。
###### 3、RACDisposable
RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。

使用场景:不想监听某个信号时，可以通过它主动取消订阅信号。
###### 4、RACSubject
RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。

使用场景:通常用来代替代理，有了它，就不必要定义代理了。

###### 5、RACTuple 
RACTuple:元组类,类似NSArray,用来包装值.

###### 6、RACSequence 
RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。

###### 7、RACCommand 
RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。

使用场景:监听按钮点击，网络请求

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
1、创建信号(此时信号为冷信号）

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) { 
    	NSLog(@"信号被订阅");
    }
2、订阅信号(订阅后信后才变成热信号)
    
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
		NSLog(@"信号发送的内容：%@",x);
	}]; 
3、取消订阅 

    [disposable dispose]; 
    
4、发送数据

    [subscriber sendNext:@1];
    
    
#### 参考：
1、[使用ReactiveCocoa实现iOS平台响应式编程](http://blog.csdn.net/xdrt81y/article/details/30624469)
2、[MVVMWithReactiveCocoa](http://www.cocoachina.com/ios/20151116/14210.html) 