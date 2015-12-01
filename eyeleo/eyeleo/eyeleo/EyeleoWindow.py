# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
### BEGIN LICENSE
# This file is in the public domain
### END LICENSE
import time
import gettext
from gettext import gettext as _
from eyeleo.ReminderDialog import ReminderDialog
gettext.textdomain('eyeleo')

from gi.repository import Gtk # pylint: disable=E0611
import logging

logger = logging.getLogger('eyeleo')

from eyeleo_lib import Window

# See eyeleo_lib.Window.py for more details about how this class works
class EyeleoWindow(Window):
	__gtype_name__ = "EyeleoWindow"
	
	def finish_initializing(self, builder): # pylint: disable=E1002
		"""Set up the main window"""
		super(EyeleoWindow, self).finish_initializing(builder)

		# self.AboutDialog = AboutEyeleoDialog
		# self.PreferencesDialog = PreferencesEyeleoDialog

	def on_button1_clicked(self, data=None):
		period = int(self.ui.timeselect.get_active_text()[0:3])
		import subprocess
		subprocess.call("wmctrl -k on", shell=True)
		while(True):
			time.sleep(period * 60)
			popup = ReminderDialog()
			running = popup.run()
			if (popup != None):
				popup.destroy()