//
//  DetailViewController.m
//  Homepwner
//
//  Created by Fernando Castor on 28/01/15.
//  Copyright (c) 2015 UFPE. All rights reserved.
//
#import "DetailViewController.h"
#import "BNRItem.h"
#import "DatePickerViewController.h"
#import "Homepwner-Swift.h"

// both protocols are required because of the camera. UIImagePickerControllerDelegate is the one
// we would expect, whereas UINavigationControllerDelegate is necessary because the former inherits
// from the latter.
@interface DetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (strong, nonatomic) ImageStore *imageStore;
@end

@implementation DetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    DetailViewController *inst = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.imageStore = [ImageStore sharedStore];
    return inst;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];

// The line above subsumes all the following ones.
//    [self.nameField resignFirstResponder];
//    [self.serialField resignFirstResponder];
//    [self.valueField resignFirstResponder];
}
- (IBAction)removePicture:(id)sender {
    UIImage *currentImage = [[ImageStore sharedStore] imageForKey:self.item.itemKey];
    if (currentImage) {
        self.imageView.image = nil;
        [[ImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    }
    
    [self.view setNeedsDisplay];
}

- (IBAction)takePicture: (id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]
        || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        UILabel *messingWithPhoto = [[UILabel alloc] initWithFrame: imagePicker.view.bounds];
        messingWithPhoto.text = @"This should mess up the photograph.\n";
        messingWithPhoto.alpha = 0.3; // makes the text transparent. Every view has this field!-----------------
        imagePicker.cameraOverlayView = messingWithPhoto;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSLog(@"The device does not have a camera. Using the photo library instead.");
    }

    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;

    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
    // UIImagePickerController is a MODAL view controller. This means that it takes up
    // the entire screen until its work is done.
}

- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *oldKey = self.item.itemKey;
    if(oldKey) {
        [[ImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    
    [[ImageStore sharedStore] setImage:image key:self.item.itemKey];
    
    [self dismissViewControllerAnimated:YES completion:^{ NSLog(@"Got a picture."); }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{ NSLog(@"Gave up taking the picture."); }];
}

- (IBAction)changeDate:(id)sender {
    DatePickerViewController *dpvc = [[DatePickerViewController alloc] init];
    dpvc.item = self.item;
    [self.navigationController pushViewController:dpvc animated:YES];
}

// This view controller works as a delegate for all the text fields in the xib file.
// The connections were established in the IB, instead of programatically.
- (void)viewWillAppear:(BOOL)animated {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.nameField.text = self.item.itemName;
    self.serialField.text = self.item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    
    UIImage *tempImg = [[ImageStore sharedStore] imageForKey:self.item.itemKey];
    if (tempImg) {
        self.imageView.image = tempImg;
    }
    
    // For the date, we need a DateFormatter.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateFormat = NSDateFormatterNoStyle;
    }
    self.dateLabel.text = [dateFormatter stringFromDate:self.item.dateCreated];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Details of %@", self.item.itemName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hideKeyboard];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.valueField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return YES;
}

//- (BOOL)textFieldWillEndEditing:(UITextField *)textField {
//    textField.keyboardType = UIKeyboardTypeDecimalPad;
//    return YES;
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    // dateCreated is a read-only property. Can't be modified.
}

@end
