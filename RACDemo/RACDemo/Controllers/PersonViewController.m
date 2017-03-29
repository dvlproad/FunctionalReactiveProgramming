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

@end


@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"测试ReactiveCocoa", nil);
    
    [self listenPersonNameKVO];
    
    [self listenNameTextFieldKVO];
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
- (void)listenNameTextFieldKVO {
    @weakify(self);
    [[self.nameTextField rac_textSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"%@",x);
         self.personModel.name = x;
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
