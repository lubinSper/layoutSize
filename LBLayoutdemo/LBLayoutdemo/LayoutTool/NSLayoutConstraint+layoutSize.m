//
//  NSLayoutConstraint+layoutSize.m
//  testFont
//
//  Created by Apple on 16/12/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSLayoutConstraint+layoutSize.h"
#import <objc/runtime.h>
#define ScrenScaleHeight [UIScreen mainScreen].bounds.size.height/667.0
#define ScrenScaleWidth [UIScreen mainScreen].bounds.size.width/375.0
@implementation NSLayoutConstraint (layoutSize)
+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}
- (id)myInitWithCoder:(NSCoder*)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat scale = ScrenScaleHeight;
        switch (self.firstAttribute) {
            case NSLayoutAttributeLeftMargin:
            case NSLayoutAttributeRightMargin:
                case NSLayoutAttributeTrailing:
                case NSLayoutAttributeLeading:
                scale = ScrenScaleWidth;
                break;
            default:
                break;
        }
        
        self.constant = self.constant * scale;
        if (self.identifier != nil) {
            NSLog(@"带有标记的约束identify-%@--%@",self.identifier,self);
        }
    }
    return self;
}
-(id)myinit{
//    [self ];
    if (self) {
        CGFloat scale = ScrenScaleHeight;
        switch (self.firstAttribute) {
            case NSLayoutAttributeLeftMargin:
                case NSLayoutAttributeRightMargin:
                case NSLayoutAttributeTrailing:
                case NSLayoutAttributeLeading:
                scale = ScrenScaleWidth;
                break;
                break;
                
            default:
                break;
        }
        self.constant = self.constant*scale;
        if (self.identifier != nil) {
            NSLog(@"带有标记的约束indextify -%@--%@",self.identifier,self);
        }
    }
    return self;
}
@end
