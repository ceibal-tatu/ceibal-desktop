# Copyright (C) 2009 One Laptop Per Child
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
import subprocess
import os
import logging

ACTIVE_DESKTOP_FILE = os.environ['HOME']+'/.olpc-active-desktop'

def _do_switch(target):
    try:
    	fd= open (ACTIVE_DESKTOP_FILE, 'w')
    	fd.write(target)
    	fd.close()
    except IOError, e:
        logging.error('Exception: %s', e)
         	
    if target == 'gnome':
        os.system("dbus-send --system --type=method_call --print-reply --dest=org.freedesktop.Accounts /org/freedesktop/Accounts/User$UID org.freedesktop.Accounts.User.SetXSession string:gnome-classic > /dev/null 2>&1")
        import jarabe.desktop.homewindow
        from jarabe.model.session import get_session_manager
        home_window = jarabe.desktop.homewindow.get_instance()
        home_window.busy_during_delayed_action(get_session_manager().logout)

def switch_to_gnome():
    _do_switch("gnome")

def undo_switch():
    _do_switch("sugar")

def get_active_desktop():
    desktop = 'sugar'
    try:
    	fd = open (ACTIVE_DESKTOP_FILE,'r')
    	desktop = fd.read().strip()
    	fd.close()
    except IOError, e:
	if e.errno != 2:
		desktop = 'unknown'
    if desktop == 'sugar':
	return 'Sugar'
    elif desktop == 'gnome':
	return 'GNOME'
    else:
	return 'Unknown' 
			

