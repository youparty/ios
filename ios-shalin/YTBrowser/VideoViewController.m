//
//  VideoViewController.m
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import "VideoViewController.h"
#import "ViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController
{
    NSMutableArray* videos;
}

@synthesize tableView;
@synthesize playButton;
@synthesize playlistName;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}




-(void) buttonAction
{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YoutubeView"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    videos = [[NSMutableArray alloc] init];
    
    NSString* badvariablenames = [[NSUserDefaults standardUserDefaults] stringForKey:@"playlistname"];
    
    //NSLog(badvariablenames);
    
    NSString *hi = [NSString stringWithFormat:@"https://youparty.firebaseio.com/playlists/%@/videos",badvariablenames];
    
    Firebase* videolist = [[Firebase alloc] initWithUrl:hi];
    
    //NSLog(@"%@", videolist.description);
    
    [playButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    
    
    [videolist observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [videos addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        
        [tableView reloadData];
        
    }];
    
    Firebase* theplaylistloc = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://youparty.firebaseio.com/playlists/%@",badvariablenames]];
    
    [theplaylistloc observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        playlistName.text = snapshot.value[@"name"];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [videos count];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    //    NSString* playlistname = [videos objectAtIndex:indexPath.row];
    //    [[NSUserDefaults standardUserDefaults] setValue:videos forKey:@"playlistname"];
    //
    //    VideoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Videos"];
    //    [self presentViewController:vc animated:YES completion:nil];
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    //NSLog(@"okokok");
    
    static NSString *CellIdentifier = @"Cell";
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 230, 60)];
    title.backgroundColor = [UIColor clearColor];
    title.numberOfLines = 0;
    title.lineBreakMode = UILineBreakModeWordWrap;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    
    UILabel* detail = [[UILabel alloc] initWithFrame:CGRectMake(97, 40, 230, 60)];
    detail.backgroundColor = [UIColor clearColor];
    detail.numberOfLines = 0;
    detail.lineBreakMode = UILineBreakModeWordWrap;
    detail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    
    UIImageView* thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 60)];
    
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell addSubview:title];
    [cell addSubview:detail];
    [cell addSubview:thumbnail];
    
    NSDictionary* chatMessage = [videos objectAtIndex:index.row];
    
    title.text = chatMessage[@"name"];
    [title sizeToFit];
    
    detail.text = [NSString stringWithFormat:@"youtube.com/%@",chatMessage[@"url"]];
    [detail sizeToFit];
    
    NSString* url = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",chatMessage[@"url"]];
    
    thumbnail.image = [UIImage imageNamed:@"thumbnail.png"];
    
    //NSLog(url);
    
    //NSString *imageUrl = @"http://www.foo.com/myImage.jpg";
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        thumbnail.image = [UIImage imageWithData:data];
    }];
    
    //cell.textLabel.text = chatMessage[@"name"];
    //cell.detailTextLabel.text = chatMessage[@"url"];
    
    //
    
    
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end