//
//  WebVideoViewController.h
//  YTBrowser
//
//  Created by Marin Todorov on 09/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "YTPlayerView.h"

@interface WebVideoViewController : UIViewController {
    NSMutableArray *playIDArray;
}

@property (weak, nonatomic) VideoModel* video;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@end
