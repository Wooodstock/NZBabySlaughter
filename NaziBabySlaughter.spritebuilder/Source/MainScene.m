//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene


- (void)play {
    CCLOG(@"play button pressed");
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Game"];
    [[CCDirector sharedDirector] pushScene:gameplayScene];
    
    //[[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)didGameOver:(int)score{
    CCLOG(@"tryng to do something");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameOverNode"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
