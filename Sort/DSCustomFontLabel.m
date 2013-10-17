//
//  DSCustomFontLabel.m
//  DSLib
//
//  Created by Alex on 10/8/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSCustomFontLabel.h"
#import "DSCFunctions.h"

@implementation DSCustomFontLabel

- (void)setupFont
{
  [self setFont:[UIFont fontWithName:[self customFontName] size:[[self font] pointSize]]];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupFont];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setupFont];
  }
  return self;
}

- (NSString *)customFontName
{
  ASSERT_ABSTRACT_METHOD;
  return nil;
}
@end
