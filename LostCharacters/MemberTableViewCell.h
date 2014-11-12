//
//  MemberTableViewCell.h
//  LostCharacters
//
//  Created by Alex on 11/11/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *actorLabel;
@property (strong, nonatomic) IBOutlet UILabel *passengerLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *originLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end
