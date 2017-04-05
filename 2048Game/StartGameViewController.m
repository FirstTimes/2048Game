//
//  StartGameViewController.m
//  2048Game
//
//  Created by 李锐 on 2017/2/21.
//  Copyright © 2017年 lirui. All rights reserved.
//

#import "StartGameViewController.h"
#import "GameViewController.h"

@interface StartGameViewController ()

@end

@implementation StartGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startGame:(id)sender {
    GameViewController *gameView=[[GameViewController alloc]init];
    [self presentViewController:gameView animated:YES completion:nil];
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
