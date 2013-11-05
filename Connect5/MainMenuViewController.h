//
//  MainMenuViewController.h
//  Connect5
//
//  Created by Mohammed Eldehairy on 10/6/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connect5ViewController.h"
#import <GameKit/GameKit.h>
#import "MYIntroductionView.h"
@interface MainMenuViewController : UIViewController<GKGameCenterControllerDelegate,MYIntroductionDelegate>
{
    Connect5ViewController *GameView;
    IBOutlet UIButton *ResumBtn;
    
    NSMutableArray *panels ;
}
-(IBAction)NewGameAction:(id)sender;
-(IBAction)GameCenterAction:(id)sender;
-(IBAction)ResumeGame:(id)sender;
-(IBAction)HowToplay:(id)sender;
@end
