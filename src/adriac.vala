/**
 * adriac - valac wrapper to compile Compact Vala
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
 * breaks valac into 3 steps with pre/post processing
 * 
 * 1 (copy src out of tree) - external job
 * 
 * 2 preprocess vala
 * 3 run valac to generate c code
 * 4 preprocess c
 * 
 * 5 (run emcc / clang / ndk ... ) - external job
 * 
 * 
 * Adds 1 new option:
 * --builddir=DIRECTORY
 * 		required location for out of tree build
 * 		!no in tree builds allowed!
 * 
 * Limitations - some stuff isn't fully supported, so it's been dropped:
 * 	no genie support
 *  no support for creating generic classes
 * 
 * use case: emscripten, android, windows
 * 
 * using the command line interface described in valacompiler.vala
 * @see https://github.com/GNOME/vala/blob/master/compiler/valacompiler.vala 
 */

using GLib;
/**
 * Based on the coffeecript prototype. Main difference is pcre syntax.
 */

class Adriac {

	public static string plugin;
	public static string builddir;
	public static string basedir;
	public static string directory;
	public static bool version;
	public static bool api_version;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] sources;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] vapi_directories;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] gir_directories;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] metadata_directories;
	public static string vapi_filename;
	public static string library;
	public static string shared_library;
	public static string gir;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] packages;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] fast_vapis;
	public static string target_glib;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] gresources;

	public static bool ccode_only;
	public static string header_filename;
	public static bool use_header;
	public static string internal_header_filename;
	public static string internal_vapi_filename;
	public static string fast_vapi_filename;
	public static bool vapi_comments;
	public static string symbocmd_filename;
	public static string includedir;
	public static bool compile_only;
	public static string output;
	public static bool debug;
	public static bool thread;
	public static bool mem_profiler;
	public static bool disable_assert;
	public static bool enable_checking;
	public static bool deprecated;
	public static bool hide_internal;
	public static bool experimental;
	public static bool experimental_non_null;
	public static bool gobject_tracing;
	public static bool disable_since_check;
	public static bool disable_warnings;
	public static string cc_command;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] cc_options;
	public static string pkg_config_command;
	public static string dump_tree;
	public static bool save_temps;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] defines;
	public static bool quiet_mode;
	public static bool verbose_mode;
	public static string profile;
	public static bool nostdpkg;
	public static bool enable_version_header;
	public static bool disable_version_header;
	public static bool fatal_warnings;
	public static bool disable_colored_output;
	public static string dependencies;

	public static string entry_point;

	public static bool run_output;

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
			var SDK = GLib.Environment.get_variable("ZEROG");
			stdout.printf (@"adriac 0.2.0 -- [$(SDK)]\n");
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


		var parser = build(new Parser(builddir, cc_command));
		if (!parser.createBuildDir()) return 1;
		if (!parser.preProcessVala()) return 1;
		if (!parser.compileVala()) return 1;
		if (!parser.preProcessC()) return 1;
		if (!parser.compileC()) return 1;

		/**
		 * handled in cmake
		 */
		//  if (cc_command != "jni") if (!parser.compileC()) return 1;
		
		stdout.printf("adriac complete.\n");
		return 0;
	}

	/** 
	 * Configures a parser using the command line parameters 
	 */
	public static Parser build(Parser parser) {
		parser.addValacCommand("--ccode ");
		if (cc_command == "clang" && (output == null ? -1 : output.index_of(".ll")) != -1) {
			parser.addCcCommand("-S -emit-llvm ");	
		}
		if (quiet_mode) parser.addValacCommand("--quiet ");
		if (verbose_mode)  {
			parser.addValacCommand("--verbose ");
			parser.addCcCommand("-v ");
		}
		if (vapi_comments) parser.addValacCommand("--vapi-comments ");
		if (compile_only) parser.addValacCommand("--compile-only ");
		if (api_version) parser.addValacCommand("--api-version ");
		if (use_header) parser.addValacCommand("--use-header ");
		if (debug) parser.addValacCommand("--debug ");
		if (thread) parser.addValacCommand("--thread ");
		if (mem_profiler) parser.addValacCommand("--enable-mem-profiler ");
		if (disable_assert) parser.addValacCommand("--disable-assert ");
		if (enable_checking) parser.addValacCommand("--enable-checking ");
		if (deprecated) parser.addValacCommand("--enable-deprecated ");
		if (hide_internal) parser.addValacCommand("--hide-internal ");
		if (experimental) parser.addValacCommand("--enable-experimental ");
		if (experimental_non_null) parser.addValacCommand("--enable-experimental-non-null ");
		if (gobject_tracing) parser.addValacCommand("--enable-gobject-tracing ");
		if (disable_since_check) parser.addValacCommand("--disable-since-check ");
		if (disable_warnings) parser.addValacCommand("--disable-warnings ");
		if (nostdpkg) parser.addValacCommand("--nostdpkg ");
		if (enable_version_header) parser.addValacCommand("--enable-version-header ");
		if (disable_version_header) parser.addValacCommand("--disable-version-header ");
		if (fatal_warnings) parser.addValacCommand("--fatal-warnings ");
		if (disable_colored_output) parser.addValacCommand("--no-color ");

		if (basedir != null) {
			parser.addValacCommand("--basedir ");
			parser.addValacCommand(basedir);
			parser.addValacCommand(" ");
		}

		if (directory != null) {
			parser.addValacCommand("--directory ");
			parser.addValacCommand(directory);
			parser.addValacCommand(" ");
		}

		if (vapi_directories != null) {
			foreach (var v in vapi_directories) {
				parser.addValacCommand("--vapidir ");
				parser.addValacCommand(v);
				parser.addValacCommand(" ");
			}
		} 
		if (gir_directories != null) {
			foreach (var g in gir_directories) {
				parser.addValacCommand("--girdir ");
				parser.addValacCommand(g);
				parser.addValacCommand(" ");
			}
		}
		if (metadata_directories != null) {
			foreach (var m in metadata_directories) {
				parser.addValacCommand("--metadatadir ");
				parser.addValacCommand(m);
				parser.addValacCommand(" ");
			}
		}
		if (vapi_filename != null) {
			parser.addValacCommand("--vapi ");
			parser.addValacCommand(vapi_filename);
			parser.addValacCommand(" ");
		}

		if (library != null) {
			parser.addValacCommand("--library ");
			parser.addValacCommand(library);
			parser.addValacCommand(" ");
		}
		if (shared_library != null) {
			parser.addValacCommand("--shared-library ");
			parser.addValacCommand(shared_library);
			parser.addValacCommand(" ");
		}
		if (gir != null) {
			parser.addValacCommand("--gir ");
			parser.addValacCommand(gir);
			parser.addValacCommand(" ");
		}
		if (fast_vapis != null) {
			foreach (var f in fast_vapis) {
				parser.addValacCommand("--fast-vapi ");
				parser.addValacCommand(f);
				parser.addValacCommand(" ");
			}
		}
		if (target_glib != null) {
			parser.addValacCommand("--target-glib ");
			parser.addValacCommand(target_glib);
			parser.addValacCommand(" ");
		}
		if (gresources != null) {
			foreach (var g in gresources) {
				parser.addValacCommand("--gresources ");
				parser.addValacCommand(g);
				parser.addValacCommand(" ");
			}
		}
		if (header_filename != null) {
			parser.addValacCommand("--header-filename ");
			parser.addValacCommand(header_filename);
			parser.addValacCommand(" ");
		}
		if (internal_header_filename != null) {
			parser.addValacCommand("--internal-header ");
			parser.addValacCommand(internal_header_filename);
			parser.addValacCommand(" ");
		}
		if (internal_vapi_filename != null) {
			parser.addValacCommand("--internal-vapi ");
			parser.addValacCommand(internal_vapi_filename);
			parser.addValacCommand(" ");
		}
		if (fast_vapi_filename != null) {
			parser.addValacCommand("--fast-vapi ");
			parser.addValacCommand(fast_vapi_filename);
			parser.addValacCommand(" ");
		}
		if (symbocmd_filename != null) {
			parser.addValacCommand("--symbols ");
			parser.addValacCommand(symbocmd_filename);
			parser.addValacCommand(" ");
		}
		if (includedir != null) {
			parser.addValacCommand("--includedir ");
			parser.addValacCommand(includedir);
			parser.addValacCommand(" ");
		}
		if (pkg_config_command != null) {
			parser.addValacCommand("--pkg-config ");
			parser.addValacCommand(pkg_config_command);
			parser.addValacCommand(" ");
		}
		if (dump_tree != null) {
			parser.addValacCommand("--dump-tree ");
			parser.addValacCommand(dump_tree);
			parser.addValacCommand(" ");
		}
		if (defines != null) {
			foreach (var d in defines) {
				parser.addValacCommand("--define ");
				parser.addValacCommand(d);
				parser.addValacCommand(" ");
			}
		}
		if (profile != null) {
			parser.addValacCommand("--profile ");
			parser.addValacCommand(profile);
			parser.addValacCommand(" ");
		}

		if (packages != null) {
			foreach (var p in packages) {
				parser.addValacCommand("--pkg ");
				parser.addValacCommand(p);
				parser.addValacCommand(" ");
				switch (p) {

					case "sdl2":
						if (cc_command == "emcc") {
							parser.addCcCommand("-s USE_SDL=2 " );
						}
						break;

					case "SDL2_image":
						if (cc_command == "emcc") {
							parser.addCcCommand("-s USE_SDL_IMAGE=2 ");
							parser.addCcCommand("-s SDL2_IMAGE_FORMATS='[\"png\"]' ");
						}
						break;

					case "SDL2_ttf":
						if (cc_command == "emcc") {
							parser.addCcCommand("-s USE_SDL_TTF=2 ");
						}
						break;

                    case "emscripten":
						if (cc_command == "emcc") {
							//  parser.addCcCommand("-s ALLOW_MEMORY_GROWTH=1 ");
							//  parser.addCcCommand("-s TOTAL_MEMORY=16777216 "); // 16mb
							parser.addCcCommand("-s TOTAL_MEMORY=33554432 "); // 32 mb
							//  parser.addCcCommand("-s TOTAL_MEMORY=268435456 "); // 256mb mobile max?
							//  parser.addCcCommand("-s TOTAL_MEMORY=536870912 "); // 512mb desktop max?
							parser.addCcCommand("-s WASM=1 ");
							parser.addCcCommand("-s ASSERTIONS=1 ");
							parser.addCcCommand("-s EXPORTED_FUNCTIONS='[\"_game\"]' ");
							parser.addCcCommand("--preload-file assets ");
						}
						break;
				}
			}
		}
		if (output != null) {
			parser.addCcCommand("-o ");
			parser.addCcCommand(output);
			parser.addCcCommand(" ");
		}
		if (cc_options != null) {
			foreach (var o in cc_options) {
				parser.addCcCommand(o);
				parser.addCcCommand(" ");
			}
		}
		foreach (var s in sources) {
			parser.addValacCommand(s);
			parser.addValacCommand(" ");

			parser.addValaFile(s);

			s = s.replace(".vala", ".c");
			s = s.replace(".gs", ".c");

			parser.addCcCommand(s);
			parser.addCcCommand(" ");

			parser.addCFile(s);
			
		}
		return parser;

	}

}