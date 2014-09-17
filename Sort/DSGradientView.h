//
//  DSGradientView.h
//  DSLib
//
//  Created by Diejmon on 8/27/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGradientView : UIView
/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable*/
@property (nonatomic, strong) NSArray *colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */
@property(copy) NSArray *locations;

/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

@property CGPoint startPoint, endPoint;

@end