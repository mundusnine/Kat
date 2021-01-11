package;

import kat.UIManager;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	
	public static var uiMain:UIManager;

	static function update(): Void {
		if(uiMain != null){
			uiMain.update();
		}
	}

	static function render(frames: Array<Framebuffer>): Void {
		// As we are using only 1 window, grab the first framebuffer
		final fb = frames[0];
		// Now get the `g2` graphics object so we can draw
		final g2 = fb.g2;

		if(uiMain != null){
			uiMain.render(g2);
		}
		
	}

	public static function main() {
		System.start({title: "Kat", width: 1024, height: 768}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames); });
				uiMain = new UIManager();
			});
		});
	}
}
