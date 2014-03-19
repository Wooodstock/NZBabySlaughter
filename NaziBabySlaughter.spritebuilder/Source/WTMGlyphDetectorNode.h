//
//  WTMGlyphDetectorNode.h
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 19/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "WTMGlyphDetector.h"

@class WTMGlyphDetectorNode;

@protocol WTMGlyphDetectorNodeDelegate <NSObject>
@optional
- (void)wtmGlyphDetectorNode:(WTMGlyphDetectorNode*)theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score;
@end


@interface WTMGlyphDetectorNode : CCNode

@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) BOOL enableDrawing;

- (void)loadTemplatesWithNames:(NSString*)firstTemplate, ... NS_REQUIRES_NIL_TERMINATION;

- (NSString *)getGlyphNamesString;

@end
