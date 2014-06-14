//
//  SPHTextBubbleView.h
//  ChupaChat
//
//  Created by Siba Prasad Hota on 14/06/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHTextBubbleView : UIView


typedef enum
{
    MessageBubbleViewButtonTailDirectionRight = 0,
    MessageBubbleViewButtonTailDirectionLeft = 1
} MessageBubbleViewButtonTailDirection;

- (id)initWithText:(NSString *) text
         withColor:(UIColor *) color
withHighlightColor:(UIColor *) highlightColor
 withTailDirection:(MessageBubbleViewButtonTailDirection)tailDirection
          maxWidth:(CGFloat) maxWidth;



@end
