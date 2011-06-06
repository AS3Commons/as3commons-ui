package common{

	public class ColorUtil {
		public static function getGradient(hex : Number, amount : uint = 20, direction : String = "bright_to_dark") : Array {
			if (direction == "bright_to_dark") {
				return [lightenBy(hex, amount), darkenBy(hex, amount)];
			} else {
				return [darkenBy(hex, amount), lightenBy(hex, amount)];
			}
		}

		public static function lightenBy(hex : Number, amount : int) : Number {
			return adjustBy(hex, amount);
		}

		public static function darkenBy(hex : Number, amount : int) : Number {
			return adjustBy(hex, -amount);
		}

		public static function hexToString(hex : Number, addHash : Boolean = true) : String {
			var hexString : String = hex.toString(16);
			hexString = ("000000").substr(0, 6 - hexString.length) + hexString;
			if (addHash) hexString = "#" + hexString;
			return hexString.toUpperCase();
		}

		public static function getContrastColor(hex : Number, amount : int) : Number {
			var hsb : Object = hex2Hsb2(hex);
			if (hsb["b"] >= 50) return darkenBy(hex, amount);
			return lightenBy(hex, amount);
		}

		private static function adjustBy(hex : Number, amount : int) : Number {
			var rgb : Object = {r:(hex >> 16) & 0xFF, g:(hex >> 8) & 0xFF, b:hex & 0xFF};

			for (var key : String in rgb) {
				rgb[key] += amount;
				rgb[key] = Math.min(rgb[key], 255);
				rgb[key] = Math.max(rgb[key], 0);
			}

			return (rgb["r"] << 16) + (rgb["g"] << 8) + rgb["b"];
		}

		private static function hex2Hsb2(hex : Number) : Object {
			var rgb : Object = {r:(hex >> 16) & 0xFF, g:(hex >> 8) & 0xFF, b:hex & 0xFF};

			var hsb : Object = new Object();
			hsb["b"] = Math.max(rgb["r"], rgb["g"], rgb["b"]);
			var min : Number = Math.min(rgb["r"], rgb["g"], rgb["b"]);
			hsb["s"] = (hsb["b"] <= 0) ? 0 : Math.round(100 * (hsb["b"] - min) / hsb["b"]);
			hsb["b"] = Math.round((hsb["b"] / 255) * 100);

			hsb["h"] = 0;
			if ((rgb["r"] == rgb["g"]) && (rgb["g"] == rgb["b"])) {
				hsb["h"] = 0;
			} else if (rgb["r"] >= rgb["g"] && rgb["g"] >= rgb["b"]) {
				hsb["h"] = 60 * (rgb["g"] - rgb["b"]) / (rgb["r"] - rgb["b"]);
			} else if (rgb["g"] >= rgb["r"] && rgb["r"] >= rgb["b"]) {
				hsb["h"] = 60 + 60 * (rgb["g"] - rgb["r"]) / (rgb["g"] - rgb["b"]);
			} else if (rgb["g"] >= rgb["b"] && rgb["b"] >= rgb["r"]) {
				hsb["h"] = 120 + 60 * (rgb["b"] - rgb["r"]) / (rgb["g"] - rgb["r"]);
			} else if (rgb["b"] >= rgb["g"] && rgb["g"] >= rgb["r"]) {
				hsb["h"] = 180 + 60 * (rgb["b"] - rgb["g"]) / (rgb["b"] - rgb["r"]);
			} else if (rgb["b"] >= rgb["r"] && rgb["r"] >= rgb["g"]) {
				hsb["h"] = 240 + 60 * (rgb["r"] - rgb["g"]) / (rgb["b"] - rgb["g"]);
			} else if (rgb["r"] >= rgb["b"] && rgb["b"] >= rgb["g"]) {
				hsb["h"] = 300 + 60 * (rgb["r"] - rgb["b"]) / (rgb["r"] - rgb["g"]);
			} else {
				hsb["h"] = 0;
			}
			hsb["h"] = Math.round(hsb["h"]);

			return hsb;
		}
	}
}