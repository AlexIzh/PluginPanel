PluginPanel
===========
Plugin for Xcode! You can add your plugin to this panel and you should not care about ui in Xcode! It looks like left panel(tree of files, breakpoints etc).
Xcode 6+ only.

[Example of use](https://github.com/AlexIzh/TimePlugin)

![PC_ss01.png](https://dl.dropboxusercontent.com/u/52596119/Screen%20Shot%202015-04-14%20at%202.14.56%20AM.png)
![PC_ss02.png](https://dl.dropboxusercontent.com/u/52596119/Screen%20Shot%202015-04-14%20at%202.14.51%20AM.png)

## Installation
Build this plugin, then the plugin will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`.  
Relaunch Xcode and PluginPanel will make your life easier.

## Usage
1. Install this plugin to Xcode.
2. Move `PluginPanelClient` folder to your plugin Xcode project. 
3. Start observe `PluginPanelDidLoadedWindowNotification` notification when `init` is called in your plugin
4. Create your main `NSViewController` 
5. Set image and your view controller to `DVTChoice`
6. Call `PluginPanelAddPlugin` function with `DVTChoice` object and window from notification (notification.userInfo[PluginPanelWindowNotificationKey])
7. Build your plugin and see result!

Please, see example (`panelDidLoadNote` method for creation `DVTChoice`)

Example usage:

     + (void)pluginDidLoad:(NSBundle *)plugin {
         static id sharedPlugin = nil;
         static dispatch_once_t onceToken;
         dispatch_once(&onceToken, ^{
             sharedPlugin = [[self alloc] init];
         });
     }

     - (id)init {
         if (self = [super init]) {
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panelDidLoadNote:) name:PluginPanelDidLoadedWindowNotification object:nil];
         }
         return self;
     }

    - (void)panelDidLoadNote:(NSNotification *)note {
        static NSImage *image = nil;
        if (!image) {
             image  = [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForImageResource:@"plugin_icon"]];
         }
         TPViewController *c = [[TPViewController alloc] initWithNibName:@"TPView" bundle:[NSBundle bundleForClass:self.class]];
         c.mainWindow = [note.userInfo objectForKey:PluginPanelWindowNotificationKey];
         DVTChoice *choice = [[NSClassFromString(@"DVTChoice") alloc] initWithTitle:@"Time" toolTip:@"Time management plugin" image:image representedObject:c];
         PluginPanelAddPlugin(choice, [[note userInfo] objectForKey:PluginPanelWindowNotificationKey]);
     }


## License
*TimePlugin* is released under the **MIT License**, see *LICENSE.txt*.
