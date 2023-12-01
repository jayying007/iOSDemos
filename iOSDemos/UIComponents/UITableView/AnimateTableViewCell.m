//
//  AnimateTableViewCell.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/1.
//

#import "AnimateTableViewCell.h"

@implementation Model

+ (instancetype)ModelWithNormalHeight:(CGFloat)normalHeight expendHeight:(CGFloat)expendHeight expend:(BOOL)expend {
    Model *model = [[Model alloc] init];
    model.normalHeight = normalHeight;
    model.expendHeight = expendHeight;
    model.expend = expend;

    return model;
}

@end

@interface AnimateTableViewCell ()
@property (nonatomic, weak) Model *model;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation AnimateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0
                                                        green:arc4random_uniform(255) / 255.0
                                                         blue:arc4random_uniform(255) / 255.0
                                                        alpha:1];
        [self addSubview:self.lineView];

        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.text = @"Click TableViewCell";
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (void)buttonEvent {
    self.model.expend = !self.model.expend;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.tableView beginUpdates];
                         [self.tableView endUpdates];
                         [self layoutView];
                     }];
}

- (void)loadData:(id)data {
    self.model = data;
    [self layoutView];
}

- (void)layoutView {
    if (self.model.expend) {
        self.lineView.frame = CGRectMake(250, 0, 60, self.model.expendHeight - 10);
        self.infoLabel.frame = CGRectMake(30, 0, 150, 50);
    } else {
        self.lineView.frame = CGRectMake(250, 0, 60, self.model.normalHeight - 10);
        self.infoLabel.frame = CGRectMake(10, 0, 150, 50);
    }
}

@end
