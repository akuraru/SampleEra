
#import "ViewController.h"
#import "UITextFieldWithDatePicker.h"
#import "UITextFieldWithPickerProtocol.h"

@interface ViewController () <UITextFieldWithPickerProtocol>

@property (weak, nonatomic) IBOutlet UILabel *ageText;
@property (weak, nonatomic) IBOutlet UITextFieldWithDatePicker *birthdayText;

@property (weak, nonatomic) IBOutlet UILabel *ageText2;
@property (weak, nonatomic) IBOutlet UITextFieldWithDatePicker *birthdayText2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _birthdayText.datePickerMode = UIDatePickerModeDate;
    _birthdayText2.datePickerMode = UIDatePickerModeDate;
    
    _birthdayText.delegate = self;
    _birthdayText2.delegate = self;
    
    [self updateText];
    [self updateText2];
}
- (void)savePickerFrom:(id)textFieldWithPicker {
    [self updateText];
    [self updateText2];
}

// birthday:NSDate から age:NSIntegerを生成したいが和暦だとバグる
- (void)updateText {
    [_birthdayText updateText];
    
    NSDate *birthday = _birthdayText.date;
    
    NSInteger age = [self yearForNSDate:[NSDate date]] - [self yearForNSDate:birthday];
    
    _ageText.text = @(age).stringValue;
}

// こっちは大丈夫
- (void)updateText2 {
    [_birthdayText2 updateText];
    
    NSDate *birthday = _birthdayText2.date;
    
    NSDate *gregorianBirthday = [self gregorianDateWithDate:birthday];
    NSDate *gregorianToday = [self gregorianDateWithDate:[NSDate date]];
    
    NSInteger age = [self yearForNSDate:gregorianToday] - [self yearForNSDate:gregorianBirthday];
    
    _ageText2.text = @(age).stringValue;
}
- (NSDate *)gregorianDateWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit fromDate:date];
    comp.era = 0;
    return [calendar dateFromComponents:comp];
}

- (NSInteger)yearForNSDate:(NSDate *)date {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [currentCalendar components:NSYearCalendarUnit fromDate:date];
    return comp.year;
}

@end
