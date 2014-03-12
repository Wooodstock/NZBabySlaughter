//
//  Game.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 17/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"
#import "Baby.h"

@implementation Game{
    CCNode *_player;
    CCNode *_contentNode;
    CCNode *_playerZone;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    self.userInteractionEnabled = TRUE;
    [_player setVisible:true];
    [self schedule:@selector(addBaby:) interval:1.5];
}

#pragma mark - Touch Handling

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"player x : %f", _player.position.x);
    NSLog(@"player y : %f", _player.position.y);
    
    NSLog(@"Content size height of playerZone y : %f", _playerZone.contentSize.height );
    
    
    CGPoint touchLocation = [touch locationInNode:_playerZone];
    
    NSLog(@"Touch Location y : %f", touchLocation.y);

    
    if(touchLocation.y < _playerZone.contentSize.height && touchLocation.x < _playerZone.contentSize.width && touchLocation.x > _playerZone.anchorPointInPoints.x)
    {
        [_player setPosition:ccp(touchLocation.x, _player.position.y)];
    }
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // whenever touches move, update the position of the mouseJointNode to the touch position
    CGPoint touchLocation = [touch locationInNode:_playerZone];
    if(touchLocation.y < _playerZone.contentSize.height && touchLocation.x < _playerZone.contentSize.width && touchLocation.x > _playerZone.anchorPointInPoints.x)
    {
        [_player setPosition:ccp(touchLocation.x, _player.position.y)];
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled
}


- (void)addBaby:(CCTime)dt {
    
    Baby *baby = (Baby*)[CCBReader load:@"Baby"];
    
    // 1
    int minX = baby.contentSize.width / 2;
    int maxX = self.contentSize.width - baby.contentSize.width / 2;
    int rangeX = maxX - minX;
    int randomX = (arc4random() % rangeX) + minX;
    CCLOG(@"contentSize : %f", self.contentSize.width);
    
    // tableau de pourcentage de colonne
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSNumber numberWithDouble:(self.contentSize.width*20/100)]];
    [array addObject:[NSNumber numberWithDouble:(self.contentSize.width*35/100)]];
    [array addObject:[NSNumber numberWithDouble:(self.contentSize.width*50/100)]];
    [array addObject:[NSNumber numberWithDouble:(self.contentSize.width*65/100)]];
    [array addObject:[NSNumber numberWithDouble:(self.contentSize.width*80/100)]];
    
    int lowerBound = 0;
    int upperBound = 5;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);

    // 2
    baby.position = CGPointMake([[array objectAtIndex:rndValue] floatValue], self.contentSize.height + baby.contentSize.height/2);
    [self addChild:baby];
    
    // 3 - setup of zombies speed
    /*int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;*/
    
    // 4
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:5.0 position:CGPointMake([[array objectAtIndex:rndValue] floatValue], -baby.contentSize.height/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [baby runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end
