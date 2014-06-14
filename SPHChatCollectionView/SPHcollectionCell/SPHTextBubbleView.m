//
//  SPHTextBubbleView.m
//  ChupaChat
//
//  Created by Siba Prasad Hota on 14/06/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import "SPHTextBubbleView.h"

#import "UIImage+Utils.h"

#define IMAGE_INSETS UIEdgeInsetsMake(13, 13, 13, 21)

#define RIGHT_CONTENT_INSETS UIEdgeInsetsMake(8, 13, 8, 21)
#define LEFT_CONTENT_INSETS UIEdgeInsetsMake(8, 21, 8, 13)



static const float kBubbleTextSize = 14.0f;

@interface SPHTextBubbleView ()

{
    int x;
}
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, retain) UIImageView *bubbleImageView;
@property (nonatomic, retain) UITextView *myMessageTextView;
@property (nonatomic, assign) CGFloat maxWidth;
@property(nonatomic,assign)NSString *textMessage;
@end


@implementation SPHTextBubbleView

- (id)initWithText:(NSString *) text
         withColor:(UIColor *) color
withHighlightColor:(UIColor *) highlightColor
 withTailDirection:(MessageBubbleViewButtonTailDirection)tailDirection
          maxWidth:(CGFloat) maxWidth
{
    if (self = [super init])
    {
        self.textMessage=text;
        
        UIEdgeInsets imageInsets = IMAGE_INSETS;
        UIImageOrientation bubbleOrientation;
        _maxWidth = maxWidth;
         x=2;
        if (tailDirection == MessageBubbleViewButtonTailDirectionLeft)
        {
            x=7;
            self.contentInsets = LEFT_CONTENT_INSETS;
            bubbleOrientation =UIImageOrientationUpMirrored;
        }
        else
        {
            self.contentInsets = RIGHT_CONTENT_INSETS;
            bubbleOrientation =UIImageOrientationUp;
        }
        
        UIImage *coloredImage = [[UIImage imageNamed:@"ImageBubbleMask~iphone"] maskWithColor:color];
        UIImage *backgroundImageNormal = [[UIImage imageWithCGImage:coloredImage.CGImage
                                                              scale:1.0 orientation: bubbleOrientation] resizableImageWithCapInsets:imageInsets resizingMode:UIImageResizingModeStretch];
        
        
        _bubbleImageView = [[UIImageView alloc] initWithImage:backgroundImageNormal];
         _bubbleImageView.frame = self.frame;
         [self addSubview:_bubbleImageView];
        
     
        
        _myMessageTextView=[[UITextView alloc]initWithFrame:self.frame];
        _myMessageTextView.text=text;
        _myMessageTextView.backgroundColor=[UIColor clearColor];
         _myMessageTextView.textColor=highlightColor;
        _myMessageTextView.editable=NO;
        _myMessageTextView.scrollEnabled=NO;
        _myMessageTextView.dataDetectorTypes=UIDataDetectorTypeAll;
        _myMessageTextView.font = [UIFont systemFontOfSize:kBubbleTextSize];
        _myMessageTextView.textAlignment=NSTextAlignmentJustified;
        [self addSubview:_myMessageTextView];
        self.backgroundColor = UIColor.clearColor;
        
           [self autoresizesSubviews];
    }
    return self;
}

UIEdgeInsets UIEdgeInsetsNegate(UIEdgeInsets insets)
{
    return UIEdgeInsetsMake(-insets.top , -insets.left, -insets.bottom, -insets.right );
}


- (void) sizeToFit
{
    [super sizeToFit];
    self.frame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsNegate(self.contentInsets));
    self.bubbleImageView.frame = self.bounds;
    CGRect frm=self.bubbleImageView.frame;
    frm.size.width-=10;
    frm.origin.x+=x;
    self.myMessageTextView.frame = frm;
    
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.textSize;
}

- (CGSize) textSize
{
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:self.textMessage];
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:aString];
    CGRect textRect = [calculationView.text boundingRectWithSize: CGSizeMake(self.maxWidth- self.contentInsets.left - self.contentInsets.right, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
    
    return CGSizeMake(textRect.size.width+20,textRect.size.height+10);
}

@end


