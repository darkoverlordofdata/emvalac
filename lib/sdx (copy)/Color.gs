/*******************************************************************************
 * Copyright 2017 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
uses SDL.Video
namespace Sdx.Color
	const AliceBlue: SDL.Video.Color = { 0xf0, 0xf8, 0xff, 0xff }
	const AntiqueWhite: SDL.Video.Color = { 0xfa, 0xeb, 0xd7, 0xff }
	const Aqua: SDL.Video.Color = { 0x00, 0xFF, 0x00, 0xFF }
	const Aquamarine: SDL.Video.Color = { 0x7F, 0xff, 0xd4, 0xff }
	const Azure: SDL.Video.Color = { 0xF0, 0xFF, 0xFf, 0xFF }
	const Beige: SDL.Video.Color = { 0xf5, 0xf5, 0xdc, 0xff } 
	const Bisque: SDL.Video.Color = { 0xff, 0xe4, 0xc4, 0xff }
	const Black: SDL.Video.Color = { 0x00, 0x00, 0x00, 0x00 }
	const BlanchedAlmond: SDL.Video.Color = { 0xff, 0xeb, 0xcd, 0xff }
	const Blue: SDL.Video.Color = { 0x00, 0x00, 0xff, 0xff }
	const BlueViolet: SDL.Video.Color = { 0x8a, 0x2b, 0xe2, 0xff }
	const Brown: SDL.Video.Color = { 0xa5, 0x2a, 0x2a, 0xff } 
	const BurlyWood: SDL.Video.Color = { 0xde, 0xb8, 0x87, 0xff }
	const CadetBlue: SDL.Video.Color = { 0x5f, 0x9e, 0xa0, 0xff }
	const Chartreuse: SDL.Video.Color = { 0x7f, 0xff, 0x00, 0xff }
	const Chocolate: SDL.Video.Color = { 0xd2, 0x69, 0x1e, 0xff }
	const Coral: SDL.Video.Color = { 0xff, 0x7f, 0x50, 0xff }
	const CornflowerBlue: SDL.Video.Color = { 0x64, 0x95, 0xed, 0xff }
	const Cornsilk: SDL.Video.Color = { 0xff, 0xf8, 0xdc, 0xff }
	const Crimson: SDL.Video.Color = { 0xdc, 0x14, 0x3c, 0xff }
	const Cyan: SDL.Video.Color = { 0x00, 0xff, 0xff, 0xff }
	const DarkBlue: SDL.Video.Color = { 0x00, 0x00, 0x8b, 0xff }
	const DarkCyan: SDL.Video.Color = { 0x00, 0x8b, 0x8b, 0xff }
	const DarkGoldenrod: SDL.Video.Color = { 0xb8, 0x86, 0x0b, 0xff }
	const DarkGray: SDL.Video.Color = { 0xa9, 0xa9, 0xa9, 0xff }
	const DarkGreen: SDL.Video.Color = { 0x00, 0x64, 0x00, 0xff }
	const DarkKhaki: SDL.Video.Color = { 0xbd, 0xb7, 0x6b, 0xff }
	const DarkMagenta: SDL.Video.Color = { 0x8b, 0x00, 0x8b, 0xff }
	const DarkOliveGreen: SDL.Video.Color = { 0x55, 0x6b, 0x2f, 0xff }
	const DarkOrange: SDL.Video.Color = { 0xff, 0x8c, 0x00, 0xff }
	const DarkOrchid: SDL.Video.Color = { 0x99, 0x32, 0xcc, 0xff }
	const DarkRed: SDL.Video.Color = { 0x8b, 0x00, 0x00, 0xff }
	const DarkSalmon: SDL.Video.Color = { 0xe9, 0x96, 0x7a, 0xff }
	const DarkSeaGreen: SDL.Video.Color = { 0x8f, 0xbc, 0x8b, 0xff }
	const DarkSlateBlue: SDL.Video.Color = { 0x48, 0x3d, 0x8b, 0xff }
	const DarkSlateGray: SDL.Video.Color = { 0x2f, 0x4f, 0x4f, 0xff }
	const DarkTurquoise: SDL.Video.Color = { 0x00, 0xce, 0xd1, 0xff }
	const DarkViolet: SDL.Video.Color = { 0x94, 0x00, 0xd3, 0xff }
	const DeepPink: SDL.Video.Color = { 0xff, 0x14, 0x93, 0xff }
	const DeepSkyBlue: SDL.Video.Color = { 0x00, 0xbf, 0xff, 0xff }
	const DimGray: SDL.Video.Color = { 0x69, 0x69, 0x69, 0xff }
	const DodgerBlue: SDL.Video.Color = { 0x1e, 0x90, 0xff, 0xff }
	const Firebrick: SDL.Video.Color = { 0xb2, 0x22, 0x22, 0xff }
	const FloralWhite: SDL.Video.Color = { 0xff, 0xfa, 0xf0, 0xff }
	const ForestGreen: SDL.Video.Color = { 0x22, 0x8b, 0x22, 0xff }
	const Fuchsia: SDL.Video.Color = { 0xff, 0x00, 0xff, 0xff }
	const Gainsboro: SDL.Video.Color = { 0xdc, 0xdc, 0xdc, 0xff }
	const GhostWhite: SDL.Video.Color = { 0xf8, 0xf8, 0xff, 0xff }
	const Gold: SDL.Video.Color = { 0xff, 0xd7, 0x00, 0xff }
	const Goldenrod: SDL.Video.Color = { 0xda, 0xa5, 0x20, 0xff }
	const Gray: SDL.Video.Color = { 0x80, 0x80, 0x80, 0xff }
	const Green: SDL.Video.Color = { 0x00, 0x80, 0x00, 0xff }
	const GreenYellow: SDL.Video.Color = { 0xad, 0xff, 0x2f, 0xff }
	const Honeydew: SDL.Video.Color = { 0xf0, 0xff, 0xf0, 0xff }
	const HotPink: SDL.Video.Color = { 0xff, 0x69, 0xb4, 0xff }
	const IndianRed: SDL.Video.Color = { 0xcd, 0x5c, 0x5c, 0xff }
	const Indigo: SDL.Video.Color = { 0x4b, 0x00, 0x82, 0xff }
	const Ivory: SDL.Video.Color = { 0xff, 0xff, 0xf0, 0xff }
	const Khaki: SDL.Video.Color = { 0xf0, 0xe6, 0x8c, 0xff }
	const Lavender: SDL.Video.Color = { 0xe6, 0xe6, 0xfa, 0xff }
	const LavenderBlush: SDL.Video.Color = { 0xff, 0xf0, 0xf5, 0xff }
	const LawnGreen: SDL.Video.Color = { 0x7c, 0xfc, 0x00, 0xff }
	const LemonChiffon: SDL.Video.Color = { 0xff, 0xfa, 0xcd, 0xff }
	const LightBlue: SDL.Video.Color = { 0xad, 0xd8, 0xe6, 0xff }
	const LightCoral: SDL.Video.Color = { 0xf0, 0x80, 0x80, 0xff }
	const LightCyan: SDL.Video.Color = { 0xe0, 0xff, 0xff, 0xff }
	const LightGoldenrodYellow: SDL.Video.Color = { 0xfa, 0xfa, 0xd2, 0xff }
	const LightGray: SDL.Video.Color = { 0xd3, 0xd3, 0xd3, 0xff }
	const LightGreen: SDL.Video.Color = { 0x90, 0xee, 0x90, 0xff }
	const LightPink: SDL.Video.Color = { 0xff, 0xb6, 0xc1, 0xff }
	const LightSalmon: SDL.Video.Color = { 0xff, 0xa0, 0x7a, 0xff }
	const LightSeaGreen: SDL.Video.Color = { 0x20, 0xb2, 0xaa, 0xff }
	const LightSkyBlue: SDL.Video.Color = { 0x87, 0xce, 0xfa, 0xff }
	const LightSlateGray: SDL.Video.Color = { 0x77, 0x88, 0x99, 0xff }
	const LightSlateBlue: SDL.Video.Color = { 0x6e, 0x84, 0xae, 0xff }
	const LightSteelBlue: SDL.Video.Color = { 0xb0, 0xc4, 0xde, 0xff }
	const LightYellow: SDL.Video.Color = { 0xff, 0xff, 0xe0, 0xff }
	const Lime: SDL.Video.Color = { 0x00, 0xff, 0x00, 0xff }
	const LimeGreen: SDL.Video.Color = { 0x32, 0xcd, 0x32, 0xff }
	const Linen: SDL.Video.Color = { 0xfa, 0xf0, 0xe6, 0xff }
	const Magenta: SDL.Video.Color = { 0xff, 0x00, 0xff, 0xff }
	const Maroon: SDL.Video.Color = { 0x80, 0x00, 0x00, 0xff }
	const MediumAquamarine: SDL.Video.Color = { 0x66, 0xcd, 0xaa, 0xff }
	const MediumBlue: SDL.Video.Color = { 0x00, 0x00, 0xcd, 0xff }
	const MediumOrchid: SDL.Video.Color = { 0xba, 0x55, 0xd3, 0xff }
	const MediumPurple: SDL.Video.Color = { 0x93, 0x70, 0xdb, 0xff }
	const MediumSeaGreen: SDL.Video.Color = { 0x3c, 0xb3, 0x71, 0xff }
	const MediumSlateBlue: SDL.Video.Color = { 0x7b, 0x68, 0xee, 0xff }
	const MediumSpringGreen: SDL.Video.Color = { 0x00, 0xfa, 0x9a, 0xff }
	const MediumTurquoise: SDL.Video.Color = { 0x48, 0xd1, 0xcc, 0xff }
	const MediumVioletRed: SDL.Video.Color = { 0xc7, 0x15, 0x85, 0xff }
	const MidnightBlue: SDL.Video.Color = { 0x19, 0x19, 0x70, 0xff }
	const MintCream: SDL.Video.Color = { 0xf5, 0xff, 0xfa, 0xff }
	const MistyRose: SDL.Video.Color = { 0xff, 0xe4, 0xe1, 0xff }
	const Moccasin: SDL.Video.Color = { 0xff, 0xe4, 0xb5, 0xff }
	const NavajoWhite: SDL.Video.Color = { 0xff, 0xde, 0xad, 0xff }
	const Navy: SDL.Video.Color = { 0x00, 0x00, 0x80, 0xff }
	const OldLace: SDL.Video.Color = { 0xfd, 0xf5, 0xe6, 0xff }
	const Olive: SDL.Video.Color = { 0x80, 0x80, 0x00, 0xff }
	const OliveDrab: SDL.Video.Color = { 0x6b, 0x8e, 0x23, 0xff }
	const Orange: SDL.Video.Color = { 0xff, 0xa5, 0x00, 0xff }
	const OrangeRed: SDL.Video.Color = { 0xff, 0x45, 0x00, 0xff }
	const Orchid: SDL.Video.Color = { 0xda, 0x70, 0xd6, 0xff }
	const PaleGoldenrod: SDL.Video.Color = { 0xee, 0xe8, 0xaa, 0xff }
	const PaleGreen: SDL.Video.Color = { 0x98, 0xfb, 0x98, 0xff }
	const PaleTurquoise: SDL.Video.Color = { 0xaf, 0xee, 0xee, 0xff }
	const PaleVioletRed: SDL.Video.Color = { 0xdb, 0x70, 0x93, 0xff }
	const PapayaWhip: SDL.Video.Color = { 0xff, 0xef, 0xd5, 0xff }
	const PeachPuff: SDL.Video.Color = { 0xff, 0xda, 0xb9, 0xff }
	const Peru: SDL.Video.Color = { 0xcd, 0x85, 0x3f, 0xff }
	const Pink: SDL.Video.Color = { 0xff, 0xc0, 0xcb, 0xff }
	const Plum: SDL.Video.Color = { 0xdd, 0xa0, 0xdd, 0xff }
	const PowderBlue: SDL.Video.Color = { 0xb0, 0xe0, 0xe6, 0xff }
	const Purple: SDL.Video.Color = { 0x80, 0x00, 0x80, 0xff }
	const Red: SDL.Video.Color = { 0xff, 0x00, 0x00, 0xff }
	const RosyBrown: SDL.Video.Color = { 0xbc, 0x8f, 0x8f, 0xff }
	const RoyalBlue: SDL.Video.Color = { 0x41, 0x69, 0xe1, 0xff }
	const SaddleBrown: SDL.Video.Color = { 0x8b, 0x45, 0x13, 0xff }
	const Salmon: SDL.Video.Color = { 0xfa, 0x80, 0x72, 0xff }
	const SandyBrown: SDL.Video.Color = { 0xf4, 0xa4, 0x60, 0xff }
	const SeaGreen: SDL.Video.Color = { 0x2e, 0x8b, 0x57, 0xff }
	const SeaShell: SDL.Video.Color = { 0xff, 0xf5, 0xee, 0xff }
	const Sienna: SDL.Video.Color = { 0xa0, 0x52, 0x2d, 0xff }
	const Silver: SDL.Video.Color = { 0xc0, 0xc0, 0xc0, 0xff }
	const SkyBlue: SDL.Video.Color = { 0x87, 0xce, 0xeb, 0xff }
	const SlateBlue: SDL.Video.Color = { 0x6a, 0x5a, 0xcd, 0xff }
	const SlateGray: SDL.Video.Color = { 0x70, 0x80, 0x90, 0xff }
	const Snow: SDL.Video.Color = { 0xff, 0xfa, 0xfa, 0xff }
	const SpringGreen: SDL.Video.Color = { 0x00, 0xff, 0x7f, 0xff }
	const SteelBlue: SDL.Video.Color = { 0x46, 0x82, 0xb4, 0xff }
	const Tan: SDL.Video.Color = { 0xd2, 0xb4, 0x8c, 0xff }
	const Teal: SDL.Video.Color = { 0x00, 0x80, 0x80, 0xff }
	const Thistle: SDL.Video.Color = { 0xd8, 0xbf, 0xd8, 0xff }
	const Tomato: SDL.Video.Color = { 0xff, 0x63, 0x47, 0xff }
	const Turquoise: SDL.Video.Color = { 0x40, 0xe0, 0xd0, 0xff }
	const Violet: SDL.Video.Color = { 0xee, 0x82, 0xee, 0xff }
	const Wheat: SDL.Video.Color = { 0xf5, 0xde, 0xb3, 0xff }
	const White: SDL.Video.Color = { 0xff, 0xff, 0xff, 0xff }
	const WhiteSmoke: SDL.Video.Color = { 0xf5, 0xf5, 0xf5, 0xff }
	const Yellow: SDL.Video.Color = { 0xff, 0xff, 0x00, 0xff }
	const YellowGreen: SDL.Video.Color = { 0x9a, 0xcd, 0x32, 0xff }
		
