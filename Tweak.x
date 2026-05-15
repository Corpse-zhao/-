#import <UIKit/UIKit.h>
#import "SettingView.m"

static UIView *heartView;
static UIColor *heartColor;
static CGFloat heartSizeScale = 1.0;
static BOOL isOpenBreath = NO;
static CGPoint startPoint;
static BOOL isDraging = NO;

@interface UIWindow (Private)
@end

%hook UIWindow
- (void)didAddSubview:(id)subview{
    %orig;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createPixelHeart];
    });
}
%end

- (void)createPixelHeart{
    if(heartView)return;
    heartColor = [UIColor redColor];
    
    heartView = [[UIView alloc]initWithFrame:CGRectMake(80,200,60,60)];
    heartView.backgroundColor = [UIColor clearColor];
    heartView.userInteractionEnabled = YES;
    heartView.layer.zPosition = 999999;
    
    [self drawPixelHeart];
    [self addGesture];
    [[[UIApplication sharedApplication]keyWindow]addSubview:heartView];
}

- (void)drawPixelHeart{
    [heartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *pixelMap = @[
        @"01100110",
        @"11111111",
        @"11111111",
        @"11111111",
        @"01111110",
        @"00111100",
        @"00011000",
        @"00000000"
    ];
    CGFloat unit = 7.5 * heartSizeScale;
    for(int y=0;y<pixelMap.count;y++){
        NSString *row = pixelMap[y];
        for(int x=0;x<row.length;x++){
            char c = [row characterAtIndex:x];
            if(c == '1'){
                UIView *pixel = [[UIView alloc]init];
                pixel.backgroundColor = heartColor;
                pixel.frame = CGRectMake(x*unit,y*unit,unit,unit);
                [heartView addSubview:pixel];
            }
        }
    }
    if(isOpenBreath)[self startBreathAnim];
}

- (void)addGesture{
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMove:)];
    [heartView addGestureRecognizer:longGes];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSetting)];
    doubleTap.numberOfTapsRequired = 2;
    [heartView addGestureRecognizer:doubleTap];
}

- (void)longPressMove:(UILongPressGestureRecognizer *)ges{
    CGPoint now = [ges locationInView:[UIApplication sharedApplication].keyWindow];
    if(ges.state == UIGestureRecognizerStateBegan){
        startPoint = now;
        isDraging = YES;
    }else if(ges.state == UIGestureRecognizerStateChanged && isDraging){
        CGFloat dx = now.x - startPoint.x;
        CGFloat dy = now.y - startPoint.y;
        heartView.center = CGPointMake(heartView.center.x+dx,heartView.center.y+dy);
        startPoint = now;
    }else if(ges.state == UIGestureRecognizerStateEnded){
        isDraging = NO;
    }
}

- (void)showSetting{
    HeartSettingView *setView = [[HeartSettingView alloc]initWithFrame:CGRectMake(40,220,280,250)];
    setView.changeBlock = ^(UIColor *color,CGFloat scale,BOOL breath){
        heartColor = color;
        heartSizeScale = scale;
        isOpenBreath = breath;
        [self drawPixelHeart];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:setView];
}

- (void)startBreathAnim{
    [heartView.layer removeAllAnimations];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.fromValue = @(0.9);
    anim.toValue = @(1.1);
    anim.duration = 1.2;
    anim.repeatCount = HUGE_VALF;
    anim.autoreverses = YES;
    [heartView.layer addAnimation:anim forKey:@"breath"];
}
