//
//  ViewController.m
//  GameCenter test
//
//  Created by Ahmad Alshebli on 6/22/16.
//  Copyright © 2016 PeopleCorpGaming. All rights reserved.
//

#import "ViewController.h"
#import "GameCenter.h"

@import GameKit;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    NSLog(@"Button clicked");
    //call the plugin to start game center authntication
    [[GameCenter SharedGameCenter] authnticateUserWithGameCenter];
}


@end
