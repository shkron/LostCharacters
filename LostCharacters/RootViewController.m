//
//  ViewController.m
//  LostCharacters
//
//  Created by Alex on 11/11/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "MemberTableViewCell.h"
#import "AddMemberViewController.h"
#import "SINavigationMenuView.h"

#define kActor @"actor"
#define kPassenger @"passenger"
#define kAge @"age"
#define kDOB @"dob"
#define kGender @"gender"
#define kOrigin @"origin"



#define kPlistURL @"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, SINavigationMenuDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property BOOL editButton;
@property NSManagedObjectContext *moc;
@property NSArray *tableViewArray;


@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    self.tableView.allowsMultipleSelectionDuringEditing = YES;


    // check if we have a navigationItem
   if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Sort by Lost"];
        //Set in which view we will display a menu
        [menu displayMenuInView:self.view];
        //Create array of items
        menu.items = @[@"Actor", @"Passenger", @"Age", @"Date of Birth", @"Gender", @"Origin"];
        menu.delegate = self;
        self.navigationItem.titleView = menu;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadCoreData:kActor];
    if (self.tableViewArray.count == 0)
    {
        [self loadLostPlist];
    }
}

//MARK: Delegate methods

//navigation bar menu selector for index
- (void)didSelectItemAtIndex:(NSUInteger)index
{
//    NSLog(@"did selected item at index %lu", (unsigned long)index);

    switch (index)
    {
        case 0:
             [self loadCoreData:kActor];
            break;

        case 1:
            [self loadCoreData:kPassenger];
            break;

        case 2:
            [self loadCoreData:kAge];
            break;

        case 3:
            [self loadCoreData:kDOB];
            break;

        case 4:
            [self loadCoreData:kGender];
            break;

        case 5:
            [self loadCoreData:kOrigin];
            break;

        default:
            break;
    }

    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
// same thing, but puts under the nav bar
//    [self.tableView setContentOffset:CGPointZero animated:YES];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.tableViewArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *lostMember = self.tableViewArray[indexPath.row];
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.actorLabel.text = [lostMember valueForKey:@"actor"];
    cell.passengerLabel.text = [lostMember valueForKey:@"passenger"];
    cell.ageLabel.text = [lostMember valueForKey:@"age"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:[lostMember valueForKey:@"dob"]];
    cell.dobLabel.text = stringDate;
    
    cell.genderLabel.text = [lostMember valueForKey:@"gender"];
    cell.originLabel.text = [lostMember valueForKey:@"origin"];

    cell.photoImageView.image = [UIImage imageNamed:[lostMember valueForKey:@"actor"]];
    

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete

        [self.moc deleteObject:self.tableViewArray[indexPath.row]];
        [self loadCoreData:kActor];

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *deleteButtonName = @"SMOKE MONSTER";
    return deleteButtonName;
}




//MARK: DLoading the .plist
-(void)loadLostPlist
{
//    NSURL *plistURL = [NSURL URLWithString:kPlistURL];
    NSURL *plistURL = [[self documentsDirectory]URLByAppendingPathComponent:@"lost.plist"];


    NSArray *plistArray =[NSMutableArray arrayWithContentsOfURL:plistURL];
//    self.adoredToothpaste = [NSMutableArray arrayWithContentsOfURL:plistURL];
    if (plistArray == nil)
    {
        NSLog(@"ERROR: plistArray is empty");
    }
    else
    {
        [self extractPlistToCoreData:plistArray];
    }
}

-(void)extractPlistToCoreData:(NSArray *)plistArray
{

    for (int i=0; i < plistArray.count; i++)
    {
        NSManagedObject *lostMember = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:self.moc];

        //there are only 2 fields populated in the original plist
        [lostMember setValue:plistArray[i][@"actor"] forKey:@"actor"];
        [lostMember setValue:plistArray[i][@"passenger"] forKey:@"passenger"];
        [lostMember setValue:plistArray[i][@"age"] forKey:@"age"];
        [lostMember setValue:plistArray[i][@"dob"] forKey:@"dob"];
        [lostMember setValue:plistArray[i][@"gender"] forKey:@"gender"];
        [lostMember setValue:plistArray[i][@"origin"] forKey:@"origin"];

    //    int rand = arc4random_uniform(300)+1;
    //[trojan setValue:@(rand) forKey:@"age"];

        [self.moc save:nil];
    }
    [self loadCoreData:kActor];
}

-(void)loadCoreData:(NSString *)key
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Member"];

    //sorting the table by the name
    NSSortDescriptor *sortByActor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];

    //array of sort descriptors in order
    request.sortDescriptors = @[sortByActor];

    //mySQL format (for "filter")
    //    request.predicate = [NSPredicate predicateWithFormat:@"age >= 150"];
    //executing fetch request for the entity "Trojan"
    self.tableViewArray = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

//deleting multiple rows
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)editButton
{
    self.tableView.editing = YES;


    if(!self.editButton)
    {
        self.editButton = YES;
        editButton.title = @"Delete";
        editButton.tintColor = [UIColor redColor];
    }
    else
    {

        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        for (NSIndexPath *indexPath in selectedRows)
        {
            [self.moc deleteObject:self.tableViewArray[indexPath.row]];
        }
        [self loadCoreData:kActor];


        self.editButton = NO;
        editButton.title = @"Edit";
        editButton.tintColor = [UIColor blueColor];
        self.tableView.editing = NO;
    }

}

//MARK: documets directory for storing my custom .plist
-(NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    return url;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//nothing todo here

}



@end
