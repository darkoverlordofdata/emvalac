/**
 * adriac - valac wrapper to compile Compact Vala
 * 
 * adriac is a reference to Adria, daughter of Vala Mal Doran (SG-1).
 *
 * Copyright (C) 2017  bruce davidson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * breaks valac into 2 steps with pre/post processing
 * 
 * 1 copy src out of tree
 * 2 preprocess vala
 * 3 run valac to generate c code
 * 4 preprocess c
 * 5 run emcc
 * 
 * preprocssing has to be done by a seprate script process
 * vala script does not include Gio, so no io...
 * besides, text processing is much easier in node.
 * 
 * Adds 1 new option:
 * --builddir=DIRECTORY
 * 		required location for out of tree build
 * 		no in tree builds allowed
 * 
 * use case: emscripten
 * 
 * 
 * using the command line interface described in valacompiler.vala
 * @see https://github.com/GNOME/vala/blob/master/compiler/valacompiler.vala 
 */

using GLib;

class Adriac {

	static StringBuilder valac;
	static StringBuilder cc;
	static StringBuilder vala_files;
	static StringBuilder c_files;

	static string plugin;
	static string builddir;
	static string basedir;
	static string directory;
	static bool version;
	static bool api_version;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] sources;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] vapi_directories;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] gir_directories;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] metadata_directories;
	static string vapi_filename;
	static string library;
	static string shared_library;
	static string gir;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] packages;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] fast_vapis;
	static string target_glib;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] gresources;

	static bool ccode_only;
	static string header_filename;
	static bool use_header;
	static string internal_header_filename;
	static string internal_vapi_filename;
	static string fast_vapi_filename;
	static bool vapi_comments;
	static string symbocmd_filename;
	static string includedir;
	static bool compile_only;
	static string output;
	static bool debug;
	static bool thread;
	static bool mem_profiler;
	static bool disable_assert;
	static bool enable_checking;
	static bool deprecated;
	static bool hide_internal;
	static bool experimental;
	static bool experimental_non_null;
	static bool gobject_tracing;
	static bool disable_since_check;
	static bool disable_warnings;
	static string cc_command;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] cc_options;
	static string pkg_config_command;
	static string dump_tree;
	static bool save_temps;
	[CCode (array_length = false, array_null_terminated = true)]
	static string[] defines;
	static bool quiet_mode;
	static bool verbose_mode;
	static string profile;
	static bool nostdpkg;
	static bool enable_version_header;
	static bool disable_version_header;
	static bool fatal_warnings;
	static bool disable_colored_output;
	static string dependencies;

	static string entry_point;

	static bool run_output;

	const OptionEntry[] options = {
		{ "builddir", 0, 0, OptionArg.FILENAME, ref builddir, "Out of tree location for build", "DIRECTORY" },
		
		{ "vapidir", 0, 0, OptionArg.FILENAME_ARRAY, ref vapi_directories, "Look for package bindings in DIRECTORY", "DIRECTORY..." },
		{ "girdir", 0, 0, OptionArg.FILENAME_ARRAY, ref gir_directories, "Look for .gir files in DIRECTORY", "DIRECTORY..." },
		{ "metadatadir", 0, 0, OptionArg.FILENAME_ARRAY, ref metadata_directories, "Look for GIR .metadata files in DIRECTORY", "DIRECTORY..." },
		{ "pkg", 0, 0, OptionArg.STRING_ARRAY, ref packages, "Include binding for PACKAGE", "PACKAGE..." },
		{ "vapi", 0, 0, OptionArg.FILENAME, ref vapi_filename, "Output VAPI file name", "FILE" },
		{ "library", 0, 0, OptionArg.STRING, ref library, "Library name", "NAME" },
		{ "shared-library", 0, 0, OptionArg.STRING, ref shared_library, "Shared library name used in generated gir", "NAME" },
		{ "gir", 0, 0, OptionArg.STRING, ref gir, "GObject-Introspection repository file name", "NAME-VERSION.gir" },
		{ "basedir", 'b', 0, OptionArg.FILENAME, ref basedir, "Base source directory", "DIRECTORY" },
		{ "directory", 'd', 0, OptionArg.FILENAME, ref directory, "Change output directory from current working directory", "DIRECTORY" },
		{ "version", 0, 0, OptionArg.NONE, ref version, "Display version number", null },
		{ "api-version", 0, 0, OptionArg.NONE, ref api_version, "Display API version number", null },
		{ "ccode", 'C', 0, OptionArg.NONE, ref ccode_only, "Output C code", null },
		{ "header", 'H', 0, OptionArg.FILENAME, ref header_filename, "Output C header file", "FILE" },
		{ "use-header", 0, 0, OptionArg.NONE, ref use_header, "Use C header file", null },
		{ "includedir", 0, 0, OptionArg.FILENAME, ref includedir, "Directory used to include the C header file", "DIRECTORY" },
		{ "internal-header", 'h', 0, OptionArg.FILENAME, ref internal_header_filename, "Output internal C header file", "FILE" },
		{ "internal-vapi", 0, 0, OptionArg.FILENAME, ref internal_vapi_filename, "Output vapi with internal api", "FILE" },
		{ "fast-vapi", 0, 0, OptionArg.STRING, ref fast_vapi_filename, "Output vapi without performing symbol resolution", null },
		{ "use-fast-vapi", 0, 0, OptionArg.STRING_ARRAY, ref fast_vapis, "Use --fast-vapi output during this compile", null },
		{ "vapi-comments", 0, 0, OptionArg.NONE, ref vapi_comments, "Include comments in generated vapi", null },
		{ "deps", 0, 0, OptionArg.STRING, ref dependencies, "Write make-style dependency information to this file", null },
		{ "symbols", 0, 0, OptionArg.FILENAME, ref symbocmd_filename, "Output symbols file", "FILE" },
		{ "compile", 'c', 0, OptionArg.NONE, ref compile_only, "Compile but do not link", null },
		{ "output", 'o', 0, OptionArg.FILENAME, ref output, "Place output in file FILE", "FILE" },
		{ "debug", 'g', 0, OptionArg.NONE, ref debug, "Produce debug information", null },
		{ "thread", 0, 0, OptionArg.NONE, ref thread, "Enable multithreading support (DEPRECATED AND IGNORED)", null },
		{ "enable-mem-profiler", 0, 0, OptionArg.NONE, ref mem_profiler, "Enable GLib memory profiler", null },
		{ "define", 'D', 0, OptionArg.STRING_ARRAY, ref defines, "Define SYMBOL", "SYMBOL..." },
		{ "main", 0, 0, OptionArg.STRING, ref entry_point, "Use SYMBOL as entry point", "SYMBOL..." },
		{ "nostdpkg", 0, 0, OptionArg.NONE, ref nostdpkg, "Do not include standard packages", null },
		{ "disable-assert", 0, 0, OptionArg.NONE, ref disable_assert, "Disable assertions", null },
		{ "enable-checking", 0, 0, OptionArg.NONE, ref enable_checking, "Enable additional run-time checks", null },
		{ "enable-deprecated", 0, 0, OptionArg.NONE, ref deprecated, "Enable deprecated features", null },
		{ "hide-internal", 0, 0, OptionArg.NONE, ref hide_internal, "Hide symbols marked as internal", null },
		{ "enable-experimental", 0, 0, OptionArg.NONE, ref experimental, "Enable experimental features", null },
		{ "disable-warnings", 0, 0, OptionArg.NONE, ref disable_warnings, "Disable warnings", null },
		{ "fatal-warnings", 0, 0, OptionArg.NONE, ref fatal_warnings, "Treat warnings as fatal", null },
		{ "disable-since-check", 0, 0, OptionArg.NONE, ref disable_since_check, "Do not check whether used symbols exist in local packages", null },
		{ "enable-experimental-non-null", 0, 0, OptionArg.NONE, ref experimental_non_null, "Enable experimental enhancements for non-null types", null },
		{ "enable-gobject-tracing", 0, 0, OptionArg.NONE, ref gobject_tracing, "Enable GObject creation tracing", null },
		{ "cc", 0, 0, OptionArg.STRING, ref cc_command, "Use COMMAND as C compiler command", "COMMAND" },
		{ "Xcc", 'X', 0, OptionArg.STRING_ARRAY, ref cc_options, "Pass OPTION to the C compiler", "OPTION..." },
		{ "pkg-config", 0, 0, OptionArg.STRING, ref pkg_config_command, "Use COMMAND as pkg-config command", "COMMAND" },
		{ "dump-tree", 0, 0, OptionArg.FILENAME, ref dump_tree, "Write code tree to FILE", "FILE" },
		{ "save-temps", 0, 0, OptionArg.NONE, ref save_temps, "Keep temporary files", null },
		{ "profile", 0, 0, OptionArg.STRING, ref profile, "Use the given profile instead of the default", "PROFILE" },
		{ "quiet", 'q', 0, OptionArg.NONE, ref quiet_mode, "Do not print messages to the console", null },
		{ "verbose", 'v', 0, OptionArg.NONE, ref verbose_mode, "Print additional messages to the console", null },
		{ "no-color", 0, 0, OptionArg.NONE, ref disable_colored_output, "Disable colored output, alias for --color=never", null },
		{ "target-glib", 0, 0, OptionArg.STRING, ref target_glib, "Target version of glib for code generation", "MAJOR.MINOR" },
		{ "gresources", 0, 0, OptionArg.STRING_ARRAY, ref gresources, "XML of gresources", "FILE..." },
		{ "enable-version-header", 0, 0, OptionArg.NONE, ref enable_version_header, "Write vala build version in generated files", null },
		{ "disable-version-header", 0, 0, OptionArg.NONE, ref disable_version_header, "Do not write vala build version in generated files", null },
		{ "", 0, 0, OptionArg.FILENAME_ARRAY, ref sources, null, "FILE..." },
		{ null }
	};


	static int main (string[] args) {

		try {
			var opt_context = new OptionContext ("- adriac");
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (options, null);
			opt_context.parse (ref args);
		} catch (OptionError e) {
			stdout.printf ("error: %s\n", e.message);
			stdout.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return 0;
		}

		if (version) {
			var SDK = getEnv("ZEROG");
			stdout.printf (@"adriac Beta 0.1.0 -- [$(SDK)]\n");
			return 0;
		}

		if (builddir == null) {
			stderr.printf ("In tree build not allowed.\n");
			return 1;
		}

		if (sources == null && fast_vapis == null) {
			stderr.printf ("No source file specified.\n");
			return 1;
		} 
		if (cc_command == null) {
			stderr.printf("no compiler specified");
			return 1;
		}
		build();
		/** Call the back end to do the work  */
		//  stdout.printf("=============================\n");
		//  stdout.printf(cc.str);
		//  stdout.printf("=============================\n");
		var SDK = getEnv("ZEROG");
		if (!spawn(@"cp -rfL src $(builddir)")) return 1;
		if (!spawn(@"$(SDK)/tools/pre-vala.coffee $(builddir) \"$(encodeURIComponent(vala_files.str))\"")) return 1;
		if (!spawn(@"$(SDK)/tools/pre-gs.coffee $(builddir) \"$(encodeURIComponent(vala_files.str))\"")) return 1;
		if (!spawn(@"$(SDK)/tools/proc \"$(encodeURIComponent(valac.str))\"")) return 1;
		if (!spawn(@"$(SDK)/tools/post.coffee $(builddir) \"$(encodeURIComponent(c_files.str))\"")) return 1;
		if (cc_command != "jni")
			if (!spawn(@"$(SDK)/tools/proc \"$(encodeURIComponent(cc.str))\"")) return 1;

		stdout.printf("adriac complete.\n");
		return 0;
	}

	/** 
	 * create the build commands - valac && emcc
	 * split out the corresponding parameters for each
	 */
	static void build() {
		valac = new StringBuilder("/usr/bin/valac ");
		cc = new StringBuilder(@"$(cc_command) ");
		if (cc_command == "clang" && output.index_of(".ll") != -1) {
			cc.append("-S -emit-llvm ");	
		}


		vala_files = new StringBuilder();
		c_files = new StringBuilder();

		valac.append("-C ");
		valac.append("--save-temps ");

		if (quiet_mode) valac.append("--quiet ");
		if (verbose_mode)  {
			valac.append("--verbose ");
			cc.append("-v ");
		}
		if (vapi_comments) valac.append("--vapi-comments ");
		if (compile_only) valac.append("--compile-only ");
		if (api_version) valac.append("--api-version ");
		if (use_header) valac.append("--use-header ");
		if (debug) valac.append("--debug ");
		if (thread) valac.append("--thread ");
		if (mem_profiler) valac.append("--enable-mem-profiler ");
		if (disable_assert) valac.append("--disable-assert ");
		if (enable_checking) valac.append("--enable-checking ");
		if (deprecated) valac.append("--enable-deprecated ");
		if (hide_internal) valac.append("--hide-internal ");
		if (experimental) valac.append("--enable-experimental ");
		if (experimental_non_null) valac.append("--enable-experimental-non-null ");
		if (gobject_tracing) valac.append("--enable-gobject-tracing ");
		if (disable_since_check) valac.append("--disable-since-check ");
		if (disable_warnings) valac.append("--disable-warnings ");
		if (nostdpkg) valac.append("--nostdpkg ");
		if (enable_version_header) valac.append("--enable-version-header ");
		if (disable_version_header) valac.append("--disable-version-header ");
		if (fatal_warnings) valac.append("--fatal-warnings ");
		if (disable_colored_output) valac.append("--no-color ");

		if (basedir != null) {
			valac.append("--basedir ");
			valac.append(basedir);
			valac.append(" ");
		}

		if (directory != null) {
			valac.append("--directory ");
			valac.append(directory);
			valac.append(" ");
		}

		if (vapi_directories != null) {
			foreach (var v in vapi_directories) {
				valac.append("--vapidir ");
				valac.append(v);
				valac.append(" ");
			}
		} 
		if (gir_directories != null) {
			foreach (var g in gir_directories) {
				valac.append("--girdir ");
				valac.append(g);
				valac.append(" ");
			}
		}
		if (metadata_directories != null) {
			foreach (var m in metadata_directories) {
				valac.append("--metadatadir ");
				valac.append(m);
				valac.append(" ");
			}
		}
		if (vapi_filename != null) {
			valac.append("--vapi ");
			valac.append(vapi_filename);
			valac.append(" ");
		}

		if (library != null) {
			valac.append("--library ");
			valac.append(library);
			valac.append(" ");
		}
		if (shared_library != null) {
			valac.append("--shared-library ");
			valac.append(shared_library);
			valac.append(" ");
		}
		if (gir != null) {
			valac.append("--gir ");
			valac.append(gir);
			valac.append(" ");
		}
		if (fast_vapis != null) {
			foreach (var f in fast_vapis) {
				valac.append("--fast-vapi ");
				valac.append(f);
				valac.append(" ");
			}
		}
		if (target_glib != null) {
			valac.append("--target-glib ");
			valac.append(target_glib);
			valac.append(" ");
		}
		if (gresources != null) {
			foreach (var g in gresources) {
				valac.append("--gresources ");
				valac.append(g);
				valac.append(" ");
			}
		}
		if (header_filename != null) {
			valac.append("--header-filename ");
			valac.append(header_filename);
			valac.append(" ");
		}
		if (internal_header_filename != null) {
			valac.append("--internal-header ");
			valac.append(internal_header_filename);
			valac.append(" ");
		}
		if (internal_vapi_filename != null) {
			valac.append("--internal-vapi ");
			valac.append(internal_vapi_filename);
			valac.append(" ");
		}
		if (fast_vapi_filename != null) {
			valac.append("--fast-vapi ");
			valac.append(fast_vapi_filename);
			valac.append(" ");
		}
		if (symbocmd_filename != null) {
			valac.append("--symbols ");
			valac.append(symbocmd_filename);
			valac.append(" ");
		}
		if (includedir != null) {
			valac.append("--includedir ");
			valac.append(includedir);
			valac.append(" ");
		}
		if (pkg_config_command != null) {
			valac.append("--pkg-config ");
			valac.append(pkg_config_command);
			valac.append(" ");
		}
		if (dump_tree != null) {
			valac.append("--dump-tree ");
			valac.append(dump_tree);
			valac.append(" ");
		}
		if (defines != null) {
			foreach (var d in defines) {
				valac.append("--define ");
				valac.append(d);
				valac.append(" ");
			}
		}
		if (profile != null) {
			valac.append("--profile ");
			valac.append(profile);
			valac.append(" ");
		}

		if (packages != null) {
			foreach (var p in packages) {
				valac.append("--pkg ");
				valac.append(p);
				valac.append(" ");
				switch (p) {

					case "sdl2":
						if (cc_command == "emcc") {
							cc.append("-s USE_SDL=2 " );
						}
						break;

					case "SDL2_image":
						if (cc_command == "emcc") {
							cc.append("-s USE_SDL_IMAGE=2 ");
							cc.append("-s SDL2_IMAGE_FORMATS='[\"png\"]' ");
						}
						break;

					case "SDL2_ttf":
						if (cc_command == "emcc") {
							cc.append("-s USE_SDL_TTF=2 ");
						}
						break;

                    case "emscripten":
						if (cc_command == "emcc") {
							//  cc.append("-s ALLOW_MEMORY_GROWTH=1 ");
							//  cc.append("-s TOTAL_MEMORY=16777216 "); // 16mb
							cc.append("-s TOTAL_MEMORY=33554432 "); // 32 mb
							//  cc.append("-s TOTAL_MEMORY=268435456 "); // 256mb mobile max?
							//  cc.append("-s TOTAL_MEMORY=536870912 "); // 512mb desktop max?
							cc.append("-s WASM=1 ");
							cc.append("-s ASSERTIONS=1 ");
							cc.append("-s EXPORTED_FUNCTIONS='[\"_game\"]' ");
							cc.append("--preload-file assets ");
						}
						break;
				}
			}
		}
		if (output != null) {
			cc.append("-o ");
			cc.append(output);
			cc.append(" ");
		}
		if (cc_options != null) {
			foreach (var o in cc_options) {
				cc.append(o);
				cc.append(" ");
			}
		}
		foreach (var s in sources) {
			valac.append(s);
			valac.append(" ");

			vala_files.append(s);
			vala_files.append(" ");

			s = s.replace(".vala", ".c");
			s = s.replace(".gs", ".c");

			cc.append(s);
			cc.append(" ");

			c_files.append(s);
			c_files.append(" ");
			
		}

	}

	static bool spawn(string cmd) {
		
		bool result = false;

		try {
			string[] spawn_args = cmd.split(" "); 
			string[] spawn_env = Environ.get();
			string cmd_stdout;
			string cmd_stderr;
			int cmd_status;

			Process.spawn_sync(null, 
								spawn_args,
								spawn_env,
								SpawnFlags.SEARCH_PATH,
								null,
								out cmd_stdout,
								out cmd_stderr,
								out cmd_status);

			if (cmd_status != 0)
				stdout.puts(cmd_stderr);
			stdout.puts(cmd_stdout);
			result = cmd_status == 0;

		} catch (SpawnError e) {
			stdout.printf("Error: %s\n", e.message);
		}
		return result;
		
	}


	/**
	 * encodeURIComponent
	 * 
	 * prevents the cli from expanding flags, quotes and paths in parameter list
	 */
	static string encodeURIComponent(string str) {
		//  Regex rx = new Regex("\\-");

		var result = Uri.escape_string(str);
		// we also need to process hyphens to prevent command line flag expansion
		return (new Regex("\\-")).replace(result, result.length, 0, "%2D");
	}

	/**
	 * get Environment variable
	 */
	public static string getEnv(string name) {
		string stdout_;
		string stderr_;
		int status;
		string match = name+"=";
		try {
			Process.spawn_command_line_sync ("printenv", out stdout_, out stderr_, out status);
			foreach (var v in stdout_.split("\n")) {
				if (v.substring(0,match.length) == match) {
					return v.substring(match.length);
				}
			}
			return "";
		} catch (SpawnError e) {
			return null;
		}	
	}	
	//  public static string readFile(string name) {
	//  	string stdout;
	//  	string stderr;
	//  	int status;
	//  	string result;
	//  	try {
	//  		Process.spawn_command_line_sync (@"cat $(name)", 
	//  			out stdout, out stderr, out status);
	//  		return stdout;
	//  	} catch (SpawnError e) {
	//  		return null;
	//  	}	
	//  }	
	//  public static bool writeFile(string name, string content) {
	//  	string stdout;
	//  	string stderr;
	//  	int status;
	//  	string result;
	//  	try {
	//  		Process.spawn_command_line_sync (@"$(plugin)/write $(name) \"$(encodeURIComponent(content))\""); 
	//  			out stdout, out stderr, out status);
	//  		return true;
	//  	} catch (SpawnError e) {
	//  		return false;
	//  	}	
	//  }	
}