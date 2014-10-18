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
    // NSLog(@"Movie: %@", self.movie);
    
    [self.movieTitle setText:self.movie[@"title"]];
    [self.movieDescription setText:self.movie[@"synopsis"]];
    NSString* str = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSString* newStr = [str stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_det.jpg"];
    NSString* finalStr = [str stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    NSLog(@"str: %@, newStr: %@", str, newStr);
    
    // NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    // UIImage* placeholder = [UIImage imageWit]
    self.posterView.contentMode = UIViewContentModeScaleAspectFill;
    self.posterView.clipsToBounds = YES;
    // [self.posterView setImageWithURL:[NSURL URLWithString:str]];
    [self.posterView setImageWithURL:[NSURL URLWithString:newStr]];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:finalStr]];
    [self.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"Successful!");
        self.posterView.image = image;
        self.posterView.contentMode = UIViewContentModeScaleAspectFill;
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.34;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.posterView.layer addAnimation:transition forKey:nil];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed. :(");
    }];
    // [self.posterView setImageWithURL:[NSURL URLWithString:finalStr]];
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
