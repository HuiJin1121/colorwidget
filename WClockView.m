//
//  WClockView.m
//  EmojiStudio
//
//  Created by pc on 9/22/20.
//  Copyright © 2020 alex. All rights reserved.
//

#import "WClockView.h"
#import "WClockView+Style.h"
#import "WClockView+Layout.h"
#import "UIFont+Extension.h"
#import "Utils.h"
#import "SystemInfo.h"

@interface WClockView()

@property (nonatomic, strong) NSTimer* tickTimer;

@end

@implementation WClockView

- (id) initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self setupView];
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupView];
    }
    
    return self;
}

- (void) setupView {
    self.timeUnit = @"";
    self.userInteractionEnabled = NO;
    
//    self.family = familyDigitalSmall;
    self.backgroundColor = [UIColor blackColor];

    // background view
    self.gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:self.gradientLayer atIndex: 0];
    self.gradientLayer.hidden = YES;
    self.imageViewLayer = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageViewLayer.hidden = YES;
    self.imageViewLayer.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview: self.imageViewLayer];

    // analog
    self.watchContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.watchView = [[WatchView alloc]initWithFrame:CGRectZero];
    [self.watchView changeWatchByTag:0];
    [self.watchContentView addSubview: self.watchView];
    [self addSubview: self.watchContentView];

    //digital
    self.timeLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.timeLabel2 = [[UILabel alloc] initWithFrame: CGRectZero];
    [self addSubview: self.timeLabel];
    [self addSubview: self.timeLabel2];

    //calendar
    self.calendarView = [[CalendarView alloc] initWithFrame:CGRectZero];
    [self addSubview: self.calendarView];

    //common
    self.dateLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.monthLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.dayLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.zoneLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.cityLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.weekLabel = [[UILabel alloc] initWithFrame: CGRectZero];

    [self addSubview: self.dateLabel];
    [self addSubview: self.monthLabel];
    [self addSubview: self.dayLabel];
    [self addSubview: self.zoneLabel];
    [self addSubview: self.cityLabel];
    [self addSubview: self.weekLabel];
    
    //count
    self.countNameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.countWeekDayLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.countDateLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.countDayLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.countUnitLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    
    [self addSubview: self.countNameLabel];
    [self addSubview: self.countWeekDayLabel];
    [self addSubview: self.countDateLabel];
    [self addSubview: self.countDayLabel];
    [self addSubview: self.countUnitLabel];
    
    //contact
    self.contactView = [[ContactDisplayView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.contactView];
    
    //battery
    self.batteryView = [[BatteryView alloc] initWithFrame: CGRectZero];
    [self addSubview:self.batteryView];
    
    //activity
    self.activityIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.activityUnit = [[UILabel alloc] initWithFrame: CGRectZero];
    self.activityValue = [[UILabel alloc] initWithFrame: CGRectZero];
    
    [self addSubview: self.activityIcon];
    [self addSubview: self.activityUnit];
    [self addSubview: self.activityValue];
    self.data = [[xClockThemeFamilyModel alloc] init];
    [self fire];
    
    [[SystemInfo shared] fetchAuthorizedActivityForToday:^(bool flag) {
        if (flag) {
            [self tick];
            [self setNeedsLayout];
        }
    }];
}

- (void) fire {
    if (self.tickTimer != nil)
        return;
    
    self.tickTimer = [NSTimer timerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(tick)
                                               userInfo:nil
                                                repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.tickTimer
                              forMode:NSDefaultRunLoopMode];
}

- (void) setData:(xClockThemeFamilyModel *)data {
    _data = data;
    [self tick];
    [self setNeedsLayout];
}

- (void) tick {
    NSDate* date = [NSDate date];
    [self setDateStyle: date];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    self.imageViewLayer.frame = self.bounds;
    [self layout];
    [self tick];
}

- (void) dealloc {
    if (self.tickTimer != nil) {
        [self.tickTimer invalidate];
    }
}

@end
