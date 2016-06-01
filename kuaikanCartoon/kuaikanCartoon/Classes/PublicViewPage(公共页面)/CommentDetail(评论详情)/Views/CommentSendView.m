//
//  CommentSendView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentSendView.h"
#import "UIView+Extension.h"
#import <Masonry.h>
#import "CommonMacro.h"

@interface CommentSendView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *meassageTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end

static NSString * const contentSizeKeyPath = @"contentSize";

@implementation CommentSendView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == (__bridge void * _Nullable)(self)) {
        
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        [self updateHeightWithContentSizeHeight:size.height];
    }
    
}

- (void)updateHeightWithContentSizeHeight:(CGFloat)h {
    
    NSInteger numberofline = 5;
    CGFloat maxH = self.meassageTextView.font.lineHeight * numberofline;
    
    if (h > maxH) h = maxH;
    if (h < bottomBarHeight) h = bottomBarHeight;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (void)awakeFromNib {
    [self.meassageTextView cornerRadius:5];
    [self.meassageTextView addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    [self.meassageTextView setDelegate:self];
}

- (void)dealloc {
    [self.meassageTextView removeObserver:self forKeyPath:contentSizeKeyPath];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeLabel.hidden = textView.text.length > 0;
}

+ (instancetype)makeCommentSendView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentSendView" owner:nil options:nil] firstObject];
}

- (IBAction)sendMessage:(id)sender {
    if (self.meassageTextView.text.length < 1) return;
    
    if (self.sendMessage) {
        self.sendMessage(self.meassageTextView.text);
    }
}

- (void)clearText {
     self.meassageTextView.text = nil;
    [self textViewDidChange:self.meassageTextView];
    [self updateHeightWithContentSizeHeight:self.meassageTextView.contentSize.height];
}

- (BOOL)becomeFirstResponder {
    return [self.meassageTextView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.meassageTextView resignFirstResponder];
}

@end
