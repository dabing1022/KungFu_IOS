//
//  CATextLayerTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/3.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "CATextLayerTestViewController.h"
#import <CoreText/CoreText.h>

@interface CATextLayerTestViewController ()

@property (nonatomic, strong) UIView* labelView;

@end

@implementation CATextLayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 200, 350)];
    [self.view addSubview:_labelView];
    
    CATextLayer* textLayer = [CATextLayer layer];
    textLayer.frame = _labelView.bounds;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [_labelView.layer addSublayer:textLayer];

    UIFont* font = [UIFont systemFontOfSize:15];
    CGFloat fontSize = font.pointSize;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    
    NSString* text = @"习近平强调，中英两国都是世界上有影响的大国，拥有广泛共同利益，肩负着促进世界和平与发展的重要责任。目前，中英关系很好，中英全面战略伙伴关系正在驶入发展的快车道。双方贸易额已经超过800亿美元，英国也是中国投资主要目的国，两国在金融、核电、高铁等领域合作不断取得新进展。今年是中英文化交流年，中英是东西方文明的重要代表，两国加强交流合作必将为世界文明进步作出积极贡献。";

    // 1. plain string
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    textLayer.font = fontRef;
//    textLayer.fontSize = fontSize;
//    textLayer.string = text;
    
    // 2. attributed string
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:text];
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    NSDictionary* attribs = @{ (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor whiteColor].CGColor,
                               (__bridge id)kCTFontAttributeName:(__bridge id)fontRef };
    [string setAttributes:attribs range:NSMakeRange(0, text.length)];

    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName:@(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    CFRelease(fontRef);
    
    textLayer.string = string;
}

@end
