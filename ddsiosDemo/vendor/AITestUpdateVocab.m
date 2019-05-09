//
//  AITestUpdateVocab.m
//  ddsiosDemo
//
//  Created by aispeech009 on 26/10/2017.
//  Copyright © 2017 speech. All rights reserved.
//

#import "AITestUpdateVocab.h"
#import "LYYTextField.h"
#import "DDSManager.h"
#import "AITestDUICtrl.h"

@interface AITestUpdateVocab ()

@property (weak, nonatomic) IBOutlet LYYTextField *text1;
@property (weak, nonatomic) IBOutlet LYYTextField *text2;
@property (weak, nonatomic) IBOutlet LYYTextField *text3;
@property (weak, nonatomic) IBOutlet LYYTextField *text4;
@property (weak, nonatomic) IBOutlet LYYTextField *text5;
@property (weak, nonatomic) IBOutlet UIButton *btnTriggerIntentOk;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;

@end

@implementation AITestUpdateVocab

- (void)viewDidLoad {
    [super viewDidLoad];
    _view1.frame = CGRectMake(11, 0, self.view.frame.size.width-41, 1);
    
    _view2.frame = CGRectMake(11, 50, self.view.frame.size.width-41, 1);
    _view3.frame = CGRectMake(11, 98, self.view.frame.size.width-41, 1);
    _view4.frame = CGRectMake(11, 146, self.view.frame.size.width-41, 1);
    _view5.frame = CGRectMake(11, 190, self.view.frame.size.width-41, 1);
    _view6.frame = CGRectMake(11, 240, self.view.frame.size.width-41, 1);
    
    _btnTriggerIntentOk.frame = CGRectMake(21, 276/*370*/, self.view.frame.size.width-41, 50);
    _btnTriggerIntentOk.layer.cornerRadius=5;
    //_btnTriggerIntentOk.adjustsImageWhenHighlighted = YES;
    _btnTriggerIntentOk.backgroundColor = [UIColor whiteColor];
    [_btnTriggerIntentOk.layer setMasksToBounds:YES];
    [_btnTriggerIntentOk.layer setBorderWidth:1.0];
    [_btnTriggerIntentOk.layer setBorderColor:[UIColor grayColor].CGColor];
    _btnTriggerIntentOk.titleLabel.font= [UIFont systemFontOfSize: 20];
    [_btnTriggerIntentOk setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnTriggerIntentOk setTitle:@"点击 更新" forState:UIControlStateNormal];
    
    
    self.text1.placeholder = @"请输入词库名称";
    self.text1.placeholderColor = [UIColor blackColor];
    self.text1.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.text2.placeholder = @"请输入词条1名称";
    self.text2.placeholderColor = [UIColor blackColor];
    self.text2.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.text3.placeholder = @"请输入词条2名称";
    self.text3.placeholderColor = [UIColor blackColor];
    self.text3.clearButtonMode=UITextFieldViewModeWhileEditing;
    
//    self.text4.placeholder = @"请输入词条3名称,可选";
//    self.text4.placeholderColor = [UIColor blackColor];
//    self.text4.clearButtonMode=UITextFieldViewModeWhileEditing;
//    
//    self.text5.placeholder = @"请输入词条4名称,可选";
//    self.text5.placeholderColor = [UIColor blackColor];
//    self.text5.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    [_btnTriggerIntentOk addTarget:self action:@selector(triggerIntentOkRelease) forControlEvents:UIControlEventTouchUpInside];
    [_btnTriggerIntentOk addTarget:self action:@selector(triggerIntentOkPress) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件

-(void)triggerIntentOkRelease{
    DDSManager *manager = [DDSManager shareInstance];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if(![(NSString*)self.text2.text  isEqual: @""]){
        [arr addObject:self.text2.text];
    }
    if(![(NSString*)self.text3.text  isEqual: @""]){
        [arr addObject:self.text3.text];
    }
//    if(self.text4.text != nil){
//        [arr addObject:self.text4.text];
//    }
//    if(self.text5.text != nil){
//        [arr addObject:self.text5.text];
//    }
    
    if (![(NSString*)self.text1.text  isEqual: @""] ) {
        [manager updateVocab:(NSString*)self.text1.text contents:arr addOrDelete:YES];
    }
    _btnTriggerIntentOk.backgroundColor = [UIColor whiteColor];
    [_btnTriggerIntentOk setTitle:@"点击 更新" forState:UIControlStateNormal];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)triggerIntentOkPress{
    
    _btnTriggerIntentOk.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [_btnTriggerIntentOk setTitle:@"松开 结束" forState:UIControlStateNormal];
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
