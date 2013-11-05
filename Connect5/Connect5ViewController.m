//
//  Connect5ViewController.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "Connect5ViewController.h"

@interface Connect5ViewController ()

@end

@implementation Connect5ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(floorf([[UIDevice currentDevice] systemVersion].floatValue)>= 7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    [self.navigationController setNavigationBarHidden:YES];
	ScoreBoard.layer.cornerRadius = 10;
    UIView *gameContainerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 600, 400)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        gameContainerView.frame = CGRectMake(20, 20, self.view.frame.size.width, 400);
       gameContainerView.center = CGPointMake(self.view.bounds.size.width/2, 280);
    }else
    {
        gameContainerView.frame = CGRectMake(20, 20, 700, 600);
        gameContainerView.center = CGPointMake(self.view.bounds.size.width/2, 450);
    }
    
    gameContainerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:gameContainerView];
    
    
    if(_IsResumedGame)
    {
        _matrix = [[MatrixView alloc] initWithFrame:CGRectZero withGame:self.ResumedGame gameReumed:YES];
    }else
    {
        _matrix = [[MatrixView alloc] initWithFrame:CGRectZero] ;
    }
    _matrix.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    _matrix.delegate = self;
    _matrix.ScoreBoard = ScoreBoard;
    
    int y = 480;
    int xOffset = 80;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        y =330;
        xOffset = 0;
    }
    int cellSize = CELL_SIZE;
    
    CellView *FirstNextCell = [[CellView alloc] initWithFrame:CGRectMake(20+xOffset, y , 0, 0)];
    FirstNextCell.tag = 4001;
    [gameContainerView addSubview:FirstNextCell];
    
    _matrix.FirstNextCell = FirstNextCell;
    
    CellView *SecondNextCell = [[CellView alloc] initWithFrame:CGRectMake(20+cellSize+10+xOffset, y , 0, 0)];
    SecondNextCell.tag = 4002;
    [gameContainerView addSubview:SecondNextCell];
    
    _matrix.SecondNextCell = SecondNextCell;
    
    CellView *thirdNextCell = [[CellView alloc] initWithFrame:CGRectMake(20+2*(cellSize+10)+xOffset, y , 0, 0)];
    thirdNextCell.tag = 4003;
    [gameContainerView addSubview:thirdNextCell];
    
    _matrix.thirdNextCell = thirdNextCell;
    
    _matrix.UndoBtn = UndoBtn;
    
    [gameContainerView addSubview:_matrix];
    
    [CancelBtn addTarget:_matrix action:@selector(CancelAction:) forControlEvents:UIControlEventTouchUpInside];
    CancelBtn.enabled = NO;
    okBtn.enabled = NO;
    [okBtn addTarget:_matrix action:@selector(OKAction:) forControlEvents:UIControlEventTouchUpInside];
    _matrix.CancelBtn = CancelBtn;
    _matrix.OKBtn = okBtn;
    
    

    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)MatrixViewQuit:(MatrixView *)matrixView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)QuitAction:(id)sender
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Pause" andMessage:@""];
   
    [alertView addButtonWithTitle:@"Quit"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              [self Quit];
                          }];
    
    [alertView addButtonWithTitle:@"New Game"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                              GraphCell *emptyCell = [[GraphCell alloc] init];
                              emptyCell.color = unOccupied;
                              [_matrix.FirstNextCell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
                              [_matrix.SecondNextCell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
                              [_matrix.thirdNextCell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
                              [_matrix ReloadNewGame];
                          }];
    [alertView addButtonWithTitle:@"Cancel"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self Quit];
            break;
        default:
        {
            GraphCell *emptyCell = [[GraphCell alloc] init];
            emptyCell.color = unOccupied;
            [_matrix.FirstNextCell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
            [_matrix.SecondNextCell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
            [_matrix.thirdNextCell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
            [_matrix ReloadNewGame];
        }
            break;
    }
}
-(void)Quit
{
    [self saveGame];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveGame
{
    [_matrix saveGame];
}
-(void)reloadGame:(GameEntity *)game
{
    [_matrix ReloadGame:game];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_matrix)
    {
        [_matrix ResetUndo];
    }
    
}
-(void)ReloadNewGame
{
    [_matrix ResetUndo];
    [_matrix ReloadNewGame];
}
-(void)dealloc
{
    
}
-(void)UndoAction:(id)sender
{
    [_matrix undoLastMove];
}
-(void)RedoAction:(id)sender
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
