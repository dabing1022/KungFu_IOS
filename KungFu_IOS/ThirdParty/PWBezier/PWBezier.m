

#import "PWBezier.h"

@implementation PWBezier


@synthesize C0 = _C0, C1 = _C1, C2 = _C2, C3 = _C3;
@synthesize A = _A, B = _B, C = _C, D = _D;



- (id)initWithOrigin:(CGPoint)C0 controlPoint1:(CGPoint)C1 controlPoint2:(CGPoint)C2 destination:(CGPoint)C3 {
    self = [super init];
    if (self) {
        _C0 = C0;
        _C1 = C1;
        _C2 = C2;
        _C3 = C3;
        
        [self calculateCubicCoefficients];
    }
    
    return self;
}


- (id)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    self = [super init];
    if (self) {
        _C0 = startPoint;
        
        _C1.x = startPoint.x + 1.0/3.0*(endPoint.x - startPoint.x);
        _C1.y = startPoint.y + 1.0/3.0*(endPoint.y - startPoint.y);
        
        _C2.x = startPoint.x + 2.0/3.0*(endPoint.x - startPoint.x);
        _C2.y = startPoint.y + 2.0/3.0*(endPoint.y - startPoint.y);
        
        _C3 = endPoint;
        
        [self calculateCubicCoefficients];
    }
    return self;
}


- (id)initWithStartPoint:(CGPoint)point0 firstMidPoint:(CGPoint)point1 secondMidPoint:(CGPoint)point2 endPoint:(CGPoint)point3 {
    self = [super init];
    if (self) {
        // u = 1/3, v = 2/3 -> uniform
        CGPoint pointC, pointD;
        pointC.x = point1.x - (8.0*point0.x + point3.x)/27.0;
        pointC.y = point1.y - (8.0*point0.y + point3.y)/27.0;
        pointD.x = point2.x - (point0.x + 8.0*point3.x)/27.0;
        pointD.y = point2.y - (point0.y + 8.0*point3.y)/27.0;
        
        
        _C0 = point0;
        
        _C1.x = 3.0*pointC.x - 1.5*pointD.x;
        _C1.y = 3.0*pointC.y - 1.5*pointD.y;
        
        _C2.x = 3.0*pointD.x - 1.5*pointC.x;
        _C2.y = 3.0*pointD.y - 1.5*pointC.y;
        
        _C3 = point3;
        
        [self calculateCubicCoefficients];
    }
    
    return self;
}


- (void)calculateCubicCoefficients {
    
    _A.x = _C3.x - 3.0*_C2.x + 3.0*_C1.x - _C0.x;
    _A.y = _C3.y - 3.0*_C2.y + 3.0*_C1.y - _C0.y;
    
    _B.x = 3.0*_C2.x - 6.0*_C1.x + 3.0*_C0.x;
    _B.y = 3.0*_C2.y - 6.0*_C1.y + 3.0*_C0.y;
    
    _C.x = 3.0*_C1.x - 3.0*_C0.x;
    _C.y = 3.0*_C1.y - 3.0*_C0.y;
    
    _D = _C0;
}



- (CGFloat)outputXAtT:(CGFloat)t {
    return ((_A.x*t+_B.x)*t+_C.x)*t+_D.x;
}

- (CGFloat)outputYAtT:(CGFloat)t {
    return ((_A.y*t+_B.y)*t+_C.y)*t+_D.y;
}

- (CGPoint)outputAtT:(CGFloat)t {
    return CGPointMake(((_A.x*t+_B.x)*t+_C.x)*t+_D.x, ((_A.y*t+_B.y)*t+_C.y)*t+_D.y);
}

- (CGFloat)tangentAngleAtT:(CGFloat)t {
    CGFloat dxdt = 3.0*_A.x*t*t + 2.0*_B.x*t + _C.x;
    CGFloat dydt = 3.0*_A.y*t*t + 2.0*_B.y*t + _C.y;
    
    return atan2(dydt, dxdt);
}

- (void)addToBezierPath:(UIBezierPath*)bezierPath {
    [bezierPath moveToPoint:_C0];
    [bezierPath addCurveToPoint:_C3 controlPoint1:_C1 controlPoint2:_C2];
}

- (UIBezierPath*)bezierPath {
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    [self addToBezierPath:bezierPath];
    return bezierPath;
}





@end
