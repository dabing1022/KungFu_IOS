

#import <UIKit/UIKit.h>


/**
 The PWBezier class represents a single cubic Bezier curve and allows you to calculate the position and angle of points along the curve.
 */
@interface PWBezier : NSObject
{
    CGPoint _C0, _C1, _C2, _C3;
    
    CGPoint _A, _B, _C, _D;
}

/// The cubic Bezier control points.
@property(readonly) CGPoint C0, C1, C2, C3;

/// The cubic polynomial coefficients such that Bez(t) = A*t^3 + B*t^2 + C*t + D
@property(readonly) CGPoint A, B, C, D;



/**
 Initializes and returns a newly allocated bezier object given the control points.
 @param origin The start point of the curve.
 @param controlPoint1 The first control point.
 @param controlPoint2 The second control point.
 @param destination The end point of the curve.
 @return An initialized bezier object or nil if the object couldn't be created.
 */
- (id)initWithOrigin:(CGPoint)C0 controlPoint1:(CGPoint)C1 controlPoint2:(CGPoint)C2 destination:(CGPoint)C3;

/**
 Initializes and returns a newly allocated bezier object that represents a straight line segment.
 @param startPoint The start point of the straight line segment.
 @param endPoint The end point of the straight line segment.
 @return An initialized bezier object or nil if the object couldn't be created.
 */
- (id)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 Initializes and returns a newly allocated bezier object that passes through the the provided points.
 @param startPoint The start point of the curve.
 @param firstMidPoint The point that the curve should pass through one third of the way along.
 @param secondMidPoint The point that the curve should pass through two thirds of the way along.
 @param endPoint The end point of the curve.
 @return An initialized bezier object or nil if the object couldn't be created.
 */
- (id)initWithStartPoint:(CGPoint)point0 firstMidPoint:(CGPoint)point1 secondMidPoint:(CGPoint)point2 endPoint:(CGPoint)point3;



/**
 Calculates the output (x position) of the curve at a given t.
 @param t The Bezier curve parameter that varies from 0 to 1.
 @return The output (x position) of the curve.
 */
- (CGFloat)outputXAtT:(CGFloat)t;

/**
 Calculates the output (y position) of the curve at a given t.
 @param t The Bezier curve parameter that varies from 0 to 1.
 @return The output (y position) of the curve.
 */
- (CGFloat)outputYAtT:(CGFloat)t;

/**
 Calculates the output (position) of the curve at a given t.
 @param t The Bezier curve parameter that varies from 0 to 1.
 @return The output (position) of the curve.
 */
- (CGPoint)outputAtT:(CGFloat)t;

/**
 Calculates the tangent angle of the curve at a given t.
 @param t The Bezier curve parameter that varies from 0 to 1.
 @return The tangent angle of the curve.
 */
- (CGFloat)tangentAngleAtT:(CGFloat)t;



/**
 Adds the bezier curve to the end of an existing UIBezierPath object.
 @param bezierPath The UIBezierPath object.
 */
- (void)addToBezierPath:(UIBezierPath*)bezierPath;

/**
 Initializes and returns a newly allocated UIBezierPath object that contains this bezier curve only.
 @return An initialized bezier path object that contains a single the bezier curve.
 */
- (UIBezierPath*)bezierPath;



@end
