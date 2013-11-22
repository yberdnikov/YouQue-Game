//
//  Connect5ViewController.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixView.h"
#import "SIAlertView.h"
#import "SSPieProgressView.h"

#define MAX_NUMBER_OF_ADDED_CELLS 5
@interface Connect5ViewController : UIViewController<UIAlertViewDelegate,MatrixViewDelegate>
{
    IBOutlet UIButton *okBtn;
    IBOutlet UIButton *CancelBtn;
    IBOutlet UILabel *ScoreBoard;
    IBOutlet UIButton *UndoBtn;
    IBOutlet UILabel *LevelLbl;
    IBOutlet SSPieProgressView *progressView;
}
@property(nonatomic,retain)GameEntity *ResumedGame;
@property(nonatomic,assign)BOOL IsResumedGame;
@property(nonatomic,retain)MatrixView *matrix;
-(void)ReloadNewGame;
-(IBAction)QuitAction:(id)sender;
-(void)saveGame;
-(void)reloadGame:(GameEntity*)game;
-(IBAction)UndoAction:(id)sender;
-(IBAction)RedoAction:(id)sender;
@end
