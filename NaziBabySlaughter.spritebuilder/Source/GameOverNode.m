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

@synthesize _score;

- (void)didLoadFromCCB {
    CCLOG(@"GameOver node created with score %d", self._score*100);
    _scorelabel.string = [NSString stringWithFormat:@"Your Score: %d", self._score*100];
}

- (void)didRetry{
    CCLOG(@"I want retry");
}


@end
