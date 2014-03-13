//
//  Wall.m
//  NaziBabySlaughter
//
//  Created by Bertrand on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Wall.h"

@implementation Wall{
    int live;
}



- (id)init {
    self = [super init];
    
    if (self) {
        live = 5;
        CCLOG(@"Wall created");
    }
    
    return self;
}

- (void) destroy{
    live --;
    switch (live)
    {
        case 0:
            [self removeFromParent];
            break;
        case 1:
            self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"Walls/wall1.png"];
            break;
        case 2:
            self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"Walls/wall2.png"];
            break;
        case 3:
            self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"Walls/wall3.png"];
            break;
        case 4:
            self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"Walls/wall4.png"];
            break;
        default:
            break;
    }
}

@end
