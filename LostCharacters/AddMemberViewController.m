//
//  AddMemberViewController.m
//  LostCharacters
//
//  Created by Alex on 11/11/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "AddMemberViewController.h"
#import "AppDelegate.h"

@interface AddMemberViewController ()
@property (strong, nonatomic) IBOutlet UITextField *actorTextField;
@property (strong, nonatomic) IBOutlet UITextField *passengerTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *dobTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;
@property (strong, nonatomic) IBOutlet UITextField *originTextField;
@property NSManagedObjectContext *moc;

@end

@implementation AddMemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;


}


- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{

    NSManagedObject *lostMember = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:self.moc];

    [lostMember setValue:self.actorTextField.text forKey:@"actor"];
    [lostMember setValue:self.passengerTextField.text forKey:@"passenger"];
    [lostMember setValue:self.ageTextField.text forKey:@"age"];
    [lostMember setValue:[self getDateFormatFromString:self.dobTextField.text] forKey:@"dob"];
    [lostMember setValue:self.genderTextField.text forKey:@"gender"];
    [lostMember setValue:self.originTextField.text forKey:@"origin"];

    //    int rand = arc4random_uniform(300)+1;
    //[trojan setValue:@(rand) forKey:@"age"];

    [self.moc save:nil];

    self.actorTextField.text = @"";
    self.passengerTextField.text = @"";
    self.ageTextField.text = @"";
    self.dobTextField.text = @"";
    self.genderTextField.text = @"";
    self.originTextField.text = @"";

    self.navigationItem.title = @"Member added. Add another one.";

    [self resignFirstResponder];
}

-(NSDate *)getDateFormatFromString:(NSString *)string
{

    NSString *dateString = string; //@"01/02/2010";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];

    return dateFromString;
}


@end
