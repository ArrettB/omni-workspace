//
//  ViewController.h
//  SignatureCatpure
//
//  Created by Chad Brandt on 9/20/12.
//  Copyright (c) 2012 KettleRiver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T1Autograph.h"

@interface MainViewController : UIViewController<T1AutographDelegate, UIWebViewDelegate>

@property (strong,nonatomic) T1Autograph *autograph;
@property (strong,nonatomic) T1Autograph *autographModal;
@property (strong, nonatomic) UIImageView *outputImage;

@end
