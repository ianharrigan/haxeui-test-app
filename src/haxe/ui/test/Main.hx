package haxe.ui.test;

import flash.display.Loader;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.resources.ResourceManager;

class Main {
	public static function main() {
		#if android
			Macros.addStyleSheet("styles/gradient/gradient_mobile.css");
		#else
			Macros.addStyleSheet("styles/gradient/gradient.css");
		#end
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new TestController().view);
		});
	}
}
