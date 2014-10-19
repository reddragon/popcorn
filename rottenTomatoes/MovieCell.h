//
//  MovieCell.h
//  rottenTomatoes
//
//  Created by Gaurav Menghani on 10/13/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningTime;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *Rating;
@property (weak, nonatomic) IBOutlet UILabel *Actors;
@property (weak, nonatomic) IBOutlet UILabel *score;
@end
