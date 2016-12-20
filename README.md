# layoutSize
![喜欢的明星之一
![]](http://upload-images.jianshu.io/upload_images/2017503-b148b95837f78d85.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 本人系公司的里小小开发人员一枚,重新发了设计了UI,app里除了网络请求了一些基本的数据模型意外,几乎都是重新写的.有感觉现在的以前不喜欢做界面,比较喜欢处理逻辑部分,所以一开始写界面的时候还是有些疑问的,现在公司是我一个独立开发,什么业务逻辑都是自己处理的,但是什么都是不专业的,万金油牌.

#言归正传,说说今天的主题吧 -> 关于适配
## 1.  首先一点,能自动布局就自动布局吧,采用算距离和高度方式

为什么建议自动布局,可能这观点有很多人不认同,尤其是三四年从事iOS工作经验的,自动布局是一种趋势吧,你看安卓,H5等等,算距离和高度真的严重out了,新技术还是要跟进的,可以更加专注业务逻辑的部分,而不是下个布局全都是calulate,如果别人接手改UI的时候估计也不想改了,把你的重写一遍,尤其是cell的布局还是先算frame值的,我的天.,另外,有人说计算frame值得cell滑动很流畅啊,对,这是确实,如果是业务要求非常流畅的确实需要,但是大部分都是不重要的,重要的是你能处理好逻辑就行,
## 2. 用xib还是代码?-->两个都要会,但是代码一定要用的溜
面试的时候你要说是用xib,估计十有八九的人会说你技术不咋地,因为大部分的公司代码还是用纯代码写的,团队开发咋得怎么可能让写xib,而且xib很容易改一个东西会报错,其中关于cell的布局在xib有一个坑,需要自己领悟领悟,这点在后面会进行说明,而且用代码的工作量也是不大的,布局靠想象,当锻炼思维吧.建议--> 个人开发的时候若是项目非常赶,拉一点控件还是可以的.基本点,简单的用xib布局快,用代码也快,复杂的用xib做不了,用代码可以做
## 3. 用纯代码布局如图的时候

![图纸.png](http://upload-images.jianshu.io/upload_images/2017503-ae8095c20a6a9142.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
他的时候给出的设计图按照设计师给出的圆形图,咋一样看上去很简单的一个设计图,页面简单,控件才几个,但是真正做的时候却傻眼了,为什么,这是一张需要按照全局比例进行缩放的比例图,不是单靠一张标注好的px图就可以进行适配的,简言之,就是根据屏幕大小设置空间大小,更具屏幕大小设置左右适配的距离,再换言之,就是设置四五套大小和距离.一开始我就是这么样做的,后来抽取出来工具类来计算,这么是最好的办法

# 适配的基本原则,
>距离要按照比例进行适配,字体要根据屏幕的比例进行适配,只有这么样做,才算是比较标准的,同时还要针对4s~5s进行一小部分适配,因为按照比例更加宽.

#思考一个环节,如何抽取一个一个类,改变最少的内容做最的大限度的事情
想法有几种,
* 建立相关的父类,所有需要改变的类都继承于它,这是最好理解的一种方法,只需要建一个UILabel的父类,举例说:framLabel,在这个frameLabel的`iniWithFont`里面进行设置

* 通过运行时分别交换UILable的 `initWithCoder:` ,`initWithFrame:`方法.
> 如下代码


Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
method_exchangeImplementations(imp, myImp);

Method cmp = class_getInstanceMethod([self class], @selector(initWithFrame:));
Method myCmp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
method_exchangeImplementations(cmp, myCmp);        
* 宏定义宽高,__这个是网上看到的__原文在[iOS 控件宽高字体大小适配方法](http://blog.csdn.net/sky_yang1024/article/details/51273032),这也是比较容易实现的方法,作者那里有,这里简单说一下,在pch文件里define两个宏定义
#define autoScaleW(width) [(AppDelegate *)[UIApplication sharedApplication].delegate autoScaleW:width]
#define autoScaleH(height) [(AppDelegate *)[UIApplication sharedApplication].delegate autoScaleH:height]        
然后写控件的时候后设置字体大小
[UIFont systemFontOfSize:autoScaleW(14)]        

# 这是关于距离的适配
距离适配的思想和字体的适配也是类似的,都有着三种适配的方式,通过运行时更改项目的设置方法
#import "NSLayoutConstraint+layoutSize.h"
#import <objc/runtime.h>
#import "NSString+Manager.h"
#define ScrenScaleHeight [UIScreen       mainScreen].bounds.size.height/667.0
#define ScrenScaleWidth [UIScreen mainScreen].bounds.size.width/375.0
@implementation NSLayoutConstraint (layoutSize)
+ (void)load {
Method imp = class_getInstanceMethod([self class],       @selector(initWithCoder:));
Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
method_exchangeImplementations(imp, myImp);
}        
- (id)myInitWithCoder:(NSCoder*)aDecode {
[self myInitWithCoder:aDecode];
if (self) {
//        //代码创建的时候 还不能拿到之后设置的tag 所以无法判断忽略项
//        NSArray *ignoreTags = [UIView getIgnoreTags];
//        for (NSNumber *num in ignoreTags) {
//            if(self.tag == num.integerValue) return self;
//        }
//        if ([UIScreen mainScreen]) {
//            <#statements#>
//        }
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
BMLog(@"带有标记的约束identify-%@--%@",self.identifier,self);
}
}
return self;
}        

![全都是泡沫---邓紫棋](http://upload-images.jianshu.io/upload_images/2017503-37daf500b3c6a11f.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
