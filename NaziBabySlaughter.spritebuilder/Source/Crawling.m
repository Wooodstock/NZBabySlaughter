//
//  Crawling.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 19/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Crawling.h"

@implementation Crawling

- (id)init {
    self = [super init];
    
    if (self) {
        CCLOG(@"Crawling created");
    }
    
    //[self performSelector:@selector(die)withObject:nil afterDelay:3.0];
    
    return self;
}

/*
-(void)die{
    [self removeFromParent];
}
*/


@end
