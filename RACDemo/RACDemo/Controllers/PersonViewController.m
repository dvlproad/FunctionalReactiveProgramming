//
//  PersonViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonModel.h"

//@import ReactiveCocoa;
@import ReactiveObjC;

@interface PersonViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) PersonModel *personModel;
@property (nonatomic) RACDelegateProxy *proxy;


@property (nonatomic) RACDisposable *nameTextFieldDisposable;
@property (nonatomic, weak) IBOutlet UISwitch *nameTextFieldFilterSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *nameTextFieldMapSwitch;

@end


@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"测试ReactiveCocoa", nil);
    
    [self listenPersonNameKVO];
    
    [self listenNameTextFieldKVO:nil];
    [self listenTextFileCombinationKVO];
    
    [self listentEventKVO];
    [self listenDelegateKVO];
    [self listenNotificationKVO];
    
    
}

- (PersonModel *)personModel {
    if (!_personModel) {
        _personModel = [[PersonModel alloc] init];
    }
    return _personModel;
}

- (IBAction)changePersonName:(id)sender {
    self.personModel.name = [NSString stringWithFormat:@"name:%d", arc4random_uniform(100)];
}

/**
 * 1、测试RACObserve函数：监听到某属性变化的时候，执行对应操作（这里为监听到personModel的name值改变时，执行改变nameLabel上的值
 */
#pragma mark - 监听属性值的改变（如model的某个属性值改变了）
- (void)listenPersonNameKVO {
    @weakify(self)
    [RACObserve(self.personModel, name)
     subscribeNext:^(id x) {
         @strongify(self)
         self.nameLabel.text = x;
     }];
}

#pragma mark - 监听文本框的内容，文本框输入事件监听（如textField的内容变化了）
/** 2、测试rac_textSignal函数：监听到所监听的文本框的内容变化的时候，执行对应操作 */
- (IBAction)listenNameTextFieldKVO:(id)sender {
    @weakify(self);
    
    [self.nameTextFieldDisposable dispose]; //取消订阅
    
    RACSignal *nameTextFieldSignal = [self.nameTextField rac_textSignal];//可以直接写成self.nameTextField.rac_textSignal
    if (self.nameTextFieldFilterSwitch.isOn == NO && self.nameTextFieldMapSwitch.isOn == NO) {
        self.nameTextFieldDisposable = [nameTextFieldSignal subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"不经任何操作的监听：%@",x);
            self.personModel.name = x;
        }];
    } else if (self.nameTextFieldFilterSwitch.isOn && self.nameTextFieldMapSwitch.isOn) {
        //映射和过滤
        nameTextFieldSignal = [[nameTextFieldSignal map:^id(NSString *value) {
            return @(value.length); //这里会把value的值从NSString映射成NSNumber
        }] filter:^BOOL(id  _Nullable value) {
            NSInteger length = [(NSNumber *)value integerValue];
            return length > 5; //长度大于5才执行下方的打印方法
        }];
        
        self.nameTextFieldDisposable = [nameTextFieldSignal subscribeNext:^(id x) {
            NSLog(@"映射和过滤后%@", x);
        }];
    } else if (self.nameTextFieldFilterSwitch.isOn) {
        //输入框过滤
        nameTextFieldSignal = [nameTextFieldSignal filter:^BOOL(id value) {
            NSInteger length = [(NSString *)value length];
            return length > 5; //长度大于5才执行下方的打印方法
        }];
        
        self.nameTextFieldDisposable = [nameTextFieldSignal subscribeNext:^(id x) {
            NSLog(@"过滤后%@", x);
        }];
    }
}


//RAC的使用
- (void)userRACSetValue {
    //当输入长度超过5时，使用RAC()使背景颜色变化
    RAC(self.view, backgroundColor) = [_nameTextField.rac_textSignal map:^id(NSString * value) {
        return value.length > 5 ? [UIColor yellowColor] : [UIColor greenColor];
    }];
}


#pragma mark - 监听文本信号组合
/** 3、验证combineLatest函数：同时检测nameTextField和passwordTextField的文本内容变化，如果有一个变化，则执行对应操作 */
- (void)listenTextFileCombinationKVO {
    id signals = @[[self.nameTextField rac_textSignal], [self.passwordTextField rac_textSignal]];
    
    @weakify(self);
    [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSString *name = [x first];
        NSString *password = [x second];
        
        if (name.length > 0 && password.length > 0) {
            self.loginButton.enabled = YES;
            self.personModel.name = name;
            self.personModel.password = password;
            
        } else  {
            self.loginButton.enabled = NO;
        }
    }];
}


#pragma mark - 监听Event（如按钮的UIControlEventTouchUpInside）
/** 3、验证rac_signalForControlEvents函数：监听到某个Event时，执行对应操作（这里为监听到loginButton点击时，执行打印person的值 */
- (void)listentEventKVO {
    @weakify(self);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"person.name:  %@    person.password:  %@",self.personModel.name, self.personModel.password);
     }];
}

#pragma mark - 监听delegate代理方法(如监听textField的delegate代理方法中的textFieldShouldReturn:)
/** 4、验证rac_signalForSelector函数：监听对应代理方法响应时，执行对应操作（如当触发nameTextField的textFieldShouldReturn:时，使光标移动到passwordTextField处 */
- (void)listenDelegateKVO {
    self.proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];//定义代理
    
    //代理去注册文本框的监听方法
    @weakify(self)
    [[self.proxy rac_signalForSelector:@selector(textFieldShouldReturn:)]
     subscribeNext:^(id x) {
         @strongify(self)
         if (self.nameTextField.hasText) {
             [self.passwordTextField becomeFirstResponder];
         }
     }];
    self.nameTextField.delegate = (id<UITextFieldDelegate>)self.proxy;
}


#pragma mark - 监听Notification通知（如键盘的UIKeyboardWillChangeFrameNotification通知）
/** 5、验证rac_addObserverForName函数：监听到某个通知的时候，执行对应动作 */
- (void)listenNotificationKVO {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]
     subscribeNext:^(id x) {
         NSLog(@"notificationDemo : %@", x);
     }];
}


//uppercaseString use map
- (void)uppercaseString {
    
    //    RACSequence *sequence = [@[@"you", @"are", @"beautiful"] rac_sequence];
    //
    //    RACSignal *signal =  sequence.signal;
    //
    //    RACSignal *capitalizedSignal = [signal map:^id(NSString * value) {
    //                               return [value capitalizedString];
    //                            }];
    //
    //    [signal subscribeNext:^(NSString * x) {
    //        NSLog(@"signal --- %@", x);
    //    }];
    //
    //    [NSThread sleepForTimeInterval:1.0f];
    //
    //    [capitalizedSignal subscribeNext:^(NSString * x) {
    //        NSLog(@"capitalizedSignal --- %@", x);
    //    }];
    
    
    [[[@[@"you", @"are", @"beautiful"] rac_sequence].signal
      map:^id(NSString * value) {
          return [value capitalizedString];
      }] subscribeNext:^(id x) {
          NSLog(@"capitalizedSignal --- %@", x);
      }];
}



//信号开关Switch
- (void)signalSwitch {
    //创建3个自定义信号
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    //获取开关信号
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    //对通过开关的信号量进行操作
    [[switchSignal  map:^id(NSString * value) {
        return [@"https//www." stringByAppendingFormat:@"%@", value];
    }] subscribeNext:^(NSString * x) {
        NSLog(@"%@", x);
    }];
    
    
    //通过开关打开baidu
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
    //通过开关打开google
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu.com/"];
    [google sendNext:@"google.com/"];
}


//组合信号
- (void)combiningLatest{
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    
    [[RACSignal
      combineLatest:@[letters, numbers]
      reduce:^(NSString *letter, NSString *number){
          return [letter stringByAppendingString:number];
      }]
     subscribeNext:^(NSString * x) {
         NSLog(@"%@", x);
     }];
    
    //B1 C1 C2
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    [numbers sendNext:@"1"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"2"];
}


//合并信号
- (void)merge {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSubject *chinese = [RACSubject subject];
    
    [[RACSignal
      merge:@[letters, numbers, chinese]]
     subscribeNext:^(id x) {
         NSLog(@"merge:%@", x);
     }];
    
    [letters sendNext:@"AAA"];
    [numbers sendNext:@"666"];
    [chinese sendNext:@"你好！"];
}

- (void)doNextThen{
    //doNext, then
    RACSignal *lettersDoNext = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    [[[lettersDoNext
       doNext:^(NSString *letter) {
           NSLog(@"doNext-then:%@", letter);
       }]
      then:^{
          return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
      }]
     subscribeNext:^(id x) {
         NSLog(@"doNextThenSub:%@", x);
     }];
    
}

- (void)flattenMap {
    //flattenMap
    RACSequence *numbersFlattenMap = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    /* //有误待修改
    [[numbersFlattenMap
      flattenMap:^RACStream *(NSString * value) {
          if (value.intValue % 2 == 0) {
              return [RACSequence empty];
          } else {
              NSString *newNum = [value stringByAppendingString:@"_"];
              return [RACSequence return:newNum];
          }
      }].signal
     subscribeNext:^(id x) {
         NSLog(@"flattenMap:%@", x);
     }];
    */
}

- (void) flatten {
    //Flattening:合并两个RACSignal, 多个Subject共同持有一个Signal
    RACSubject *letterSubject = [RACSubject subject];
    RACSubject *numberSubject = [RACSubject subject];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:letterSubject];
        [subscriber sendNext:numberSubject];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *flatternSignal = [signal flatten];
    [flatternSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //发信号
    [numberSubject sendNext:@(1111)];
    [numberSubject sendNext:@(1111)];
    [letterSubject sendNext:@"AAAA"];
    [numberSubject sendNext:@(1111)];
}


- (void)subscribeNext {
    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    // Outputs: A B C D E F G H I
    [letters subscribeNext:^(NSString *x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    
}

- (void)subscribeCompleted {
    //Subscription
    __block unsigned subscriptions = 0;
    
    RACSignal *loggingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        subscriptions ++;
        [subscriber sendCompleted];
        return nil;
    }];
    
    [loggingSignal subscribeCompleted:^{
        NSLog(@"Subscription1: %d", subscriptions);
    }];
    
    [loggingSignal subscribeCompleted:^{
        NSLog(@"Subscription2: %d", subscriptions);
    }];
    
    
}

- (void)sequence {
    //Map：映射
    RACSequence *letter = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    
    // Contains: AA BB CC DD EE FF GG HH II
    RACSequence *mapped = [letter map:^(NSString *value) {
        return [value stringByAppendingString:value];
    }];
    [mapped.signal subscribeNext:^(id x) {
        //NSLog(@"Map: %@", x);
    }];
    
    
    //Filter：过滤器
    RACSequence *numberFilter = [@"1 2 3 4 5 6 7 8" componentsSeparatedByString:@" "].rac_sequence;
    //Filter: 2 4 6 8
    [[numberFilter.signal
      filter:^BOOL(NSString * value) {
          return (value.integerValue) % 2 == 0;
      }]
     subscribeNext:^(NSString * x) {
         //NSLog(@"filter: %@", x);
     }];
    
    
    
    //Combining streams:连接两个RACSequence
    //Combining streams: A B C D E F G H I 1 2 3 4 5 6 7 8
    RACSequence *concat = [letter concat:numberFilter];
    [concat.signal subscribeNext:^(NSString * x) {
        // NSLog(@"concat: %@", x);
    }];
    
    
    //Flattening:合并两个RACSequence
    //A B C D E F G H I 1 2 3 4 5 6 7 8
    RACSequence * flattened = @[letter, numberFilter].rac_sequence.flatten;
    [flattened.signal subscribeNext:^(NSString * x) {
        NSLog(@"flattened: %@", x);
    }];
    
}

- (void)dealloc {
    NSLog(@"如果我出现了，说明没有循环引用，否则请检查 @weakify(self) @strongify(self) 组合 %s",__FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
