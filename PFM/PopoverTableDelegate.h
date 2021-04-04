//
//  PopoverTableDelegate.h
//  PFM
//
//  Created by Metehan Karabiber on 30/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@protocol PopoverTableDelegate <NSObject>

- (void) popoverSelected:(id)object source:(UIControl *)src;

@end