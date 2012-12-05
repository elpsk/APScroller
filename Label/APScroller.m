//
// APScroller.m
//
// Copyright (c) 2012 Alberto Pasca (albertopasca.it). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "APScroller.h"

//
// DEFAULT CONFIG
//
#define DEFAULT_SCROLLERS 12
#define DEFAULT_SPEED     0.15
#define DEFAULT_FONT      @"Helvetica"
#define DEFAULT_FONT_SIZE 14
#define START_TAG         123
#define ALPHABET          @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ "


@interface APScroller ()
{
  int _Current;
}
@end


@implementation APScroller
@synthesize Speed;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    _Current   = 0;
    self.Speed = DEFAULT_SPEED;

    for ( int i=0; i<DEFAULT_SCROLLERS; i++ )
    {
      CGRect r = CGRectMake((DEFAULT_FONT_SIZE-2) * i, 0, (DEFAULT_FONT_SIZE-2), 20);
      APScrollView *Scroll = [[APScrollView alloc] initWithFrame:r];
      Scroll.tag = START_TAG + i;

      [self addSubview:Scroll];
    }
  }
  return self;
}

- (void) setWorld:(NSString*)world animated:(BOOL)anim
{
  NSMutableArray *word = [NSMutableArray arrayWithCapacity:[world length]];
  for ( int i=0; i<[world length]; i++ ) {
    [word addObject:[NSString stringWithFormat:@"%c", [world characterAtIndex:i]]];
  }
  
  [self WriteWord:word startFrom:0 animated:anim];
}

- (void) WriteWord:(NSArray*)letters startFrom:(int)i animated:(BOOL)anim
{
  _Current = i;
  if ( _Current >= DEFAULT_SCROLLERS ) return;

  [UIView animateWithDuration:self.Speed delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^
   {
     APScrollView *scroll = (APScrollView*)[self viewWithTag:START_TAG + _Current];
     NSString *l = letters[_Current];

     int pos = [scroll atPosition:l];
     [scroll scrollRectToVisible:CGRectMake(0, (DEFAULT_FONT_SIZE+4) * pos, (DEFAULT_FONT_SIZE-2), 20) animated:!anim];
   } completion:^(BOOL finish){
     [self WriteWord:letters startFrom:++_Current animated:anim];
   }];
}

@end


// ---


@interface APScrollView ()
{
  NSString *_Alphabet;
}
@end

@implementation APScrollView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    _Alphabet = ALPHABET;

    self.showsVerticalScrollIndicator   = NO;
    self.showsHorizontalScrollIndicator = NO;

    self.bounces     = NO;
    self.bouncesZoom = NO;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];

    [self MakeLabel];
  }

  return self;
}

- (void) MakeLabel
{
  UILabel  *lbl = [[UILabel alloc] initWithFrame:CGRectZero];

  lbl.font = [UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE];
  lbl.text = @"";
  lbl.numberOfLines   = [_Alphabet length];
  lbl.backgroundColor = [UIColor clearColor];

  CGSize ts = [@"A" sizeWithFont:lbl.font];
  self.contentSize = CGSizeMake(ts.width + 5, ts.height * [_Alphabet length]);
  lbl.frame  = CGRectMake(0, 0, ts.width + 5, ts.height * [_Alphabet length]);

  for ( int l=0; l<[_Alphabet length]; l++ ) {
    int intLetter = (char)[_Alphabet characterAtIndex:l];
    lbl.text = [NSString stringWithFormat:@"%@%c\r\n", lbl.text, (char)intLetter];
  }

  [self addSubview:lbl];
}

- (int) atPosition:(NSString*)c
{
  return (int)[_Alphabet rangeOfString:c].location;
}

@end

