//
//  Credits.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 21/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits

- (void)didBack{
    CCLOG(@"fsdfs");
    [[CCDirector sharedDirector] popScene];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] pushScene:gameplayScene];
}
@end
