//
//  DatePickerViewController.m
//  Homepwner
//
//  Created by Fernando Castor on 28/01/15.
//  Copyright (c) 2015 UFPE. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerViewController

- (IBAction)saveDate:(id)sender {
    self.item.dateCreated = self.datePicker.date;
}

@end
