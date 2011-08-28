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

// This class runs in the background. It has an Indicator sitting in the
// user's panel. It initializes everything and guarantees that there is
// only one instance of Gnome-Pie running.
	
public class Deamon : GLib.Application {

    private Indicator indicator = null;

    public static int main(string[] args) {
        var deamon = new GnomePie.Deamon(args);
        
        deamon.run(args);
        
        return 0;
    }

    public Deamon(string[] args) {
        Gtk.init(ref args);
    
        GLib.Object(application_id : "org.gnome.gnomepie", 
                             flags : GLib.ApplicationFlags.HANDLES_COMMAND_LINE);
        
        this.command_line.connect(this.start);
    }
    
    private int start(GLib.ApplicationCommandLine line) {
        
        if (this.indicator == null) {
            // if this is called for the first instance
            // init toolkits and static stuff
            Logger.init();
            Paths.init();
            Gdk.threads_init();
            ActionRegistry.init();
            GroupRegistry.init();
            
            // check for thread support
            if (!Thread.supported())
                error("Cannot run without thread support.");
        
            // init locale support
            Intl.bindtextdomain ("gnomepie", Paths.locales);
            Intl.textdomain ("gnomepie");
            
            // launch the indicator
            indicator = new Indicator();
            
            // load all Pies
            var manager = new PieManager();
            manager.load_config();

            // connect SigHandlers
            Posix.signal(Posix.SIGINT, sig_handler);
		    Posix.signal(Posix.SIGTERM, sig_handler);
		
		    // finished loading!
		    message("Started happily...");
		
		    Gtk.main();
		    
		} else {
		    var args = line.get_arguments();
		    
		    if (args.length > 2) {
		        if (args[1] == "-o" || args[1] == "--open")
		            PieManager.open_pie(args[2]);
		        else
		            warning("Unknown flag \"" + args[1] + "\" passed!");
		    } else {
		        this.indicator.show_preferences();
		    } 
		}
		
		return 0;
    }
    
    private static void sig_handler(int sig) {
        stdout.printf("\n");
		message("Caught signal (%d), bye!".printf(sig));
		Gtk.main_quit();
	}
}

}
