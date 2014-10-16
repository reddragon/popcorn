//
//  MovieDetailViewController.m
//  rottenTomatoes
//
//  Created by Gaurav Menghani on 10/15/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Movie: %@", self.movie);
    
    [self.movieTitle setText:self.movie[@"title"]];
    [self.movieDescription setText:self.movie[@"synopsis"]];
    NSString* str = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSString* newStr = [str stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_det.jpg"];
    NSLog(@"str: %@, newStr: %@", str, newStr);
    
    // NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    // UIImage* placeholder = [UIImage imageWit]
    [self.posterView setImageWithURL:[NSURL URLWithString:str]];
    [self.posterView setImageWithURL:[NSURL URLWithString:newStr]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
