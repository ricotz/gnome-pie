/* 
Copyright (c) 2011 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

namespace GnomePie {

// This type of Action "presses" a key stroke.

public class KeyAction : Action {

    public static void register(out string name, out bool icon_name_editable, out string settings_name) {
        name = _("Press key stroke");
        icon_name_editable = true;
        settings_name = "key";
    }   
    
    public override string real_command { get; construct set; }
    public override string display_command { get {return key.label;} }
    	
    public Key key { get; set; }

    public KeyAction(string name, string icon, string command, bool is_quick_action = false) {
        GLib.Object(name : name, icon : icon, real_command : command, is_quick_action : is_quick_action);
    }
    
    construct {
        this.key = new Key(real_command);
    }

    public override void activate() {
        key.press();
    }
}

}
