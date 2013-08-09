//
//  Mini_Bezel.m
//  Mini-Bezel
//
//  Created by Matt Beshara on 10/12/09.
//  Copyright Matt Beshara 2009. All rights reserved.
//
//  QS Interface template by Vacuous Virtuoso
//

#import "Mini_Bezel.h"

@implementation Mini_Bezel

- (id)init {
	return [self initWithWindowNibName:@"Mini_Bezel"];
}

- (void)windowDidLoad {
  standardRect = centerRectInRect([[self window] frame], [[NSScreen mainScreen] frame]);

  [super windowDidLoad];
  QSWindow *window = (QSWindow *)[self window];
  [window setLevel:kCGOverlayWindowLevel];
  [window setBackgroundColor:[NSColor clearColor]];

  [window setHideOffset:NSMakePoint(0, 0)];
  [window setShowOffset:NSMakePoint(0, 0)];

  [window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"QSExplodeEffect", @"transformFn", @"hide", @"type", [NSNumber numberWithFloat:0.15], @"duration", nil] forKey:kQSWindowExecEffect];
	[window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"hide", @"type", [NSNumber numberWithFloat:0.15], @"duration", nil] forKey:kQSWindowFadeEffect];
	[window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"QSVContractEffect", @"transformFn", @"hide", @"type", [NSNumber numberWithFloat:0.25], @"duration", nil, [NSNumber numberWithFloat:0.25] , @"brightnessB", @"QSStandardBrightBlending", @"brightnessFn", nil] forKey:kQSWindowCancelEffect];

  [(QSBezelBackgroundView *)[[self window] contentView] setRadius:22.0];
  [(QSBezelBackgroundView *)[[self window] contentView] setGlassStyle:QSGlossUpArc];

  [[self window] setFrame:standardRect display:YES];

  [[[self window] contentView] bind:@"color" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.QSAppearance1B" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
  [[self window] bind:@"hasShadow" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.QSBezelHasShadow" options:nil];
  [commandView bind:@"textColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.QSAppearance1T" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];

  [[self window] setMovableByWindowBackground:NO];
  [(QSWindow *)[self window] setFastShow:YES];

  NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
  for(id theControl in theControls) {
    QSObjectCell *theCell = [theControl cell];
    if ([theCell respondsToSelector:@selector(setNameFont:)]) [theCell setNameFont:[NSFont systemFontOfSize:11.0f]];
    [theCell setAlignment:NSCenterTextAlignment];
    if ([theControl respondsToSelector:@selector(setTextCellFont:)]) [theControl setTextCellFont:[NSFont systemFontOfSize:11.0f]];
    [theControl setPreferredEdge:NSMinYEdge];
    [theControl setResultsPadding:NSMinY([dSelector frame])];
    [theControl setPreferredEdge:NSMinYEdge];

    [(QSObjectCell *)theCell setShowDetails:NO];
    [(QSObjectCell *)theCell setTextColor:[NSColor whiteColor]];
    [(QSObjectCell *)theCell setState:NSOnState];

    [theCell bind:@"highlightColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.QSAppearance1A" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    [theCell bind:@"textColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.QSAppearance1T" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
   }

}

- (void)dealloc {
    if ([self isWindowLoaded]) {
        [[[self window] contentView] unbind:@"color"];
        [[self window] unbind:@"hasShadow"];
        [commandView unbind:@"textColor"];
        NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
        for(id theControl in theControls) {
            NSCell *theCell = [theControl cell];
            [theCell unbind:@"highlightColor"];
            [theCell unbind:@"textColor"];
            [(QSObjectCell *)theCell setTextColor:nil];
            [(QSObjectCell *)theCell setHighlightColor:nil];
        }
    }
	[super dealloc];
}

- (NSSize) maxIconSize {
	return NSMakeSize(128, 128);
}

- (void)showMainWindow:(id)sender {
	[[self window] setFrame:[self rectForState:[self expanded]]  display:YES];
	if ([[self window] isVisible]) [[self window] pulse:self];
	[super showMainWindow:sender];
	[[[self window] contentView] setNeedsDisplay:YES];
}

- (void)expandWindow:(id)sender {
	if (![self expanded])
		[[self window] setFrame:[self rectForState:YES] display:YES animate:YES];
	[super expandWindow:sender];
}
- (void)contractWindow:(id)sender {
	if ([self expanded])
		[[self window] setFrame:[self rectForState:NO] display:YES animate:YES];
	[super contractWindow:sender];
}

- (NSRect) rectForState:(BOOL)shouldExpand {
	NSRect newRect = standardRect;
	NSRect screenRect = [[NSScreen mainScreen] frame];
	if (!shouldExpand) {
		newRect.size.width -= NSMaxX([iSelector frame]) -NSMaxX([aSelector frame]);
		newRect = centerRectInRect(newRect, [[NSScreen mainScreen] frame]);
	}
	return NSOffsetRect(centerRectInRect(newRect, screenRect), 0, NSHeight(screenRect) /8);
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
	return NSOffsetRect(NSInsetRect(rect, 8, 0), 0, -21);
}

@end
