//
//  Game.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 17/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"
#import "Ball.h"
#import "Crawling.h"

@implementation Game{
    CCNode *_player;
    CCNode *_contentNode;
    CCNode *_playerZone;
    WTMGlyphDetectorNode *_GlyphDetectorNode;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    self.userInteractionEnabled = TRUE;
    [_player setVisible:true];
    [self schedule:@selector(addBaby:) interval:1.5];
    
    //Gesture
    _GlyphDetectorNode.delegate = self;
    [_GlyphDetectorNode loadTemplatesWithNames:@"D", @"N", @"P", @"T", @"squarre", nil];
}

#pragma mark - Delegate

- (void)wtmGlyphDetectorView:(WTMGlyphDetectorNode*)theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    //Reject detection when quality too low
    //More info: http://britg.com/2011/07/17/complex-gesture-recognition-understanding-the-score/
    if (score < 0.7f)
        return;
    
    NSString *statusString = @"";
    
    NSString *glyphNames = [_GlyphDetectorNode getGlyphNamesString];
    if ([glyphNames length] > 0)
        statusString = [statusString stringByAppendingFormat:@"Loaded with %@ templates.\n\n", glyphNames];
    
    statusString = [statusString stringByAppendingFormat:@"Last gesture detected: %@\nScore: %.3f", glyph.name, score];
    
    NSLog(@"%@", statusString);
}
#pragma mark - Touch Handling

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"player x : %f", _player.position.x);
    NSLog(@"player y : %f", _player.position.y);
    
    NSLog(@"Content size height of playerZone y : %f", _playerZone.contentSize.height );
    
    
    CGPoint touchLocation = [touch locationInNode:_playerZone];

    

    NSLog(@"Touch Location y : %f", touchLocation.y);
    
    //Handle player ;oves
    // Zone du deplacement du joueur
    if(touchLocation.y < _playerZone.contentSize.height && touchLocation.x < _playerZone.contentSize.width && touchLocation.x > _playerZone.anchorPointInPoints.x)
    {
        [_player setPosition:ccp(touchLocation.x, _player.position.y)];
    }
    
    //Handle gun
    // Zone du baby
    if(touchLocation.y > _playerZone.contentSize.height && touchLocation.x < _playerZone.contentSize.width && touchLocation.x > _playerZone.anchorPointInPoints.x)
    {
        
        // 4
        Ball *ball = (Ball*)[CCBReader load:@"Ball"];
        ball.position = CGPointMake(_player.position.x + _player.contentSize.width, _player.position.y + _player.contentSize.height);
        [self addChild:ball ];
        
        CGPoint targetPosition = CGPointMake(_player.position.x + _player.contentSize.width, self.contentSize.height + ball.contentSize.height/2);
        
        CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
        CCActionRemove *actionRemove = [CCActionRemove action];
        [ball runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
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
    
    NSLog(@"TOUCH END pour bertrand qui pourit les logs");
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled
}


- (void)addBaby:(CCTime)dt {
    
    Crawling *baby = (Crawling*)[CCBReader load:@"Crawling"];
    
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
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:10.0 position:CGPointMake([[array objectAtIndex:rndValue] floatValue], -baby.contentSize.height/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [baby runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end
