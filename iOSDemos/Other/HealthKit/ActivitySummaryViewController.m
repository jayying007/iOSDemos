//
//  ActivitySummaryViewController.m
//  healthkit
//
//  Created by janezhuang on 2021/11/13.
//

#import "ActivitySummaryViewController.h"
#import <HealthKit/HealthKit.h>
#import <HealthKitUI/HealthKitUI.h>

@interface ActivitySummaryViewController ()
@property (nonatomic) HKHealthStore *healthStore;
@end

@implementation ActivitySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    self.healthStore = [[HKHealthStore alloc] init];
    [self authIfNeed:^{
        [self queryActivitySummary];
    }];

    [self mockView];
}

- (void)mockView {
    HKActivityRingView *view = [[HKActivityRingView alloc] initWithFrame:CGRectMake(100, 80, 200, 200)];
    HKActivitySummary *summary = [[HKActivitySummary alloc] init];

    summary.activeEnergyBurned = [HKQuantity quantityWithUnit:[HKUnit smallCalorieUnit] doubleValue:330];
    summary.activeEnergyBurnedGoal = [HKQuantity quantityWithUnit:[HKUnit smallCalorieUnit] doubleValue:400];
    summary.appleExerciseTime = [HKQuantity quantityWithUnit:[HKUnit dayUnit] doubleValue:250];
    summary.appleExerciseTimeGoal = [HKQuantity quantityWithUnit:[HKUnit dayUnit] doubleValue:400];
    summary.appleStandHours = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:1.5];
    summary.appleStandHoursGoal = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:3];
    [view setActivitySummary:summary animated:YES];

    [self.view addSubview:view];
}

- (void)authIfNeed:(void (^)(void))callback {
    HKActivitySummaryType *summaryType = [HKQuantityType activitySummaryType];
    HKAuthorizationStatus summaryAuthStatus = [self.healthStore authorizationStatusForType:summaryType];
    //若用户之前没有授权过（不管是同意或拒绝），则status = NotDetermined
    if (summaryAuthStatus == HKAuthorizationStatusNotDetermined) {
        [self.healthStore requestAuthorizationToShareTypes:nil
                                                 readTypes:[NSSet setWithObject:summaryType]
                                                completion:^(BOOL success, NSError *_Nullable error) {
                                                    if (success) {
                                                        callback();
                                                    }
                                                }];
    } else {
        callback();
    }
}

- (void)queryActivitySummary {
    //查询当天Apple ring情况
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar
    components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
      fromDate:now];
    //开始日期
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *dayStart = [calendar dateFromComponents:components];
    //结束日期
    [components setHour:24];
    [components setMinute:0];
    [components setSecond:1];
    NSDate *dayEnd = [calendar dateFromComponents:components];
    NSLog(@"query summary from %@ to %@", dayStart, dayEnd);

    NSPredicate *predicateDate = [HKQuery predicateForSamplesWithStartDate:dayStart
                                                                   endDate:dayEnd
                                                                   options:HKQueryOptionStrictStartDate | HKQueryOptionStrictEndDate];
    HKActivitySummaryQuery *summaryQuery = [[HKActivitySummaryQuery alloc]
    initWithPredicate:predicateDate
       resultsHandler:^(HKActivitySummaryQuery *_Nonnull query, NSArray<HKActivitySummary *> *_Nullable activitySummaries, NSError *_Nullable error) {
           HKActivitySummary *summary = activitySummaries.firstObject;

           double energyCurrent = [summary.activeEnergyBurned doubleValueForUnit:[HKUnit kilocalorieUnit]];
           double energyGoal = [summary.activeEnergyBurnedGoal doubleValueForUnit:[HKUnit kilocalorieUnit]];
           double exerciseCurrent = [summary.appleExerciseTime doubleValueForUnit:[HKUnit minuteUnit]];
           double exerciseGoal = [summary.appleExerciseTimeGoal doubleValueForUnit:[HKUnit minuteUnit]];
           double standCurrent = [summary.appleStandHours doubleValueForUnit:[HKUnit countUnit]];
           double standGoal = [summary.appleStandHoursGoal doubleValueForUnit:[HKUnit countUnit]];

           NSLog(@"build upload summary, energy=(%.2f/%.2f), exercise=(%.2f/%.2f), stand=(%.2f/%.2f)",
                 energyCurrent,
                 energyGoal,
                 exerciseCurrent,
                 exerciseGoal,
                 standCurrent,
                 standGoal);

           NSLog(@"get query summary count:%lu", (unsigned long)activitySummaries.count);
       }];
    [self.healthStore executeQuery:summaryQuery];
}
@end
