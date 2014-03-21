//
//  Game.h
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 17/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "CCNode.h"
#import "Player.h"



@protocol GameDelegate

@required
-(void)didGameOver:(int)score;

@end


@interface Game : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, strong) id<GameDelegate>delegate;

@end
