# Introduction #

The COMODOD Firewall is one of the most popular free firewall solutions provided for the different editions of Microsoft Windows. While Windows Vista as well as Windows 7 provide a very comfortable software firewall, Windows XP definitely lacks a better alternative. While some may argue that a software firewall won't be very effective it may provite basic protection against random programs trying to connect to the internet (or other network ressources) without asking the user first.

While the scope and possibilities of COMODO's firewall increased over the last few years they also included more and more protection/security features that may have a negative impact on applications and games such as Hedgewars. We had multiple users who suffered the game crashing right on startup. While we don't want to blame COMODO for this (I've been using their product for years as well) it seems like the firewall package can be the reason for these issues (confirmed by several people). We're still not sure what the exact reason for those crashes is, however it seems to be possible to circumvent the issues without having to uninstall the personal firewall. The following step-by-step instructions have been tested on a fresh installation of Windows Vista (32 bit) with nothing installed except the COMODO Firewall and Hedgewars 0.9.13. Before Hedgewars crashed with different errors, especially when running a low RAM configuration (512 MB RAM).


# Step-by-step #

  1. Open the firewall's control panel using the desktop icon or the systray icon (doubleclick the small shield icon next to the task bar clock).
  1. Click on "Firewall" in the top navigation bar.
  1. Select "Common Tasks" on the left pane under "Firewall Tasks".
  1. Click on "Define a New Trusted Application".
  1. In the new window click on "Select >" and pick "Browse..."
  1. Locate the "bin" sub folder within your Hedgewars installation folder and select "hedgewars.exe"
  1. Close the window using "Apply".
  1. Repeat the steps 4-7 with "hwengine.exe" as well as "hedgewars-server.exe"
  1. Click on "Defense+" in the top navigation bar.
  1. Click "Advanced" on the left pane under "Defense+ Tasks".
  1. Click "Computer Security Policy" to open a new window.
  1. On the right side of the window click "Add...".
  1. Click on "Select >", then "Browse..." and pick "hedgewars.exe" again.
  1. Make sure to tick "Use a Predefined Policy" and select the policy "Trusted Application".
  1. Hit "Apply" to close the window.
  1. Repeat steps 12-15 and add "hwengine.exe" and "hedgewars-server.exe" the same way.
  1. Hit "Apply" to close the window.
  1. If you're running a slower PC and/or you've got 1 GB RAM or less, click on the "Sandbox" button on the left pane and then select "Sandbox Settings".
  1. Use the slider control to disable the Sandbox.
  1. Click on "OK" and close all remaining windows.
  1. Hedgewars should now run properly.

Note: Some users reported similar crashing issues happening only on x64 versions of Windows. Any experiences or reports (or even better solutions! ;)) are welcome as we're lacking the hardware and staff to test all possible hardware/software combinations.