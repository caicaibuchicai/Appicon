//
//  ViewController.m
//  ExchengeAPPIcon
//
//  Created by TWTD on 2018/3/30.
//  Copyright © 2018年 TWTD. All rights reserved.
//

#import "ViewController.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)Exchenge:(id)sender {
    [self chengeAppicon:@"MayOneIcon"];
    
    
    
}
- (IBAction)defult:(id)sender {
    [self chengeAppicon:@"DefaultIcon"];
}

/*  直接调用此方法，传入数据为iconName,也就是后台给你要换的图标
 默认传的是@"DefaultIcon"
 */
- (void)chengeAppicon:(NSString*)iconNameNew{
    if (iconNameNew.length == 0) {
        return;
    }
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"you canExchange");
    }else{
        NSLog(@"you can not Exchange");
        return;
    }
    
    NSString * iconname = [[UIApplication sharedApplication]alternateIconName];
    if ((!iconname&&[iconNameNew isEqualToString:@"DefaultIcon"]) || [iconname isEqualToString:iconNameNew]) {
        return;
    }
    [self exchangealterMethod];
    if ( [iconNameNew isEqualToString:@"DefaultIcon"]) {
        
        [[UIApplication sharedApplication]setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"error");
            }else
                NSLog(@"icon name:%@",iconname);
            
        }];
    }else{
        [[UIApplication sharedApplication]setAlternateIconName:iconNameNew completionHandler:^(NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"error");
            }else
                NSLog(@"icon name:%@",iconname);
            
        }];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self exchangealterMethod];
    });
}

- (void)dy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            
            return;
        } else {
            [self dy_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self dy_presentViewController:viewControllerToPresent animated:flag completion:completion];
}
- (void)exchangealterMethod{
    Method presentM = class_getInstanceMethod(UIViewController.class, @selector(presentViewController:animated:completion:));
    Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(dy_presentViewController:animated:completion:));
    
    method_exchangeImplementations(presentM, presentSwizzlingM);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
