#import <UIKit/UIKit.h>

@interface HeartSettingView : UIView
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, assign) CGFloat heartScale;
@property (nonatomic, assign) BOOL openBreath;
@property (nonatomic, copy) void(^changeBlock)(UIColor *,CGFloat,BOOL);
@end

@implementation HeartSettingView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.9];
        self.layer.cornerRadius = 16;
        self.layer.masksToBounds = YES;
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20,20,200,30)];
    titleLab.text = @"像素爱心设置";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:titleLab];

    NSArray *colorArr = @[[UIColor redColor],[UIColor pinkColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor purpleColor]];
    for(int i=0;i<colorArr.count;i++){
        UIButton *colorBtn = [[UIButton alloc]initWithFrame:CGRectMake(20+i*35,70,30,30)];
        colorBtn.backgroundColor = colorArr[i];
        colorBtn.layer.cornerRadius = 15;
        colorBtn.tag = i;
        [colorBtn addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:colorBtn];
    }

    UILabel *scaleLab = [[UILabel alloc]initWithFrame:CGRectMake(20,120,80,25)];
    scaleLab.text = @"爱心大小";
    scaleLab.textColor = [UIColor whiteColor];
    [self addSubview:scaleLab];

    UISlider *scaleSlider = [[UISlider alloc]initWithFrame:CGRectMake(100,120,140,25)];
    scaleSlider.minimumValue = 0.5;
    scaleSlider.maximumValue = 2.0;
    scaleSlider.value = 1.0;
    [scaleSlider addTarget:self action:@selector(scaleChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:scaleSlider];

    UILabel *breathLab = [[UILabel alloc]initWithFrame:CGRectMake(20,160,80,25)];
    breathLab.text = @"呼吸效果";
    breathLab.textColor = [UIColor whiteColor];
    [self addSubview:breathLab];

    UISwitch *breathSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(100,158,60,30)];
    [breathSwitch addTarget:self action:@selector(breathSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:breathSwitch];

    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(80,200,80,35)];
    closeBtn.backgroundColor = [UIColor systemBlueColor];
    [closeBtn setTitle:@"关闭设置" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius = 8;
    [closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

- (void)chooseColor:(UIButton *)btn{
    self.selectColor = btn.backgroundColor;
    if(self.changeBlock)self.changeBlock(self.selectColor,self.heartScale,self.openBreath);
}

- (void)scaleChange:(UISlider *)slider{
    self.heartScale = slider.value;
    if(self.changeBlock)self.changeBlock(self.selectColor,self.heartScale,self.openBreath);
}

- (void)breathSwitchChange:(UISwitch *)sw{
    self.openBreath = sw.on;
    if(self.changeBlock)self.changeBlock(self.selectColor,self.heartScale,self.openBreath);
}

- (void)closeSelf{
    [self removeFromSuperview];
}
@end
