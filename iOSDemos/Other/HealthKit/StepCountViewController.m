//
//  StepCountViewController.m
//  healthkit
//
//  Created by janezhuang on 2021/11/13.
//

#import "StepCountViewController.h"
#import <HealthKit/HealthKit.h>

@interface StepCountViewController ()
@property (nonatomic) UILabel *stepCountLabel;
@property (nonatomic) UIButton *readButton;

@property (nonatomic) UITextField *stepCountTextField;
@property (nonatomic) UIButton *writeButton;

@property (nonatomic) HKHealthStore *healthStore;
@end

@implementation StepCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    self.healthStore = [[HKHealthStore alloc] init];

    self.stepCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 200, 40)];
    self.stepCountLabel.backgroundColor = UIColor.lightGrayColor;
    self.stepCountLabel.text = @"步数：";
    [self.view addSubview:self.stepCountLabel];

    self.readButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 160, 100, 30)];
    self.readButton.backgroundColor = UIColor.yellowColor;
    [self.readButton setTitle:@"读取步数" forState:UIControlStateNormal];
    [self.readButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.readButton addTarget:self action:@selector(readData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.readButton];

    self.stepCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 250, 200, 40)];
    self.stepCountTextField.backgroundColor = UIColor.lightGrayColor;
    self.stepCountTextField.placeholder = @"输入框";
    [self.view addSubview:self.stepCountTextField];

    self.writeButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 350, 100, 30)];
    self.writeButton.backgroundColor = UIColor.yellowColor;
    [self.writeButton setTitle:@"写入步数" forState:UIControlStateNormal];
    [self.writeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.writeButton addTarget:self action:@selector(writeData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.writeButton];
}

- (void)authIfNeed:(void (^)(void))callback {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKAuthorizationStatus stepAuthStatus = [self.healthStore authorizationStatusForType:stepType];
    //若用户之前没有授权过（不管是同意或拒绝），则status = NotDetermined
    if (stepAuthStatus == HKAuthorizationStatusNotDetermined) {
    } else {
        callback();
    }
    [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithObject:stepType]
                                             readTypes:[NSSet setWithObject:stepType]
                                            completion:^(BOOL success, NSError *_Nullable error) {
                                                if (success) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        callback();
                                                    });
                                                }
                                            }];
}
#pragma mark - Read
- (void)readData {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    [self authIfNeed:^{
        [self fetchSumOfSamplesTodayForType:stepType
                                       unit:[HKUnit countUnit]
                                 completion:^(double stepCount, NSError *error) {
                                     NSLog(@"%f", stepCount);
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         self.stepCountLabel.text = [NSString stringWithFormat:@"步数：%.f", stepCount];
                                     });
                                 }];
    }];
}

- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler {
    NSPredicate *predicate = [self predicateForSamplesToday];

    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType
                                                       quantitySamplePredicate:predicate
                                                                       options:HKStatisticsOptionSeparateBySource
                                                             completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                                                                 HKQuantity *sum = [result sumQuantity];

                                                                 if (completionHandler) {
                                                                     double value = [sum doubleValueForUnit:unit];

                                                                     completionHandler(value, error);
                                                                 }
                                                             }];

    [self.healthStore executeQuery:query];
}

- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *now = [NSDate date];

    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];

    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}
#pragma mark - Write
- (void)writeData {
    [self authIfNeed:^{
        double stepNum = self.stepCountTextField.text.doubleValue;

        NSDate *endDate = [NSDate date];
        NSDate *startDate = [NSDate dateWithTimeInterval:-300 sinceDate:endDate];
        HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        HKQuantity *stepQuantityConsumed = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:stepNum];
        HKDevice *device = [[HKDevice alloc] initWithName:@"initWithName"
                                             manufacturer:@"manufacturer"
                                                    model:@"model"
                                          hardwareVersion:@"hardwareVersion"
                                          firmwareVersion:@"firmwareVersion"
                                          softwareVersion:@"softwareVersion"
                                          localIdentifier:@"localIdentifier"
                                      UDIDeviceIdentifier:@"UDIDeviceIdentifier"];

        HKQuantitySample *stepConsumedSample = [HKQuantitySample quantitySampleWithType:stepType
                                                                               quantity:stepQuantityConsumed
                                                                              startDate:startDate
                                                                                endDate:endDate
                                                                                 device:device
                                                                               metadata:nil];

        [self.healthStore saveObject:stepConsumedSample
                      withCompletion:^(BOOL success, NSError *error) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if (success) {
                                  NSLog(@"success");
                                  [self readData];
                              } else {
                                  NSLog(@"The error was: %@.", error);
                              }
                          });
                      }];
    }];
}
@end
