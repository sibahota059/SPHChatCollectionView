//
//  SPHCollectionViewself.m
//  ChupaChat
//
//  Created by Siba Prasad Hota on 30/05/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import "SPHCollectionViewcell.h"

#import "SPHTextBubbleView.h"
#import "SPHImageBubbleView.h"
#import "iosMacroDefine.h"










@implementation SPHCollectionViewcell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFeedData:(SPH_PARAM_List *)feed_data
{
    if ([feed_data.chat_media_type isEqualToString:kSTextByme])
    {
        SPHTextBubbleView *textMessageBubble =
        [[SPHTextBubbleView alloc] initWithText:feed_data.chat_message
                                      withColor:GREEN_TEXT_BUBBLE_COLOR
                             withHighlightColor:[UIColor whiteColor]
                              withTailDirection:MessageBubbleViewButtonTailDirectionRight
                                       maxWidth:MAX_BUBBLE_WIDTH];
        
        [textMessageBubble sizeToFit];
        textMessageBubble.frame = CGRectMake(265-textMessageBubble.frame.size.width,0, textMessageBubble.frame.size.width, textMessageBubble.frame.size.height);
        [self.contentView addSubview:textMessageBubble];
        
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, 55, 20)];
        timeLabel.text=feed_data.chat_date_time;
        timeLabel.font=[UIFont systemFontOfSize:9];
        timeLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:timeLabel];
        
        
        
        if ([feed_data.chat_send_status isEqualToString:kSending])
        {
            UIActivityIndicatorView *myIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [myIndicator setFrame:CGRectMake(0,self.frame.size.height-50,20, 20)];
            [myIndicator startAnimating];
            [self.contentView addSubview:myIndicator];
        }
        else
        {
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50,16, 16)];
            if ([feed_data.chat_send_status isEqualToString:kSent])
                [imgView setImage:[UIImage imageNamed:@"sentSucess"]];
            else
                [imgView setImage:[UIImage imageNamed:@"sentFailed"]];//sentFailed
            
            [self.contentView addSubview:imgView];
        }
        
        
        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(265, self.frame.size.height-50, 40, 40)];
        [AvatarView setImage:[UIImage imageNamed:@"person"]];
        
        AvatarView.layer.cornerRadius = 20.0;
        AvatarView.layer.masksToBounds = YES;
        AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
        AvatarView.layer.borderWidth = 2.0;
        [self.contentView addSubview:AvatarView];
    }
    else
        if ([feed_data.chat_media_type isEqualToString:kSTextByOther])
        {
            SPHTextBubbleView *textMessageBubble =
            [[SPHTextBubbleView alloc] initWithText:feed_data.chat_message
                                          withColor:LIGHT_GRAY_TEXT_BUBBLE_COLOR
                                 withHighlightColor:[UIColor blackColor]
                                  withTailDirection:MessageBubbleViewButtonTailDirectionLeft
                                           maxWidth:MAX_BUBBLE_WIDTH];
            
            [textMessageBubble sizeToFit];
            textMessageBubble.frame = CGRectMake(40,0, textMessageBubble.frame.size.width, textMessageBubble.frame.size.height);
            [self.contentView addSubview:textMessageBubble];
            
            UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, self.frame.size.height-30, 55, 20)];
            timeLabel.text=feed_data.chat_date_time;
            timeLabel.font=[UIFont systemFontOfSize:9];
            timeLabel.textColor=[UIColor blackColor];
            [self.contentView addSubview:timeLabel];
            
            
            UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, 40, 40)];
            AvatarView.layer.cornerRadius = 20.0;
            AvatarView.layer.masksToBounds = YES;
            AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
            AvatarView.layer.borderWidth = 2.0;
            [AvatarView setImage:[UIImage imageNamed:@"BlankUser.jpg"]];
            [self.contentView addSubview:AvatarView];
            
            
        }
        else
            if ([feed_data.chat_media_type isEqualToString:kSImagebyme])
            {
                SPHImageBubbleView *flowerImageBubbleView =
                [[SPHImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"picture"] withTailDirection:MessageBubbleViewTailDirectionRight atSize:IMAGE_SIZE];
                
                [flowerImageBubbleView sizeToFit];
                flowerImageBubbleView.frame = CGRectMake(170,0, 90, 90);
                
                [self.contentView addSubview:flowerImageBubbleView];
                
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, 55, 20)];
                timeLabel.text=feed_data.chat_date_time;
                timeLabel.font=[UIFont systemFontOfSize:9];
                timeLabel.textColor=[UIColor blackColor];
                [self.contentView addSubview:timeLabel];
                
                
                
                if ([feed_data.chat_send_status isEqualToString:kSending])
                {
                    UIActivityIndicatorView *myIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [myIndicator setFrame:CGRectMake(0,self.frame.size.height-50,20, 20)];
                    [myIndicator startAnimating];
                    [self.contentView addSubview:myIndicator];
                }
                else
                {
                    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50,16, 16)];
                    if ([feed_data.chat_send_status isEqualToString:kSent])
                        [imgView setImage:[UIImage imageNamed:@"sentSucess"]];
                    else
                        [imgView setImage:[UIImage imageNamed:@"sentFailed"]];//sentFailed
                    
                    [self.contentView addSubview:imgView];
                }
                
                
                
                UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(265, self.frame.size.height-50, 40, 40)];
                AvatarView.layer.cornerRadius = 20.0;
                AvatarView.layer.masksToBounds = YES;
                AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
                AvatarView.layer.borderWidth = 2.0;
                [AvatarView setImage:[UIImage imageNamed:@"person"]];
                [self.contentView addSubview:AvatarView];
            }
            else
            {
                SPHImageBubbleView *flowerImageBubbleView =
                [[SPHImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"app22"] withTailDirection:MessageBubbleViewTailDirectionLeft atSize:IMAGE_SIZE];
                
                [flowerImageBubbleView sizeToFit];
                flowerImageBubbleView.frame = CGRectMake(40,0, 90, 90);
                
                [self.contentView addSubview:flowerImageBubbleView];
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, self.frame.size.height-30, 55, 20)];
                timeLabel.text=feed_data.chat_date_time;
                timeLabel.font=[UIFont systemFontOfSize:9];
                timeLabel.textColor=[UIColor blackColor];
                [self.contentView addSubview:timeLabel];
                
                
                UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, 40, 40)];
                AvatarView.layer.cornerRadius = 20.0;
                AvatarView.layer.masksToBounds = YES;
                AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
                AvatarView.layer.borderWidth = 2.0;
                [AvatarView setImage:[UIImage imageNamed:@"BlankUser.jpg"]];
                [self.contentView addSubview:AvatarView];
                
            }
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
   
    // Initialization code
}


@end
