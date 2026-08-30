// KnucklsOS layout: Windows 11-style bottom panel with CENTERED icons.
// Applied via the look-and-feel (plasma-lookandfeel-tool --apply).

var shell = panelById(1);
if (shell) {
    shell.remove();
}

// Bottom panel, full width, Win11 height
var panel = new Panel();
panel.height = 46;
panel.location = "bottom";
panel.alignment = "center";   // Win11: centered taskbar
panel.lengthMode = "fit";      // fit content (so it centers nicely)

// Application launcher (Start button) on the left of the centered group
var launcher = panel.addWidget("org.kde.plasma.kicker");
launcher.currentConfigGroup = ["General"];
launcher.writeConfig("icon", "start-here-kde");

// Task manager (open windows) - centered
var tasks = panel.addWidget("org.kde.plasma.taskmanager");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("groupPopups", false);
tasks.writeConfig("showOnlyCurrentScreen", true);
tasks.writeConfig("maximizedWindowsCanCover", true);

// A spacer to keep things centered
var spacerL = panel.addWidget("org.kde.plasma.futurespacer");
var spacerR = panel.addWidget("org.kde.plasma.futurespacer");

// System tray on the right
var tray = panel.addWidget("org.kde.plasma.systemtray");
tray.currentConfigGroup = ["General"];
tray.writeConfig("showAlignment", "right");

// Clock + show desktop on the far right
var clock = panel.addWidget("org.kde.plasma.digital-clock");
var showdesktop = panel.addWidget("org.kde.plasma.showdesktop");
