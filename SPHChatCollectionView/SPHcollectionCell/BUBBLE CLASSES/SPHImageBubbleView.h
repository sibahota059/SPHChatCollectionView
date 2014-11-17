//
//  SPHImageBubbleView.h
//  ChupaChat
//
//  Created by Siba Prasad Hota on 14/06/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHImageBubbleView : UIView
typedef enum
{
    MessageBubbleViewTailDirectionRight = 0,
    MessageBubbleViewTailDirectionLeft = 1
} MessageBubbleViewTailDirection;

- (id)initWithText:(NSString *) text
         withColor:(UIColor *) color
withHighlightColor:(UIColor *) highlightColor
 withTailDirection:(MessageBubbleViewTailDirection) tailDirection;

- (id) initWithImage:(UIImage *) image
   withTailDirection:(MessageBubbleViewTailDirection) tailDirection
              atSize:(CGSize) size;
@end
