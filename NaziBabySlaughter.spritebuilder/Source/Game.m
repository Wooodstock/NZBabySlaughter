//
//  Game.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 17/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"

@implementation Game{
    CCNode *_player;
    CCNode *_contentNode;
    CCNode *_playerZone;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    self.userInteractionEnabled = TRUE;
    [_player setVisible:true];
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


@end
