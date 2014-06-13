package haxe.ui.test;

import flash.display.Loader;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.TabBar;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.themes.GradientTheme;

class Main {
	public static function main() {
		//Toolkit.theme = new GradientTheme();
		Toolkit.setTransitionForClass(Stack, "none");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new TestController().view);
		});
	}
}
