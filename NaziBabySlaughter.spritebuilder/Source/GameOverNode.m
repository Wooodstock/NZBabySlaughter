//
//  GameOverNode.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 21/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverNode.h"

@implementation GameOverNode{
    CCLabelTTF *_scorelabel;
}


- (void)didLoadFromCCB {    
    //rightScore
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", @"score"];
    NSString *scorePath = [documentsDir stringByAppendingPathComponent:fileName];
    NSDictionary *scoreDic = [NSDictionary dictionaryWithContentsOfFile:scorePath];
    
    _scorelabel.string = [NSString stringWithFormat:@"Your Score: %@", [scoreDic objectForKey:@"score"]];
}

- (void)didRetry{
    CCLOG(@"I want retry");
    
    [[[CCDirector sharedDirector] runningScene] stopAllActions];
    [[[CCDirector sharedDirector] runningScene] removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] popScene];

    CCScene *gameplayScene = [CCBReader loadAsScene:@"Game"];
    [[CCDirector sharedDirector] pushScene:gameplayScene];
}

- (void)didMenu{
    CCLOG(@"I want retry");
    
    [[[CCDirector sharedDirector] runningScene] stopAllActions];
    [[[CCDirector sharedDirector] runningScene] removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] popScene];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] pushScene:gameplayScene];
}


@end
