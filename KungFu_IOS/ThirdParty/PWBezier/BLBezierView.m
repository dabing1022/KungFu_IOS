

#import "BLBezierView.h"

#import "PWBezier.h"



@implementation BLBezierView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _bezier = [[PWBezier alloc] initWithOrigin:CGPointMake(40.0, 200.0)
                                     controlPoint1:CGPointMake(135.0, 100.0)
                                     controlPoint2:CGPointMake(130.0, 280.0)
                                       destination:CGPointMake(280.0, 200.0)];
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    UIBezierPath * bezierPath = [_bezier bezierPath];
    [[UIColor lightGrayColor] setStroke];
    [bezierPath setLineWidth:10.0];
    [bezierPath setLineCapStyle:kCGLineCapRound];
    [bezierPath stroke];
    
    // setup the graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    NSUInteger divisions = 18;
    CGFloat radius = 10.0;
    CGFloat lineRadius = 15.0;
    
    CGPoint bezierPoint, normalPoint1, normalPoint2;
    CGFloat t, angle;
    
    for(NSUInteger d = 0; d<= divisions; ++d) {
        // 0 <= t <= 1
        t = ((CGFloat)d) / divisions;
        
        bezierPoint = [_bezier outputAtT:t];
        angle = [_bezier tangentAngleAtT:t];
        
        // create a circle at the bezier point
        CGRect rect = CGRectMake(bezierPoint.x - radius, bezierPoint.y - radius, 2.0 * radius, 2.0 * radius);
        CGContextAddEllipseInRect(context, rect);
        CGContextStrokePath(context);
        
        // calculate the normal points which are +/- 90 degrees from the tangent angle
        normalPoint1.x = bezierPoint.x + lineRadius * cos(angle + M_PI_2);
        normalPoint1.y = bezierPoint.y + lineRadius * sin(angle + M_PI_2);
        
        normalPoint2.x = bezierPoint.x + lineRadius * cos(angle - M_PI_2);
        normalPoint2.y = bezierPoint.y + lineRadius * sin(angle - M_PI_2);
        
        CGRect rect1 = CGRectMake(normalPoint1.x - radius, normalPoint1.y - radius, 2.0 * radius, 2.0 * radius);
        CGContextAddEllipseInRect(context, rect1);
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        CGRect rect2 = CGRectMake(normalPoint2.x - radius, normalPoint2.y - radius, 2.0 * radius, 2.0 * radius);
        CGContextAddEllipseInRect(context, rect2);
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        CGContextMoveToPoint(context, normalPoint1.x, normalPoint1.y);
        CGContextAddLineToPoint(context, normalPoint2.x, normalPoint2.y);
        CGContextStrokePath(context);
    }
}


@end
