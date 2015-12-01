# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
### BEGIN LICENSE
# This file is in the public domain
### END LICENSE

import gettext
from gettext import gettext as _
gettext.textdomain('eyeleo')

import logging
logger = logging.getLogger('eyeleo')

from eyeleo_lib.AboutDialog import AboutDialog

# See eyeleo_lib.AboutDialog.py for more details about how this class works.
class AboutEyeleoDialog(AboutDialog):
    __gtype_name__ = "AboutEyeleoDialog"
    
    def finish_initializing(self, builder): # pylint: disable=E1002
        """Set up the about dialog"""
        super(AboutEyeleoDialog, self).finish_initializing(builder)

        # Code for other initialization actions should be added here.

