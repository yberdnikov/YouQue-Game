//
//  MainMenuViewController.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/6/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray-texture-Wallpaper.jpg"] ];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    GameEntity *ResumedGame = [PersistentStore getLastGame];
    if(!ResumedGame)
    {
        ResumBtn.enabled = NO;
    }else
    {
        ResumBtn.enabled = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)NewGameAction:(id)sender
{
    
    if(!GameView)
    {
        GameView = [[Connect5ViewController alloc] initWithNibName:@"Connect5ViewController_iPhone" bundle:nil];
        GameView.IsResumedGame = NO;
        [self.navigationController pushViewController:GameView animated:YES];
    }
    else
    {
        GameView.IsResumedGame = NO;
        [self.navigationController pushViewController:GameView animated:YES];
        [GameView ReloadNewGame];
    }
    
    
    
}
-(void)GameCenterAction:(id)sender
{
    if((floorf([[UIDevice currentDevice] systemVersion].floatValue))>=6)
    {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        
    }
}
-(void)ResumeGame:(id)sender
{
    GameEntity *ResumedGame = [PersistentStore getLastGame];
    if(!ResumedGame.graph)
    {
        return;
    }
    if(!GameView)
    {
        GameView = [[Connect5ViewController alloc] initWithNibName:@"Connect5ViewController_iPhone" bundle:nil];
        GameView.IsResumedGame = YES;
        GameView.ResumedGame = ResumedGame;
        [self.navigationController pushViewController:GameView animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:GameView animated:YES];
        [GameView reloadGame:ResumedGame];
    }
    
    
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)HowToplay:(id)sender
{
    if(!panels)
    {
        [self initializeHowToPlayView];
    }
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:panels];
    [introductionView setBackgroundColor:[UIColor colorWithWhite:0.05 alpha:0.9]];
    introductionView.delegate = self;
    [introductionView showInView:self.view animateDuration:0.3];
}
-(void)initializeHowToPlayView
{
    panels = [NSMutableArray array];
    MYIntroductionPanel *ObjectivePanel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"objective.png"] description:@"The objective is to collect rows of 4 or more cells with the same colour either vertically ,horizontally ,or diagonally to gain points."];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"selection.png"] description:@"To move a coloured cell around ,first select it so that you see it glowing,Then select another unoccupied place so that it moves there ."];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tut.png"] description:@"Every time you move a cell , new cells are added ,And the cells to be added next are shown at the top, Except when your move completes rows of 4 or more cells of same colour, no new cells are added ."];
    
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"UndoTut.png"] description:@"You can undo any move by pressing the undo button on the top right corner ."];
    [panels addObject:ObjectivePanel];
    [panels addObject:panel2];
    [panels addObject:panel3];
    [panels addObject:panel4];
    
}
-(void)introductionDidFinishWithType:(MYFinishType)finishType
{
    
}
-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex
{
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return toInterfaceOrientation==UIInterfaceOrientationPortrait;
    }else
    {
        return YES;
    }
}
@end
