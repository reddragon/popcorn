//
//  MovieDetailViewController.h
//  rottenTomatoes
//
//  Created by Gaurav Menghani on 10/15/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;
@property (strong, nonatomic) NSDictionary* movie;

@end
