//
//  Game.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 17/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"
#import "Baby.h"


@implementation Game

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    [self schedule:@selector(addMonster:) interval:1.5];
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
}

- (void)addMonster:(CCTime)dt {
    
    Baby *baby = (Baby*)[CCBReader load:@"Baby"];
    
    // 1
    int minX = baby.contentSize.width / 2;
    int maxX = self.contentSize.width - baby.contentSize.width / 2;
    int rangeX = maxX - minX;
    int randomX = (arc4random() % rangeX) + minX;
    CCLOG(@"contentSize : %f", self.contentSize.width);

    // 2
    baby.position = CGPointMake(randomX, self.contentSize.height + baby.contentSize.height/2);
    [self addChild:baby];
    
    // 3 - setup of zombies speed
    /*int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;*/
    
    // 4
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:5.0 position:CGPointMake(randomX, -baby.contentSize.height/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [baby runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end
