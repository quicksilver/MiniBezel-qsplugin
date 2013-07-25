//
//  Mini_Bezel.h
//  Mini-Bezel
//
//  Created by Matt Beshara on 10/12/09.
//  Copyright Matt Beshara 2009. All rights reserved.
//
//  QS Interface template by Vacuous Virtuoso
//

@interface Mini_Bezel : QSResizingInterfaceController
{
  NSRect standardRect;
}
- (NSRect) rectForState:(BOOL)expanded;
@end
