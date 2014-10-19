//
//  MoviesViewController.m
//  rottenTomatoes
//
//  Created by Gaurav Menghani on 10/13/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSMutableArray* filteredMovies;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
@property BOOL isFiltered;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void) reloadTableData {
    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=6fjvqr56d486tk629jv3m7sf"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        //NSLog(@"Conn Error: %@", connectionError);
        if (connectionError == nil) {
            NSLog(@"Response: %@", response);
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // NSLog(@"response: %@", dictionary);
            self.movies = dictionary[@"movies"];
            [self.tableView reloadData];
            
        } else {
            // self.movieSearchBar.hidden = YES;
            [UIView animateWithDuration:1.5 animations:^() {
                self.networkErrorView.alpha = 0.5;
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.alpha = 1.0;
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 140;
    self.movieSearchBar.delegate = self;
    self.title = @"Movies";
    self.isFiltered = NO;
    self.networkErrorView.alpha = 0.0;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self setRefreshControl:self.refreshControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self reloadTableData];
}

- (void) refreshTable {
    [self reloadTableData];
    [self.refreshControl endRefreshing];
    NSLog(@"Just made the call again.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltered ? self.filteredMovies.count : self.movies.count);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *mcell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = (self.isFiltered ? self.filteredMovies[indexPath.row] : self.movies[indexPath.row]);
    
    [mcell.titleLabel setText:movie[@"title"]];
    [mcell.runningTime setText:[NSString stringWithFormat:@"%@ minutes", movie[@"runtime"]]];
    [mcell.Rating setText:movie[@"mpaa_rating"]];
    [mcell.Rating.layer setBorderWidth:0.4];
    [mcell.Rating.layer setBorderColor:[UIColor grayColor].CGColor];
    [mcell.Rating.layer setCornerRadius:4];
    
    
    NSMutableArray* castNames = [[NSMutableArray alloc] init];
    NSArray* abridgedCast = movie[@"abridged_cast"];
    for (NSObject* o in abridgedCast) {
        NSDictionary* dict = (NSDictionary *)o;
        [castNames addObject:dict[@"name"]];
    }
    NSString* joinedCastNames = [castNames componentsJoinedByString:@",  "];
    [mcell.Actors setText:joinedCastNames];
    
    NSString* criticsScore = movie[@"ratings"][@"critics_score"];
    [mcell.score setText:[NSString stringWithFormat:@"%@%%", criticsScore]];
    NSString* audienceScore = movie[@"ratings"][@"audience_score"];
    [mcell.audienceScore setText:[NSString stringWithFormat:@"%@%%", audienceScore]];
    
    //[mcell.summaryLabel setText:movie[@"synopsis"]];
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    NSString* finalStr = [posterUrl stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_det.jpg"];
    
    [mcell.posterView setImageWithURL:[NSURL URLWithString:finalStr]];
    
    // NSLog(@"Values %@ %@", movie[@"title"], movie[@"synopsis"]);
    return mcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *movie = self.movies[indexPath.row];
    MovieDetailViewController* mdvc = [[MovieDetailViewController alloc] init];
    mdvc.movie = movie;
    [self.navigationController pushViewController:mdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate methods

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Something changed");
    if (searchText.length == 0) {
        self.isFiltered = NO;
        [self.tableView reloadData];
    } else {
        self.isFiltered = YES;
        self.filteredMovies = [[NSMutableArray alloc] initWithCapacity:self.movies.count];
        for (NSDictionary* dict in self.movies) {
            
            NSString* movieTitle = dict[@"title"];
            NSRange movieNameRange = [movieTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (movieNameRange.location != NSNotFound) {
                // NSLog(@"Movie text: %@ search text: %@", movieTitle, searchText);
                [self.filteredMovies addObject:dict];
            }
        }
        [self.tableView reloadData];
    }
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
