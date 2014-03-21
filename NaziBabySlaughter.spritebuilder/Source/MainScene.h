//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Game.h"
#import "GameOverNode.h"

@interface MainScene : CCNode <GameDelegate>

-(void)didGameOver:(int)score;

@end
