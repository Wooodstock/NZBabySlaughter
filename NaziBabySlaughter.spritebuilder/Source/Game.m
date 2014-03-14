//
//  Game.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 17/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"
#import "Bullet.h"
#import "Crawling.h"
#import "SergentBaby.h"
#import "GeneralBaby.h"
#import "SergentHit.h"
#import "GeneralHit.h"
#import "poweredGun.h"
#import "Wall.h"
#import "PoweredGun.h"
#import "MegaGun.h"
#import <CoreMotion/CoreMotion.h>

#define ZOMB_SCORE 5
#define ZOMB_Left_SCORE 5
#define ZOMB_Right_SCORE 5

@implementation Game{
    CCNode *_player;
    CCNode *_contentNode;
    CCNode *_playerZone;
    CCPhysicsNode *_physicsWorld;
    CMMotionManager *_motionManager;
    CGPoint _lastTouchLocation;
    double interval;
    NSMutableArray *_columnArray;
    int _score;
    CCLabelTTF *_lifeLabel, *_scoreLabel;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    interval = 3;
    // Init the coremotionManager
    _motionManager = [[CMMotionManager alloc] init];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    
    [self addChild:_physicsWorld];
    
    _columnArray = [[NSMutableArray alloc] init];
    [_columnArray addObject:[NSNumber numberWithDouble:(self.contentSize.width*20/100)]];
    [_columnArray addObject:[NSNumber numberWithDouble:(self.contentSize.width*35/100)]];
    [_columnArray addObject:[NSNumber numberWithDouble:(self.contentSize.width*50/100)]];
    [_columnArray addObject:[NSNumber numberWithDouble:(self.contentSize.width*65/100)]];
    [_columnArray addObject:[NSNumber numberWithDouble:(self.contentSize.width*80/100)]];

    for (int i = 0; i < 5; i++) {
        Wall *wall = (Wall*)[CCBReader load:@"Wall"];
        wall.position = CGPointMake([[_columnArray objectAtIndex:i] floatValue], _playerZone.contentSize.height + wall.contentSize.height/2);
        wall.physicsBody.collisionType  = @"wallCollision";
        wall.physicsBody.collisionGroup = @"player";
        
        [_physicsWorld addChild:wall];
    }
    
    
    
    self.userInteractionEnabled = TRUE;
    [_player setVisible:true];
    [self schedule:@selector(scheduleIt:) interval:interval];
    [self schedule:@selector(addBaby:) interval:1];

    
    //Gesture
    UISwipeGestureRecognizer* rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer* leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer* upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:upRecognizer];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:tapRecognizer];
}

#pragma mark - Gesture Handling

-(void)handleTapFrom:(UISwipeGestureRecognizer*)recognizer{
    CCLOG(@"TAP");
    // if zone du baby
    //if(_lastTouchLocation.y > _playerZone.contentSize.height && _lastTouchLocation.x < _playerZone.contentSize.width && _lastTouchLocation.x > _playerZone.anchorPointInPoints.x)
    Bullet *bullet = (Bullet*)[CCBReader load:@"bullet"];
    bullet.position = CGPointMake(_player.position.x + _player.contentSize.width, _player.position.y + _player.contentSize.height);
    bullet.physicsBody.collisionType  = @"ballCollision";
    [_physicsWorld addChild:bullet];
    
    CGPoint targetPosition = CGPointMake(_player.position.x + _player.contentSize.width, self.contentSize.height + bullet.contentSize.height/2);
    
    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [bullet runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        CCLOG(@"Right Swipe");
        PoweredGun *poweredGun = (PoweredGun*)[CCBReader load:@"poweredGun"];
        poweredGun.position = CGPointMake(_player.position.x + _player.contentSize.width, _player.position.y + _player.contentSize.height);
        poweredGun.physicsBody.collisionType  = @"ballCollision";
        [_physicsWorld addChild:poweredGun];
        
        CGPoint targetPosition = CGPointMake(_player.position.x + _player.contentSize.width, self.contentSize.height + poweredGun.contentSize.height/2);
        
        CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
        CCActionRemove *actionRemove = [CCActionRemove action];
        [poweredGun runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        CCLOG(@"Left Swipe");
        MegaGun *megaGun = (MegaGun*)[CCBReader load:@"megaGun"];
        megaGun.position = CGPointMake(_player.position.x + _player.contentSize.width, _player.position.y + _player.contentSize.height);
        megaGun.physicsBody.collisionType  = @"ballCollision";
        [_physicsWorld addChild:megaGun];
        
        CGPoint targetPosition = CGPointMake(_player.position.x + _player.contentSize.width, self.contentSize.height + megaGun.contentSize.height/2);
        
        CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
        CCActionRemove *actionRemove = [CCActionRemove action];
        [megaGun runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        CCLOG(@"Up Swipe");
    }
}


#pragma mark - Touch Handling

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_playerZone];
    _lastTouchLocation = touchLocation;
    NSLog(@"Touch Location x : %f \n", touchLocation.x);
    NSLog(@"Touch Location y : %f \n", touchLocation.y);
}

- (void)onEnter {
    [super onEnter];
    [_motionManager startAccelerometerUpdates];
}

- (void)onExit {
    //accelerometer
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
    
    //gesture
    NSArray *grs = [[[CCDirector sharedDirector] view] gestureRecognizers];
    
    for (UIGestureRecognizer *gesture in grs){
        if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]){
            [[[CCDirector sharedDirector] view] removeGestureRecognizer:gesture];
        }
    }
}

-(void) scheduleIt:(CCTime)dt{
    NSLog(@"resceduling");

    if(interval > 0.1){
        [self schedule:@selector(addBaby:) interval:interval];
        interval = interval - 0.5;
    }
    
}

- (void)update:(CCTime)delta {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = _player.position.x + acceleration.x * 1000 * delta;
    newXPosition = clampf(newXPosition, 0, _playerZone.contentSize.width);
    _player.position = CGPointMake(newXPosition, _player.position.y);
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair babyCollision:(CCNode *)baby ballCollision:(CCNode *)ball {
    
    if([baby isKindOfClass:[Crawling class]]){
        
        if([ball isKindOfClass:[Bullet class]]){
            _score = _score + ZOMB_SCORE;
            _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", _score*100];
            [baby removeFromParent];
        }
        [ball removeFromParent];
        NSLog(@"crawling going");
    }
    if([baby isKindOfClass:[GeneralHit class]]){
        
        if([ball isKindOfClass:[PoweredGun class]]){
            _score = _score + ZOMB_SCORE;
            _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", _score*100];
            [baby removeFromParent];
        }
        [ball removeFromParent];
        NSLog(@"crawling going");
    }
    if([baby isKindOfClass:[SergentHit class]]){
        
        if([ball isKindOfClass:[MegaGun class]]){
            _score = _score + ZOMB_SCORE;
            _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", _score*100];
            [baby removeFromParent];
        }
        [ball removeFromParent];
        NSLog(@"crawling going");
    }
    
    
    if([baby isKindOfClass:[GeneralBaby class]]){
        if([ball isKindOfClass:[PoweredGun class]]){
            _score = _score + ZOMB_SCORE;
            _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", _score*100];
            [baby removeFromParent];
        }
        else if([ball isKindOfClass:[Bullet class]]){
            [baby removeFromParent];
            GeneralHit *generalHit = (GeneralHit*)[CCBReader load:@"GeneralHit"];
            
            // 2
            generalHit.position = CGPointMake(baby.position.x, baby.position.y);
            generalHit.physicsBody.collisionType  = @"babyCollision";
            [_physicsWorld addChild:generalHit];
            
            
            double vitesseZomb = (self.contentSize.height + generalHit.contentSize.height/2)/ 10;
            
            // Réglage de la vitesse, ici 2
            double temps = baby.position.y/(vitesseZomb*2);
            
            // 4
            CCAction *actionMove = [CCActionMoveTo actionWithDuration:temps position:CGPointMake(baby.position.x, -generalHit.contentSize.height/2)];
            CCAction *actionRemove = [CCActionRemove action];
            [generalHit runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        }
        [ball removeFromParent];
        NSLog(@"general going");
    }
    if([baby isKindOfClass:[SergentBaby class]]){
        if([ball isKindOfClass:[MegaGun class]]){
            _score = _score + ZOMB_SCORE;
            _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", _score*100];
            [baby removeFromParent];
        }
        else if([ball isKindOfClass:[Bullet class]]){
            SergentHit *sergentHit = (SergentHit*)[CCBReader load:@"SergentHit"];
            
            // 2
            sergentHit.position = CGPointMake(baby.position.x, baby.position.y);
            sergentHit.physicsBody.collisionType  = @"babyCollision";
            [baby removeFromParent];
            [_physicsWorld addChild:sergentHit];
            
            
            double vitesseZomb = (self.contentSize.height + sergentHit.contentSize.height/2)/ 10;
            
            // Réglage de la vitesse, ici 2
            double temps = baby.position.y/(vitesseZomb*2);
            
            // 4
            CCAction *actionMove = [CCActionMoveTo actionWithDuration:temps position:CGPointMake(baby.position.x, -sergentHit.contentSize.height/2)];
            CCAction *actionRemove = [CCActionRemove action];
            [sergentHit runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        }
        [ball removeFromParent];
        NSLog(@"caporal going");
    }
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair babyCollision:(CCNode *)baby wallCollision:(CCNode *)wall {
    Wall *currentWall = (Wall*) wall;
    [currentWall destroy];
    [baby removeFromParent];
    return YES;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touch moved
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
    
    int lowerBoundBaby = 0;
    int upperBoundBaby = 3;
    int rndValueBaby = lowerBoundBaby + arc4random() % (upperBoundBaby - lowerBoundBaby);
    
    
    int lowerBound = 0;
    int upperBound = 5;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    Crawling *crawling;
    SergentBaby *sergent;
    GeneralBaby *general;

    switch (rndValueBaby) {
        case 1:
        {

            crawling = (Crawling*)[CCBReader load:@"Crawling"];

            // 2
            crawling.position = CGPointMake([[_columnArray objectAtIndex:rndValue] floatValue], self.contentSize.height + crawling.contentSize.height/2);
            crawling.physicsBody.collisionType  = @"babyCollision";
            [_physicsWorld addChild:crawling];
            
            // 4
            CCAction *actionMove = [CCActionMoveTo actionWithDuration:10.0 position:CGPointMake([[_columnArray objectAtIndex:rndValue] floatValue], -crawling.contentSize.height/2)];
            CCAction *actionRemove = [CCActionRemove action];
            [crawling runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        }
            break;
        case 2:
        {
            sergent = (SergentBaby*)[CCBReader load:@"SergentBaby"];
            // 2
            sergent.position = CGPointMake([[_columnArray objectAtIndex:rndValue] floatValue], self.contentSize.height + sergent.contentSize.height/2);
            sergent.physicsBody.collisionType  = @"babyCollision";
            [_physicsWorld addChild:sergent];
            
            // 3 - setup of zombies speed
            /*int minDuration = 2.0;
             int maxDuration = 4.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration;*/
            
            // 4
            CCAction *actionMoveSergent = [CCActionMoveTo actionWithDuration:10.0 position:CGPointMake([[_columnArray objectAtIndex:rndValue] floatValue], -sergent.contentSize.height/2)];
            CCAction *actionRemoveSergent = [CCActionRemove action];
            [sergent runAction:[CCActionSequence actionWithArray:@[actionMoveSergent,actionRemoveSergent]]];
        }
            break;
        case 0:
        {
            general = (GeneralBaby*)[CCBReader load:@"GeneralBaby"];
            // 2
            general.position = CGPointMake([[_columnArray objectAtIndex:rndValue] floatValue], self.contentSize.height + general.contentSize.height/2);
            //baby.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, baby.contentSize} cornerRadius:0];
            general.physicsBody.collisionType  = @"babyCollision";
            [_physicsWorld addChild:general];
            
            // 3 - setup of zombies speed
            /*int minDuration = 2.0;
             int maxDuration = 4.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration;*/
            
            // 4
            CCAction *actionMoveGeneral = [CCActionMoveTo actionWithDuration:10.0 position:CGPointMake([[_columnArray objectAtIndex:rndValue] floatValue], -general.contentSize.height/2)];
            CCAction *actionRemoveGeneral = [CCActionRemove action];
            [general runAction:[CCActionSequence actionWithArray:@[actionMoveGeneral,actionRemoveGeneral]]];
        }
            break;
        default:{}
            break;
    }
    
    



}

@end
