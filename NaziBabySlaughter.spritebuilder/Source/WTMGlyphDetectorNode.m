//
//  WTMGlyphDetectorNode.m
//  NaziBabySlaughter
//
//  Created by Thibault Palier on 19/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WTMGlyphDetectorNode.h"

@interface WTMGlyphDetectorNode() <WTMGlyphDelegate>
@property (nonatomic, strong) WTMGlyphDetector *glyphDetector;
@property (nonatomic, strong) NSMutableArray *glyphNamesArray;
@property (nonatomic, strong) UIBezierPath *myPath;
@end

@implementation WTMGlyphDetectorNode

- (void)didLoadFromCCB {
    
    self.userInteractionEnabled = TRUE;
    [self initGestureDetector];
    
    self.enableDrawing = YES;
    
    self.myPath = [[UIBezierPath alloc]init];
    self.myPath.lineCapStyle = kCGLineCapRound;
    self.myPath.miterLimit = 0;
    self.myPath.lineWidth = 10;
}

- (void)initGestureDetector
{
    self.glyphDetector = [WTMGlyphDetector detector];
    self.glyphDetector.delegate = self;
    self.glyphDetector.timeoutSeconds = 1;
    
    if (self.glyphNamesArray == nil)
        self.glyphNamesArray = [[NSMutableArray alloc] init];
    
    NSLog(@"GESTURE DETECTORE LOQDED");
}

#pragma mark - Public interfaces

- (NSString *)getGlyphNamesString
{
    if (self.glyphNamesArray == nil || [self.glyphNamesArray count] <= 0)
        return @"";
    
    return [self.glyphNamesArray componentsJoinedByString: @", "];
}

- (void)loadTemplatesWithNames:(NSString*)firstTemplate, ...
{
    va_list args;
    va_start(args, firstTemplate);
    for (NSString *glyphName = firstTemplate; glyphName != nil; glyphName = va_arg(args, id))
    {
        if (![glyphName isKindOfClass:[NSString class]])
            continue;
        
        [self.glyphNamesArray addObject:glyphName];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:glyphName ofType:@"json"]];
        [self.glyphDetector addGlyphFromJSON:jsonData name:glyphName];
    }
    va_end(args);
}

#pragma mark - WTMGlyphDelegate

- (void)glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    //Simply forward it to my parent
    if ([self.delegate respondsToSelector:@selector(wtmGlyphDetectorNode:glyphDetected:withScore:)])
        [self.delegate wtmGlyphDetectorNode:self glyphDetected:glyph withScore:score];
    
    [self performSelector:@selector(clearDrawingIfTimeout) withObject:nil afterDelay:1.0f];
}

- (void)glyphResults:(NSArray *)results
{
    //Raw results from the library?
    //Not sure what this delegate function is for, undocumented
}

#pragma mark - Touch events

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //This is basically the content of resetIfTimeout
    BOOL hasTimeOut = [self.glyphDetector hasTimedOut];
    if (hasTimeOut) {
        NSLog(@"Gesture detector reset");
        [self.glyphDetector reset];
        
        if (self.enableDrawing) {
            [self.myPath removeAllPoints];        }
    }
    
    //UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    [self.glyphDetector addPoint:point];
    
    //[super touchesBegan:touches withEvent:event];
    
    if (!self.enableDrawing)
        return;
    
    [self.myPath moveToPoint:point];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    [self.glyphDetector addPoint:point];
    
    //[super touchesMoved:touches withEvent:event];
    
    if (!self.enableDrawing)
        return;
    
    [self.myPath addLineToPoint:point];
    
    //This is not recommended for production, but it's ok here since we don't have a lot to draw
    //[self setNeedsDisplay];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    [self.glyphDetector addPoint:point];
    [self.glyphDetector detectGlyph];
    
    //[super touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
    //[super drawRect:rect];
    
    if (!self.enableDrawing)
        return;
    
    [[UIColor whiteColor] setStroke];
    [self.myPath strokeWithBlendMode:kCGBlendModeNormal alpha:0.5];
}

- (void)clearDrawingIfTimeout
{
    if (!self.enableDrawing)
        return;
    
    BOOL hasTimeOut = [self.glyphDetector hasTimedOut];
    if (!hasTimeOut)
        return;
    
    [self.myPath removeAllPoints];
    
    //This is not recommended for production, but it's ok here since we don't have a lot to draw
}





@end
