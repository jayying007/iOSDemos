//
//  CustomRingViewController.m
//  healthkit
//
//  Created by janezhuang on 2021/11/13.
//

#import "CustomRingViewController.h"
#import "CircleGraphView.h"

@interface CustomRingViewController ()
@property (nonatomic) CircleGraphView *circleView1;
@property (nonatomic) CircleGraphView *circleView2;
@property (nonatomic) CircleGraphView *circleView3;
@property (nonatomic) UISlider *slider1;
@property (nonatomic) UISlider *slider2;
@property (nonatomic) UISlider *slider3;
@end

@implementation CustomRingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;

    [self.view addSubview:self.circleView1];
    [self.view addSubview:self.slider1];
    [self.circleView1 setNeedsDisplay];

    [self.view addSubview:self.circleView2];
    [self.view addSubview:self.slider2];
    [self.circleView2 setNeedsDisplay];

    [self.view addSubview:self.circleView3];
    [self.view addSubview:self.slider3];
    [self.circleView3 setNeedsDisplay];
}

- (CircleGraphView *)circleView1 {
    if (_circleView1 == nil) {
        _circleView1 = [[CircleGraphView alloc] initWithFrame:CGRectMake(50, 100, 250, 250)];
        _circleView1.arcColor = UIColor.redColor;
        _circleView1.endArc = 0.0;
    }
    return _circleView1;
}

- (CircleGraphView *)circleView2 {
    if (_circleView2 == nil) {
        _circleView2 = [[CircleGraphView alloc] initWithFrame:CGRectMake(90, 140, 170, 170)];
        _circleView2.arcColor = UIColor.greenColor;
        _circleView2.endArc = 0.0;
    }
    return _circleView2;
}

- (CircleGraphView *)circleView3 {
    if (_circleView3 == nil) {
        _circleView3 = [[CircleGraphView alloc] initWithFrame:CGRectMake(130, 180, 90, 90)];
        _circleView3.arcColor = UIColor.blueColor;
        _circleView3.endArc = 0.0;
    }
    return _circleView3;
}

- (UISlider *)slider1 {
    if (_slider1 == nil) {
        _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 50)];
        _slider1.backgroundColor = UIColor.redColor;
        [_slider1 addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider1;
}

- (UISlider *)slider2 {
    if (_slider2 == nil) {
        _slider2 = [[UISlider alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 50)];
        _slider2.backgroundColor = UIColor.greenColor;
        [_slider2 addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider2;
}

- (UISlider *)slider3 {
    if (_slider3 == nil) {
        _slider3 = [[UISlider alloc] initWithFrame:CGRectMake(0, 500, self.view.frame.size.width, 50)];
        _slider3.backgroundColor = UIColor.blueColor;
        [_slider3 addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider3;
}

- (void)sliderValurChanged:(UISlider *)slider forEvent:(UIEvent *)event {
    if (slider == self.slider1) {
        self.circleView1.endArc = slider.value;
        [self.circleView1 setNeedsDisplay];
    }
    if (slider == self.slider2) {
        self.circleView2.endArc = slider.value;
        [self.circleView2 setNeedsDisplay];
    }
    if (slider == self.slider3) {
        self.circleView3.endArc = slider.value;
        [self.circleView3 setNeedsDisplay];
    }
}
@end
