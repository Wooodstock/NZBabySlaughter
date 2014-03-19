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
#import "WTMGlyphDetector.h"
#import "WTMGlyphDetectorNode.h"

@interface Game : CCNode <WTMGlyphDetectorNodeDelegate>

@property (nonatomic, strong) WTMGlyphDetectorNode *gestureDetectorNode;

@end
